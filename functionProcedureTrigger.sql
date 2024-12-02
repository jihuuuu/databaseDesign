-- 계좌 생성을 20일 이내에 했으면 새로운 계좌 생성을 막음

DELIMITER //

CREATE TRIGGER prevent_multiple_account_creation
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    DECLARE recent_account_count INT;

    -- 20일 이내에 계좌 개설 확인
    SELECT COUNT(*)
    INTO recent_account_count
    FROM account
    WHERE customer_id = NEW.customer_id
      AND created_at >= DATE_SUB(NOW(), INTERVAL 20 DAY);

    -- 최근 20일 내 계좌가 존재하면 에러 발생
    IF recent_account_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '최근 20일 내에 계좌를 개설한 이력이 있습니다. 새 계좌를 개설할 수 없습니다.';
    END IF;
END;
//

DELIMITER ;

-- 잔액 확인 트리거 (이체, 출금시 사용)

DELIMITER //

CREATE TRIGGER prevent_overdraw
BEFORE INSERT ON withdraw
FOR EACH ROW
BEGIN
    DECLARE current_balance BIGINT;

    -- 계좌 잔액 확인
    SELECT balance
    INTO current_balance
    FROM account
    WHERE acc_id = NEW.acc_id;

    -- 출금 금액이 잔액보다 많은 경우 에러 발생
    IF NEW.amount > current_balance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '출금 금액이 현재 계좌 잔액보다 많습니다. 출금할 수 없습니다.';
    END IF;
END;
//

DELIMITER ;

-- 대출시 신용등급 확인

DELIMITER //

CREATE TRIGGER validate_loan_amount
BEFORE INSERT ON loan
FOR EACH ROW
BEGIN
    DECLARE credit_rate TINYINT;
    DECLARE max_loan_amount BIGINT;

    -- 고객 신용 등급 가져오기
    CALL get_credit_rating(NEW.acc_id, credit_rate);

    -- 신용 등급에 따른 최대 대출 가능 금액  (임의로 설정됨)
    CASE credit_rate
        WHEN 1 THEN SET max_loan_amount = 100000000; -- 등급 1: 최대 1억
        WHEN 2 THEN SET max_loan_amount = 50000000;  -- 등급 2: 최대 5천만 원
        WHEN 3 THEN SET max_loan_amount = 20000000;  -- 등급 3: 최대 2천만 원
        ELSE SET max_loan_amount = 10000000;         -- 등급 4: 최대 1천만 원
    END CASE;

    -- 요청 금액이 최대 대출 가능 금액을 초과하는 경우
    IF NEW.amount > max_loan_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '대출 금액이 신용 등급에 따른 최대 대출 가능 금액을 초과했습니다.';
    END IF;
END;
//

DELIMITER ;

-- 신용 점수 등급으로 변환

DELIMITER //

CREATE PROCEDURE get_credit_rating(IN customer_id BIGINT, OUT credit_rate TINYINT)
BEGIN
    -- 신용 점수 기반 신용 등급 변환
    IF EXISTS (SELECT 1 FROM customer_details WHERE details_id = customer_id AND credit_score >= 800) THEN
        SET credit_rate = 1; -- 등급 1 (최우수)
    ELSEIF EXISTS (SELECT 1 FROM customer_details WHERE details_id = customer_id AND credit_score >= 700) THEN
        SET credit_rate = 2; -- 등급 2 (우수)
    ELSEIF EXISTS (SELECT 1 FROM customer_details WHERE details_id = customer_id AND credit_score >= 600) THEN
        SET credit_rate = 3; -- 등급 3 (보통)
    ELSE
        SET credit_rate = 4; -- 등급 4 (위험)
    END IF;
END;
//

DELIMITER ;

-- 고객의 모든 자산을 vip 등급으로 변환

DELIMITER //

CREATE PROCEDURE calculate_vip_status(IN customer_id BIGINT, OUT vip_status TINYINT)
BEGIN
    DECLARE total_balance BIGINT;

    -- 고객 자산(모든 계좌 잔액 합계) 계산
    SELECT SUM(balance) INTO total_balance
    FROM account
    WHERE customer_id = customer_id;

    -- VIP 등급 설정
    IF total_balance >= 100000000 THEN
        SET vip_status = 1; -- VIP
    ELSEIF total_balance >= 50000000 THEN
        SET vip_status = 2; -- 일반
    ELSE
        SET vip_status = 3; -- 비회원
    END IF;
END;
//

DELIMITER ;

-- 가능한 모든 대출 상품 출력

DELIMITER //

CREATE PROCEDURE recommend_loan_goods(IN customer_id BIGINT)
BEGIN
    DECLARE vip_rating TINYINT;
    DECLARE credit_rate TINYINT;

    -- 고객의 VIP 등급 가져오기
    CALL calculate_vip_status(customer_id, vip_rating);

    -- 고객의 신용 등급 가져오기
    SELECT credit_rate INTO credit_rate
    FROM credit_rating
    WHERE customer_id = customer_id;

    -- 대출 상품 추천
    SELECT 
        product_name AS 대출상품명,
        interest_rate AS 이자율,
        min_vip_rating AS 최소VIP등급,
        min_credit_rating AS 최소신용등급
    FROM 
        loan_goods
    WHERE 
        min_vip_rating <= vip_rating
        AND min_credit_rating <= credit_rate;
END;
//

DELIMITER ;

-- 남은 상환액과 만기일로 매달 내야할 상환액 계산

DELIMITER //

CREATE FUNCTION calculate_monthly_payment(loan_id BIGINT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE remaining_balance BIGINT; -- 남은 상환액
    DECLARE repayment_date DATE;      -- 최종 상환 기한
    DECLARE months_remaining INT;     -- 남은 월 수
    DECLARE monthly_payment DECIMAL(10, 2); -- 매달 상환금
    DECLARE today DATE;

    -- 남은 상환액과 상환 기한 가져오기
    SELECT left_repayment, repayment_date 
    INTO remaining_balance, repayment_date
    FROM repayment
    WHERE loan_id = loan_id;

    -- 현재 날짜 가져오기
    SET today = CURDATE();

    -- 남은 월 수 계산
    SET months_remaining = PERIOD_DIFF(
        DATE_FORMAT(repayment_date, '%Y%m'),
        DATE_FORMAT(today, '%Y%m')
    );

    -- 매달 상환금 계산
    SET monthly_payment = remaining_balance / months_remaining;

    -- 결과 반환 (문자열 형태)
    RETURN CONCAT(
        '매달 상환금: ', FORMAT(monthly_payment, 2), '원, ',
        '남은 월 수: ', months_remaining, '개월'
    );
END;
//

DELIMITER ;

-- 정기예금의 종류(d_type)을 받아서 만기일의 잔액 계산

DELIMITER //

CREATE FUNCTION calculate_deposit_with_type(term_dep_id BIGINT, d_type TINYINT)
RETURNS DECIMAL(15, 2)
DETERMINISTIC
BEGIN
    DECLARE principal BIGINT;        -- 원금
    DECLARE annual_rate DECIMAL(5, 2); -- 연 이자율
    DECLARE start_date DATE;         -- 예금 시작일
    DECLARE maturity_date DATE;      -- 만기일
    DECLARE duration_years DECIMAL(5, 2); -- 기간 (연 단위)
    DECLARE total_amount DECIMAL(15, 2);  -- 최종 금액

    -- 예금 정보 가져오기
    SELECT s_amount, d_interestRate, start_date, marturity_date
    INTO principal, annual_rate, start_date, maturity_date
    FROM term_deposit
    WHERE term_dep_id = term_dep_id;

    -- 기간 계산 (연 단위)
    SET duration_years = TIMESTAMPDIFF(MONTH, start_date, maturity_date) / 12;

    -- d_type = 1이면 단리 / 단리 계산: A = P * (1 + r * t)
    IF d_type = 1 THEN
        SET total_amount = principal * (1 + (annual_rate / 100) * duration_years);

    -- d_type = 2이면 복리 / 복리 계산: A = P * (1 + r)^t
    ELSEIF d_type = 2 THEN
        SET total_amount = principal * POWER(1 + (annual_rate / 100), duration_years);

    END IF;

    RETURN total_amount;
END;
//

DELIMITER ;

-- 상환 진행률 % 계산

DELIMITER //

CREATE FUNCTION calculate_repayment_progress(loan_id BIGINT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE total_amount BIGINT;
    DECLARE remaining_amount BIGINT;
    DECLARE progress DECIMAL(5, 2);

    -- 총 대출 금액 가져오기
    SELECT amount INTO total_amount
    FROM loan
    WHERE loan_id = loan_id;

    -- 남은 상환 금액 가져오기
    SELECT left_repayment INTO remaining_amount
    FROM repayment
    WHERE loan_id = loan_id;

    -- 상환 진행률 계산
    RETURN IF(total_amount = 0, 0, (total_amount - remaining_amount) / total_amount * 100);
END;
//

DELIMITER ;

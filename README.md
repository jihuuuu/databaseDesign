#워크벤치와 인텔리제이 설정이 이상해서 생각보다 너무 오래걸렸네요...
#지후님이 하신 AccountManager 참고해서 TransactrionManager 구현햇습니다.

#코드 구현에 워크벤치 문제로 트리거가 사용되지 않았습니다... 추후에 수정하겠습니다.

# 아래 쿼리를 워크벤치에서 실행시켜주세요.
-- transaction, deposit, withdraw, transfer 테이블 드롭
drop table transaction;
drop table deposit;
drop table withdraw;
drop table transfer;

-- 테이블 재생성
-- Transaction 테이블
CREATE TABLE transaction (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY, -- 모든 거래의 고유 ID
    acc_id BIGINT NOT NULL, -- 계좌 ID
    date TIMESTAMP NOT NULL DEFAULT NOW(), -- 거래 일시
    type ENUM('DEPOSIT', 'WITHDRAW', 'TRANSFER') NOT NULL -- 거래 유형
);

-- Deposit 테이블
CREATE TABLE deposit (
    transaction_id BIGINT PRIMARY KEY, -- transaction_id와 동일
    amount DOUBLE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
);

-- Withdraw 테이블
CREATE TABLE withdraw (
    transaction_id BIGINT PRIMARY KEY, -- transaction_id와 동일
    acc_id BIGINT NOT NULL,
    amount DOUBLE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id),
    FOREIGN KEY (acc_id) REFERENCES account(acc_id)
);

-- Transfer 테이블
CREATE TABLE transfer (
    transaction_id BIGINT PRIMARY KEY, -- transaction_id와 동일
    sender_acc_id BIGINT NOT NULL, -- 송금 계좌 ID
    receiver_acc_id BIGINT NOT NULL, -- 수취 계좌 ID
    amount DOUBLE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id),
    FOREIGN KEY (sender_acc_id) REFERENCES account(acc_id),
    FOREIGN KEY (receiver_acc_id) REFERENCES account(acc_id)
);

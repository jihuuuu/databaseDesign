# 기본적인 테스트는 끝났습니다! 예외 처리는 하지 않았습니다.

# 아래 쿼리를 워크벤치에서 실행해 주세요!
ALTER TABLE account
ADD COLUMN balance BIGINT NOT NULL DEFAULT 0;
RENAME TABLE Untitled2 TO loan_goods;
ALTER TABLE loan_goods
ADD COLUMN product_name VARCHAR(100) NOT NULL AFTER loan_type_id, -- 대출 상품 이름
ADD COLUMN min_vip_rating TINYINT NOT NULL DEFAULT 1 AFTER product_name, -- 최소 VIP 등급
ADD COLUMN min_credit_rating TINYINT NOT NULL DEFAULT 1 AFTER min_vip_rating; -- 최소 신용 등급
ALTER TABLE loan_goods
DROP COLUMN Field;
ALTER TABLE loan_goods
ADD COLUMN interest_rate SMALLINT NOT NULL DEFAULT 0 AFTER min_credit_rating;

# 구현한 것 중 몇몇 개는 PK, FK 관계를 설정하셔야 제대로 실행됩니다. 본인 맡으신 부분은 PK, FK 모두 설정하시고 사용할 함수나 트리거 등에서 attribute 이름이 맞는지 꼭 확인해 주세요!

+ 적금은 매달 납입하는 등의 로직이 필요한데 이자율 관련한 부분은 정기예금에서 잘 보여줄 수 있을 거 같아서 구현에서 빼고 상환 진행률을 계산하는 함수를 만들었습니다!
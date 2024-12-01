CREATE TABLE `check_card` (
	`check_card_id`	char(16)	NOT NULL,
	`is_deleted`	boolean	NOT NULL,
	`created_date`	timestamp	NOT NULL
);

CREATE TABLE `account` (
	`acc_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`Field`	enum	NULL,
	`created_at`	timestamp	NULL,
	`password`	VARCHAR(255)	NULL,
	`is_deleted`	VARCHAR(255)	NULL
);

CREATE TABLE `customer` (
	`customer_id`	bigint	NOT NULL,
	`details_id`	bigint	NOT NULL,
	`is_deleted`	boolean	NOT NULL
);

CREATE TABLE `manager` (
	`employee_id`	bigint	NOT NULL,
	`manager_details_id`	bigint	NOT NULL,
	`is_deleted`	boolean	NOT NULL
);

CREATE TABLE `branch` (
	`branch_id`	bigint	NOT NULL,
	`branch_name`	varchar(50)	NULL,
	`Assets`	bigint	NULL
);

CREATE TABLE `savings` (
	`savings_id`	VARCHAR(255)	NOT NULL,
	`s_type`	VARCHAR(255)	NOT NULL,
	`s_interestRate`	VARCHAR(255)	NULL,
	`start_date`	VARCHAR(255)	NOT NULL,
	`marturity_date`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `atm_info` (
	`atm_id`	VARCHAR(255)	NOT NULL,
	`Location`	VARCHAR(255)	NULL
);

CREATE TABLE `flexible_deposit` (
	`flex_dep_id`	VARCHAR(255)	NOT NULL,
	`types`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `loan` (
	`loan_id`	bigint	NOT NULL,
	`loan_type_id`	bigint	NOT NULL,
	`acc_id`	bigint	NOT NULL,
	`start_date`	timestamp	NOT NULL,
	`repayment_date`	timestamp	NOT NULL,
	`amount`	bigint	NULL,
	`is_repayed`	boolean	NOT NULL
);

CREATE TABLE `repayment` (
	`repayment_id`	bigint	NOT NULL,
	`loan_id`	bigint	NOT NULL,
	`amount`	bigint	NOT NULL,
	`left_repayment`	bigint	NULL,
	`updated_at`	timestamp	NOT NULL
);

CREATE TABLE `atm` (
	`atm_his_id`	VARCHAR(255)	NOT NULL,
	`atm_id`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `Work` (
	`work_id`	VARCHAR(255)	NOT NULL,
	`trans_id`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `check_card_history` (
	`history_id`	VARCHAR(255)	NOT NULL,
	`check_card_id`	VARCHAR(255)	NOT NULL,
	`date`	VARCHAR(255)	NOT NULL,
	`amount`	VARCHAR(255)	NULL,
	`item`	VARCHAR(255)	NULL
);

CREATE TABLE `term_deposit` (
	`term_dep_id`	VARCHAR(255)	NOT NULL,
	`d_type`	VARCHAR(255)	NOT NULL,
	`d_interestRate`	VARCHAR(255)	NULL,
	`start_date`	VARCHAR(255)	NULL,
	`marturity_date`	VARCHAR(255)	NOT NULL,
	`s_amount`	VARCHAR(255)	NULL
);

CREATE TABLE `transaction` (
	`transaction_id`	VARCHAR(255)	NOT NULL,
	`acc_id`	VARCHAR(255)	NOT NULL,
	`date`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `deposit` (
	`deposit_id`	VARCHAR(255)	NOT NULL,
	`amount`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `withdraw` (
	`withdraw_id`	VARCHAR(255)	NOT NULL,
	`amount`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `transfer` (
	`transfer_id`	VARCHAR(255)	NOT NULL,
	`acc_id`	VARCHAR(255)	NOT NULL,
	`amount`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `credit_card` (
	`credit_card_id`	char(16)	NOT NULL,
	`limit`	bigint	NULL,
	`created_date`	timestamp	NOT NULL,
	`is_deleted`	boolean	NOT NULL
);

CREATE TABLE `credit_history` (
	`history_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`previous_score`	int	NULL,
	`new_score`	int	NULL,
	`date`	timestamp	NOT NULL,
	`reason`	varchar(100)	NULL
);

CREATE TABLE `customer_details` (
	`details_id`	bigint	NOT NULL,
	`name`	varchar(50)	NULL,
	`social_num`	varchar(13)	NULL,
	`phone_num`	varchar(15)	NULL,
	`address`	varchar(100)	NULL,
	`Field`	smallint	NULL
);

CREATE TABLE `credit_rating` (
	`customer_id`	bigint	NOT NULL,
	`credit_score`	tinyint	NOT NULL,
	`updated_at`	timestamp	NOT NULL
);

CREATE TABLE `account_type` (
	`acc_type_id`	VARCHAR(255)	NOT NULL,
	`acc_id`	VARCHAR(255)	NOT NULL,
	`types`	VARCHAR(255)	NULL
);

CREATE TABLE `acc_history` (
	`acc_his_id`	bigint	NOT NULL,
	`acc_id`	bigint	NOT NULL,
	`balance`	VARCHAR(255)	NULL,
	`updated_at`	VARCHAR(255)	NULL
);

CREATE TABLE `credit_card_history` (
	`history_id`	VARCHAR(255)	NOT NULL,
	`credit_card_id`	VARCHAR(255)	NOT NULL,
	`date`	VARCHAR(255)	NOT NULL,
	`amount`	VARCHAR(255)	NOT NULL,
	`item`	VARCHAR(255)	NULL,
	`update_at`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `card_type` (
	`card_type_id`	bigint	NOT NULL,
	`acc_id`	bigint	NOT NULL,
	`card_id`	bigint	NOT NULL,
	`is_deleted`	boolean	NOT NULL,
	`created_at`	VARCHAR(255)	NOT NULL,
	`marturity_date`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `manager_details` (
	`manager_details_id`	bigint	NOT NULL,
	`name`	varchar(50)	NULL,
	`social_num`	varchar(13)	NULL,
	`phone_num`	varchar(15)	NULL,
	`address`	varchar(100)	NULL,
	`hire_date`	timestamp	NOT NULL,
	`Field`	bigint	NULL
);

CREATE TABLE `manager_branch` (
	`manager_branch_id`	bigint	NOT NULL,
	`employee_id`	bigint	NOT NULL,
	`branch_id`	bigint	NOT NULL,
	`assign_date`	timestamp	NOT NULL
);

CREATE TABLE `Untitled2` (
	`loan_type_id`	bigint	NOT NULL,
	`Field`	smallint	NULL
);

CREATE TABLE `auto_transfer` (
	`auto_transfer_id`	VARCHAR(255)	NOT NULL,
	`acc_id`	VARCHAR(255)	NULL,
	`amount`	VARCHAR(255)	NULL,
	`period`	VARCHAR(255)	NULL,
	`is_deleted`	VARCHAR(255)	NOT NULL
);

ALTER TABLE `check_card` ADD CONSTRAINT `PK_CHECK_CARD` PRIMARY KEY (
	`check_card_id`
);

ALTER TABLE `account` ADD CONSTRAINT `PK_ACCOUNT` PRIMARY KEY (
	`acc_id`
);

ALTER TABLE `customer` ADD CONSTRAINT `PK_CUSTOMER` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `manager` ADD CONSTRAINT `PK_MANAGER` PRIMARY KEY (
	`employee_id`
);

ALTER TABLE `branch` ADD CONSTRAINT `PK_BRANCH` PRIMARY KEY (
	`branch_id`
);

ALTER TABLE `savings` ADD CONSTRAINT `PK_SAVINGS` PRIMARY KEY (
	`savings_id`
);

ALTER TABLE `atm_info` ADD CONSTRAINT `PK_ATM_INFO` PRIMARY KEY (
	`atm_id`
);

ALTER TABLE `flexible_deposit` ADD CONSTRAINT `PK_FLEXIBLE_DEPOSIT` PRIMARY KEY (
	`flex_dep_id`
);

ALTER TABLE `loan` ADD CONSTRAINT `PK_LOAN` PRIMARY KEY (
	`loan_id`
);

ALTER TABLE `repayment` ADD CONSTRAINT `PK_REPAYMENT` PRIMARY KEY (
	`repayment_id`
);

ALTER TABLE `atm` ADD CONSTRAINT `PK_ATM` PRIMARY KEY (
	`atm_his_id`
);

ALTER TABLE `Work` ADD CONSTRAINT `PK_WORK` PRIMARY KEY (
	`work_id`
);

ALTER TABLE `check_card_history` ADD CONSTRAINT `PK_CHECK_CARD_HISTORY` PRIMARY KEY (
	`history_id`
);

ALTER TABLE `term_deposit` ADD CONSTRAINT `PK_TERM_DEPOSIT` PRIMARY KEY (
	`term_dep_id`
);

ALTER TABLE `transaction` ADD CONSTRAINT `PK_TRANSACTION` PRIMARY KEY (
	`transaction_id`
);

ALTER TABLE `deposit` ADD CONSTRAINT `PK_DEPOSIT` PRIMARY KEY (
	`deposit_id`
);

ALTER TABLE `withdraw` ADD CONSTRAINT `PK_WITHDRAW` PRIMARY KEY (
	`withdraw_id`
);

ALTER TABLE `transfer` ADD CONSTRAINT `PK_TRANSFER` PRIMARY KEY (
	`transfer_id`
);

ALTER TABLE `credit_card` ADD CONSTRAINT `PK_CREDIT_CARD` PRIMARY KEY (
	`credit_card_id`
);

ALTER TABLE `credit_history` ADD CONSTRAINT `PK_CREDIT_HISTORY` PRIMARY KEY (
	`history_id`
);

ALTER TABLE `customer_details` ADD CONSTRAINT `PK_CUSTOMER_DETAILS` PRIMARY KEY (
	`details_id`
);

ALTER TABLE `credit_rating` ADD CONSTRAINT `PK_CREDIT_RATING` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `account_type` ADD CONSTRAINT `PK_ACCOUNT_TYPE` PRIMARY KEY (
	`acc_type_id`
);

ALTER TABLE `acc_history` ADD CONSTRAINT `PK_ACC_HISTORY` PRIMARY KEY (
	`acc_his_id`
);

ALTER TABLE `credit_card_history` ADD CONSTRAINT `PK_CREDIT_CARD_HISTORY` PRIMARY KEY (
	`history_id`
);

ALTER TABLE `card_type` ADD CONSTRAINT `PK_CARD_TYPE` PRIMARY KEY (
	`card_type_id`
);

ALTER TABLE `manager_details` ADD CONSTRAINT `PK_MANAGER_DETAILS` PRIMARY KEY (
	`manager_details_id`
);

ALTER TABLE `manager_branch` ADD CONSTRAINT `PK_MANAGER_BRANCH` PRIMARY KEY (
	`manager_branch_id`
);

ALTER TABLE `Untitled2` ADD CONSTRAINT `PK_UNTITLED2` PRIMARY KEY (
	`loan_type_id`
);

ALTER TABLE `auto_transfer` ADD CONSTRAINT `PK_AUTO_TRANSFER` PRIMARY KEY (
	`auto_transfer_id`
);

ALTER TABLE `credit_rating` ADD CONSTRAINT `FK_customer_TO_credit_rating_1` FOREIGN KEY (
	`customer_id`
)
REFERENCES `customer` (
	`customer_id`
);

# 단하님 추가
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


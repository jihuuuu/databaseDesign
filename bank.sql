USE bank;
CREATE TABLE `check_card` (
   `check_card_id`   bigint   NOT NULL,
   `is_deleted`   boolean   NOT NULL,
   `created_date`   timestamp   NOT NULL,
      PRIMARY KEY (`check_card_id`)
);

CREATE TABLE `account` (
   `acc_id`   bigint   NOT NULL,
   `customer_id`   bigint   NOT NULL,
   `Field`   enum('1', '2', '3')   NULL,
   `created_at`   timestamp   NULL,
   `password`   varchar(20)   NULL,
   `is_deleted`   boolean   NULL   DEFAULT FALSE,
   `balance` BIGINT NOT NULL DEFAULT 0,
   PRIMARY KEY (`acc_id`)
);

CREATE TABLE `customer` (
   `customer_id`   bigint   NOT NULL,
   `details_id`   bigint   NOT NULL,
   `is_deleted`   boolean   NOT NULL   DEFAULT FALSE,
   PRIMARY KEY (`customer_id`)
);

CREATE TABLE `manager` (
   `manager_id`   bigint   NOT NULL,
   `manager_details_id`   bigint   NOT NULL,
   `is_deleted`   boolean   NOT NULL   DEFAULT false,
   PRIMARY KEY (`manager_id`)
);

CREATE TABLE `branch` (
   `branch_id`   bigint   NOT NULL,
   `branch_name`   varchar(50)   NULL,
   `Assets`   bigint   NULL,
   PRIMARY KEY (`branch_id`)
);

CREATE TABLE `savings` (
   `savings_id`   bigint   NOT NULL,
   `s_type`   enum('1')   NOT NULL,
   `s_interestRate`   smallint   NULL,
   `start_date`   timestamp   NOT NULL,
   `marturity_date`   timestamp   NOT NULL,
   PRIMARY KEY (`savings_id`)
);

CREATE TABLE `atm_info` (
   `atm_id`   bigint   NOT NULL,
   `Location`   varchar(100)   NULL,
   PRIMARY KEY (`atm_id`)
);

CREATE TABLE `flexible_deposit` (
   `flex_dep_id`   bigint   NOT NULL,
   `types`   enum('1')   NOT NULL,
   PRIMARY KEY (`flex_dep_id`)
);

CREATE TABLE `loan` (
   `loan_id`   bigint   NOT NULL,
   `loan_type_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `start_date`   timestamp   NOT NULL,
   `repayment_date`   timestamp   NOT NULL,
   `amount`   bigint   NULL,
   `is_repayed`   boolean   NOT NULL   DEFAULT false,
   PRIMARY KEY (`loan_id`)
);

CREATE TABLE `repayment` (
   `repayment_id`   bigint   NOT NULL,
   `loan_id`   bigint   NOT NULL,
   `amount`   bigint   NOT NULL,
   `left_repayment`   bigint   NULL,
   `updated_at`   timestamp   NOT NULL,
   PRIMARY KEY (`repayment_id`)
);

CREATE TABLE `atm` (
   `atm_id`   bigint   NOT NULL,
   `atm_info_id`   bigint   NOT NULL,
   PRIMARY KEY (`atm_id`)
);

CREATE TABLE `Work` (
   `work_id`   bigint   NOT NULL,
   `trans_id`   bigint   NOT NULL,
   PRIMARY KEY (`work_id`)
);

CREATE TABLE `check_card_history` (
   `check_his_id`   bigint   NOT NULL,
   `check_card_id`   char(16)   NOT NULL,
   `date`   timestamp   NOT NULL,
   `amount`   bigint   NULL,
   `item`   bigint   NULL,
   PRIMARY KEY (`check_his_id`)
);

CREATE TABLE `term_deposit` (
   `term_dep_id`   bigint   NOT NULL,
   `d_type`   tinyint   NOT NULL,
   `d_interestRate`   smallint   NULL,
   `start_date`   bigint   NULL,
   `marturity_date`   timestamp   NOT NULL,
   `s_amount`   bigint   NULL,
   PRIMARY KEY (`term_dep_id`)
);

CREATE TABLE `transaction` (
   `transaction_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `date`   timestamp   NOT NULL,
   PRIMARY KEY (`transaction_id`)
);

CREATE TABLE `deposit` (
   `deposit_id`   bigint   NOT NULL,
   `amount`   bigint   NOT NULL,
   PRIMARY KEY (`deposit_id`)
);

CREATE TABLE `withdraw` (
   `withdraw_id`   bigint   NOT NULL,
   `acc_id` BIGINT NOT NULL,
   `amount`   bigint   NOT NULL,
   PRIMARY KEY (`withdraw_id`),
   FOREIGN KEY (acc_id) REFERENCES account(acc_id)
);

CREATE TABLE `transfer` (
   `transfer_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `amount`   bigint   NOT NULL,
   PRIMARY KEY (`transfer_id`)
);

CREATE TABLE `credit_card` (
   `credit_card_id`   bigint   NOT NULL,
   `limit`   bigint   NULL,
   `created_date`   timestamp   NOT NULL,
   `is_deleted`   boolean   NOT NULL   DEFAULT false,
   PRIMARY KEY (`credit_card_id`)
);

CREATE TABLE `credit_history` (
   `history_id`   bigint   NOT NULL,
   `customer_id`   bigint   NOT NULL,
   `previous_score`   int   NULL,
   `new_score`   int   NULL,
   `date`   timestamp   NOT NULL,
   `reason`   varchar(100)   NULL,
   PRIMARY KEY (`history_id`)
);

CREATE TABLE `customer_details` (
   `customer_details_id`   bigint   NOT NULL,
   `name`   varchar(50)   NULL,
   `social_num`   varchar(13)   NULL,
   `phone_num`   varchar(15)   NULL,
   `address`   varchar(100)   NULL,
   `credit_score`   smallint   NULL,
   PRIMARY KEY (`customer_details_id`)
);

CREATE TABLE `credit_rating` (
   `customer_id`   bigint   NOT NULL,
   `credit_rate`   tinyint   NOT NULL,
   `updated_at`   timestamp   NOT NULL,
   PRIMARY KEY (`customer_id`)
);

CREATE TABLE `account_type` (
   `acc_type_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `types`   enum('1')   NULL,
   PRIMARY KEY (`acc_type_id`)
);

CREATE TABLE `acc_history` (
   `acc_his_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `balance`   bigint   NULL,
   `updated_at`   timestamp   NULL,
   PRIMARY KEY (`acc_his_id`)
);

CREATE TABLE `credit_card_history` (
   `credit_his_id`   bigint   NOT NULL,
   `credit_card_id`   char(16)   NOT NULL,
   `date`   timestamp   NOT NULL,
   `amount`   bigint   NOT NULL,
   `item`   varchar(100)   NULL,
   `update_at`   tinyint   NOT NULL,
   PRIMARY KEY (`credit_his_id`)
);

CREATE TABLE `card_type` (
   `card_type_id`   bigint   NOT NULL,
   `acc_id`   bigint   NOT NULL,
   `card_id`   char(16)   NOT NULL,
   `is_deleted`   boolean   NOT NULL,
   `created_at`   timestamp   NOT NULL,
   `marturity_date`   timestamp   NOT NULL,
   PRIMARY KEY (`card_type_id`)
);

CREATE TABLE `manager_details` (
   `manager_details_id`   bigint   NOT NULL,
   `name`   varchar(50)   NULL,
   `social_num`   varchar(13)   NULL,
   `phone_num`   varchar(15)   NULL,
   `address`   varchar(100)   NULL,
   `hire_date`   timestamp   NOT NULL,
   `salay`   bigint   NULL,
   PRIMARY KEY (`manager_details_id`)
);

CREATE TABLE `manager_branch` (
   `manager_branch_id`   bigint   NOT NULL,
   `employee_id`   bigint   NOT NULL,
   `branch_id`   bigint   NOT NULL,
   `assign_date`   timestamp   NOT NULL,
   PRIMARY KEY (`manager_branch_id`)
);

CREATE TABLE `loan_goods` (
   `loan_goods_id`   bigint   NOT NULL,
   `product_name` VARCHAR(100) NOT NULL,
   `min_vip_rating` TINYINT NOT NULL DEFAULT 1,
   `min_credit_rating` TINYINT NOT NULL DEFAULT 1,
   `interest_rate` SMALLINT NOT NULL DEFAULT 0,
   PRIMARY KEY (`loan_goods_id`)
);

CREATE TABLE `auto_transfer` (
   `auto_transfer_id`   bigint   NOT NULL,
   `acc_id`   bigint   NULL,
   `amount`   bigint   NULL,
   `period`   tinyint   NULL,
   `is_deleted`   boolean   NOT NULL   DEFAULT false,
   PRIMARY KEY (`auto_transfer_id`)
);

ALTER TABLE `credit_rating` ADD CONSTRAINT `FK_customer_TO_credit_rating_1` FOREIGN KEY (
   `customer_id`
)
REFERENCES `customer` (
   `customer_id`
);
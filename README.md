# Data Analyst Assesment-SQL (CW)

## Overview

This repository contains the solutions to the SQL assessment. The task involves multiple SQL queries to solve real-world business problems related to customer segmentation, transaction analysis, and account inactivity alerts. Each query is accompanied by an explanation of the approach, challenges faced, and solutions implemented.

---

### Question 1: High-Value Customers with Multiple Products

#### Approach:
The goal was to identify customers who have both a **funded savings plan** and a **funded investment plan**.

- I joined the `savings_savingsaccount` and `plans_plan` tables using `owner_id`.
- The query filtered **funded** savings accounts (`sa.new_balance > 0`) and **funded** investment plans (`p.is_a_fund = 1`).
- I used `COUNT(DISTINCT ...)` to count unique plans for each customer.
- The results were grouped by customer `id` and `name`, ordered by the total deposits.

#### Challenge:
- Distinguishing between savings and investment accounts required handling two different plan types. I used `CASE WHEN` to assign the correct plan type based on columns like `is_regular_savings` and `is_a_fund`.

---

### Question 2: Customer Transaction Frequency Segmentation

#### Approach:
The task was to segment customers based on their transaction frequency per month.

- I calculated the **average transactions per customer per month** by counting the transactions and dividing by the number of distinct months.
- A `CASE` statement categorized users into **High**, **Medium**, and **Low Frequency** groups.
- The results were grouped by frequency category and sorted to show high-frequency users first.

#### Challenge:
- The challenge was to handle users with transactions across multiple months. I used `COUNT(DISTINCT DATE_FORMAT(...))` to correctly calculate monthly averages.

---

### Question 3: Account Inactivity Alert

#### Approach:
This query identifies accounts with no **inflow transactions** for over **365 days**.

- I handled both **savings** and **investment** accounts separately by calculating the last transaction date using `MAX(sa.transaction_date)` for savings and `MAX(pl.last_charge_date)` for investment accounts.
- Accounts that haven't had a transaction in the last 365 days were filtered using `HAVING`.
- The number of **inactivity days** was calculated using `DATEDIFF(CURDATE(), last_transaction_date)`.

#### Challenge:
- The difficulty was handling the two different tables with different date fields (`transaction_date` for savings and `last_charge_date` for investments), but I solved it by using `MAX()` and ensuring the correct filtering in the `HAVING` clause.

---

### Question 4: Customer Lifetime Value (CLV) Estimation

#### Approach:
The task was to estimate **Customer Lifetime Value (CLV)** using account tenure and transaction volume.

- I calculated **account tenure** by finding the number of months between the `date_joined` and the current date (`CURDATE()`).
- I calculated **total transactions** by summing the `confirmed_amount` in the `savings_savingsaccount` table.
- The CLV was calculated using the formula:  
  `CLV = (total_transactions / tenure) * 12 * profit_per_transaction`  
  where `profit_per_transaction` is 0.1% (0.001).
- Results were ordered by **CLV** in descending order.

#### Challenge:
- Ensuring that the profit per transaction (0.1%) was applied correctly. I applied simple arithmetic to calculate CLV accurately.

---

## Challenges

1. **Handling Different Account Types**:
   - I had to differentiate between **savings** and **investment** accounts. This was tricky, but I used `CASE WHEN` statements to manage the two types based on relevant columns like `is_regular_savings` and `is_a_fund`.

2. **Frequency Calculation**:
   - In **Question 2**, calculating the **average transactions per month** while ensuring users who made transactions in multiple months were handled correctly was challenging. I solved this using `COUNT(DISTINCT DATE_FORMAT(...))` to get the number of distinct months and then dividing by the total transactions.

3. **Inactivity Filtering**:
   - For **Question 3**, ensuring I correctly flagged accounts with no transactions in the last 365 days required using `MAX()` and `DATEDIFF()` to find the last transaction date and calculate inactivity days accurately.

---

## Conclusion

This assessment gave me the opportunity to apply several SQL techniques such as aggregation, date functions, conditional logic, and table joins. The biggest challenges were handling multiple account types and ensuring the correct calculations for transaction frequencies and inactivity periods. By breaking down each task into manageable steps, I was able to solve the problems efficiently.

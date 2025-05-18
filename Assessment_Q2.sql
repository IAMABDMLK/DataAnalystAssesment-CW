/* 
  Applicant: Abdulmalik Bolaji || abdmlk.911@gmail.com
  Task: SQL Assessment Q2
  Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
  Description: 
    Calculate the average number of transactions per customer per month and categorize them into:
    - High Frequency: ≥10 transactions/month
    - Medium Frequency: 3–9 transactions/month
    - Low Frequency: ≤2 transactions/month
    Return the count of customers in each category and their average transactions per month.
  Date: 18/5/2025
*/

USE adashi_staging;

-- Step 1: Calculate total transactions and average transactions per month for each user
WITH user_txn AS (
    SELECT
        sa.owner_id, 
        COUNT(*) AS txn_count,  -- Total transactions
        COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) AS active_months,  -- Distinct months with transactions
        COUNT(*) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) AS avg_txn_per_month  -- Avg transactions per month
    FROM savings_savingsaccount AS sa
    GROUP BY sa.owner_id
),

-- Step 2: Categorize users based on average transactions per month
user_freq AS (
    SELECT
        owner_id, 
        avg_txn_per_month, 
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_txn
)

-- Step 3: Aggregate results by frequency category
SELECT
    frequency_category,  -- Transaction frequency category (High, Medium, Low)
    COUNT(*) AS customer_count,  -- Number of customers in this category
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month  -- Avg transactions per month in this category
FROM user_freq
GROUP BY frequency_category  -- Group by frequency category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Sort categories

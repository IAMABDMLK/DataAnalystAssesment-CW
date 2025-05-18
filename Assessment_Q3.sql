/* 
  Applicant: Abdulmalik Bolaji || abdmlk.911@gmail.com
  Task: SQL Assessment Q3
  Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
  Description: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).
  Date: 18/5/2025
*/

USE adashi_staging;

-- Step 1: Find savings accounts with no transactions in the last 365 days
SELECT
    sa.savings_id AS plan_id,  -- Savings plan ID
    sa.owner_id,  -- Account owner's ID
    'Savings' AS type,  -- Hardcoded account type
    MAX(sa.transaction_date) AS last_transaction_date,  -- Last recorded transaction date
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days  -- Days since last transaction
FROM savings_savingsaccount sa
WHERE sa.new_balance > 0  -- Only consider funded savings accounts
GROUP BY sa.savings_id, sa.owner_id
HAVING inactivity_days > 365  -- Only include accounts with no transactions in the last 365 days

UNION

-- Step 2: Find investment plans with no transactions in the last 365 days
SELECT
    p.id AS plan_id,  -- Investment plan ID
    p.owner_id,  -- Account owner's ID
    'Investment' AS type,  -- Hardcoded account type
    MAX(p.last_charge_date) AS last_transaction_date,  -- Last recorded charge date
    DATEDIFF(CURDATE(), MAX(p.last_charge_date)) AS inactivity_days  -- Days since last charge
FROM plans_plan p
WHERE p.is_a_fund = 1  -- Only consider investment plans marked as funds
GROUP BY p.id, p.owner_id
HAVING inactivity_days > 365  -- Only include plans with no charges in the last 365 days

-- Step 3: Combine results and order by inactivity days
ORDER BY inactivity_days DESC;

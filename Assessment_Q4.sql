/* 
  Applicant: Abdulmalik Bolaji || abdmlk.911@gmail.com
  Task: SQL Assessment Q4
  Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume.
  Description: For each customer, calculate account tenure, total transactions, and estimate the Customer Lifetime Value (CLV) using a simplified model:
               CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
  Date: 18/5/2025
*/

USE adashing_staging;

-- Step 1: Calculate account tenure, total transactions, and estimated CLV
SELECT 
    u.id AS customer_id,  -- Customer ID (using the 'id' column from the users_customuser table)
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name (concatenating first and last name)
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Account tenure in months (calculated from 'date_joined')
    SUM(sa.confirmed_amount) AS total_transactions,  -- Total transaction volume from 'confirmed_amount'
    
    -- CLV Calculation: (total_transactions / tenure) * 12 * avg_profit_per_transaction
    ROUND((SUM(sa.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * 0.001, 2) AS estimated_clv  -- Profit is 0.1% (0.001)
FROM 
    users_customuser u
-- Join with savings_savingsaccount to calculate total transactions for each user
LEFT JOIN 
    savings_savingsaccount sa ON u.id = sa.owner_id
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined  -- Grouping by customer ID and their name
ORDER BY 
    estimated_clv DESC;  -- Sort by estimated CLV from highest to lowest

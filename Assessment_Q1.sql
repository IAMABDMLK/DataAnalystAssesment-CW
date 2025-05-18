/* 
  Applicant: Abdulmalik Bolaji || abdmlk.911@gmail.com
  Task: SQL Assessment Q1
  Scenario: Identify high-value customers with multiple products (savings and investments)
  Description: This query calculates the number of savings accounts and investment plans for each customer
  and sums their total deposits, categorizing them based on these products.
*/

USE adashi_staging;

-- Common Table Expressions (CTEs) for user data aggregation
WITH user_savings AS (
    -- CTE to count funded savings accounts and total deposits for each user
    SELECT
        sa.owner_id, -- user identifier
        COUNT(sa.new_balance) AS savings_count, -- Count of savings accounts with balance > 0
        SUM(sa.confirmed_amount) AS total_deposits -- Total deposits for each user
    FROM savings_savingsaccount sa
    WHERE sa.new_balance > 0  -- Only consider savings accounts with balance > 0 (funded accounts)
    GROUP BY sa.owner_id  -- Group by user
),

user_investments AS (
    -- CTE to count funded investment plans for each user
    SELECT
        p.owner_id, -- user identifier
        COUNT(p.is_a_fund) AS investment_count -- Count of investment plans marked as a fund
    FROM plans_plan p
    WHERE p.is_a_fund = 1  -- Only include investment plans that are categorized as funds
    GROUP BY p.owner_id  -- Group by user
)

-- Final SELECT query to combine data from the CTEs and the main user table
SELECT 
    u.id,  -- User ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Concatenate first and last name to get full name
    COALESCE(us.savings_count, 0) AS savings_count,  -- Use COALESCE to handle NULL and return 0 for users with no savings accounts
    COALESCE(ui.investment_count, 0) AS investment_count,  -- Use COALESCE to handle NULL and return 0 for users with no investment plans
    COALESCE(us.total_deposits, 0) AS total_deposit  -- Use COALESCE to handle NULL and return 0 for users with no deposits
FROM 
    users_customuser u
-- Left join with the user_savings CTE to get savings account data
LEFT JOIN 
    user_savings us ON us.owner_id = u.id
-- Left join with the user_investments CTE to get investment plan data
LEFT JOIN 
    user_investments ui ON ui.owner_id = u.id
-- Order results by total deposits in descending order
ORDER BY 
    total_deposits DESC;

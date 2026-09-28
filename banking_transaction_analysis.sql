
-- BANKING TRANSACTION ANALYSIS
-- Database: banking_analysis
-- Table: banking_transactions


-- DATA EXPLORATION & QUALITY CHECKS


-- 1. Check the total number of transactions
SELECT COUNT(*) AS total_transactions
FROM banking_transactions;


-- 2. View the structure and data types of the table
DESCRIBE banking_transactions;


-- 3. View sample transaction records
SELECT *
FROM banking_transactions
LIMIT 10;


-- 4. Check for missing values in key columns
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN Account_Number IS NULL THEN 1 ELSE 0 END) AS missing_account_number,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN Transaction_Mode IS NULL THEN 1 ELSE 0 END) AS missing_mode,
    SUM(CASE WHEN Transaction_Type IS NULL THEN 1 ELSE 0 END) AS missing_type,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS missing_date
FROM banking_transactions;


-- 5. Check for duplicate transaction IDs
SELECT
    Transaction_ID,
    COUNT(*) AS duplicate_count
FROM banking_transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;



-- EXPLORATORY DATA ANALYSIS (EDA)


-- 6. Analyze the distribution of transaction modes
SELECT
    Transaction_Mode,
    COUNT(*) AS total_transactions
FROM banking_transactions
GROUP BY Transaction_Mode
ORDER BY total_transactions DESC;


-- 7. Analyze the distribution of transaction types
SELECT
    Transaction_Type,
    COUNT(*) AS total_transactions
FROM banking_transactions
GROUP BY Transaction_Type
ORDER BY total_transactions DESC;


-- 8. Calculate total and average transaction amount
SELECT
    SUM(Transaction_Amount) AS total_transaction_value,
    ROUND(AVG(Transaction_Amount), 2) AS average_transaction_amount
FROM banking_transactions;


-- 9. Find the highest-value transactions
SELECT
    Transaction_ID,
    Account_Name,
    Transaction_Amount,
    Transaction_Mode,
    Transaction_Type,
    Transaction_Date
FROM banking_transactions
ORDER BY Transaction_Amount DESC
LIMIT 10;


-- 10. Analyze transactions by year
SELECT
    YEAR(Transaction_Date) AS transaction_year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_transaction_value
FROM banking_transactions
GROUP BY transaction_year
ORDER BY transaction_year;


-- 11. Analyze transactions by month
SELECT
    MONTH(Transaction_Date) AS transaction_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_transaction_value
FROM banking_transactions
GROUP BY transaction_month
ORDER BY transaction_month;


-- 12. Identify the accounts with the highest transaction value
SELECT
    Account_Number,
    Account_Name,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_transaction_value
FROM banking_transactions
GROUP BY Account_Number, Account_Name
ORDER BY total_transaction_value DESC
LIMIT 10;


-- 13. Identify accounts with the highest number of transactions
SELECT
    Account_Number,
    Account_Name,
    COUNT(*) AS total_transactions
FROM banking_transactions
GROUP BY Account_Number, Account_Name
ORDER BY total_transactions DESC
LIMIT 10;


-- 14. Compare transaction values across transaction modes
SELECT
    Transaction_Mode,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_value,
    ROUND(AVG(Transaction_Amount), 2) AS average_amount
FROM banking_transactions
GROUP BY Transaction_Mode
ORDER BY total_value DESC;


-- 15. Compare transaction values across transaction types
SELECT
    Transaction_Type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_value,
    ROUND(AVG(Transaction_Amount), 2) AS average_amount
FROM banking_transactions
GROUP BY Transaction_Type
ORDER BY total_value DESC;


-- 16. Identify transactions above the average transaction amount
SELECT
    Transaction_ID,
    Account_Name,
    Transaction_Amount,
    Transaction_Type,
    Transaction_Date
FROM banking_transactions
WHERE Transaction_Amount > (
    SELECT AVG(Transaction_Amount)
    FROM banking_transactions
)
ORDER BY Transaction_Amount DESC
LIMIT 20;


-- 17. Analyze transaction activity by day of the week
SELECT
    DAYNAME(Transaction_Date) AS day_of_week,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2) AS total_value
FROM banking_transactions
GROUP BY day_of_week
ORDER BY total_transactions DESC;


-- SQL CONCEPTS DEMONSTRATION

-- 18. CASE: Categorize transactions by amount
SELECT
    Transaction_ID,
    Transaction_Amount,
    CASE
        WHEN Transaction_Amount >= 1000000 THEN 'Very High'
        WHEN Transaction_Amount >= 500000 THEN 'High'
        WHEN Transaction_Amount >= 100000 THEN 'Medium'
        ELSE 'Low'
    END AS transaction_category
FROM banking_transactions
LIMIT 20;


-- 19. CTE: Find accounts with transaction values above the overall average
WITH account_totals AS (
    SELECT
        Account_Number,
        Account_Name,
        SUM(Transaction_Amount) AS total_value
    FROM banking_transactions
    GROUP BY Account_Number, Account_Name
)
SELECT
    Account_Number,
    Account_Name,
    ROUND(total_value, 2) AS total_value
FROM account_totals
WHERE total_value > (
    SELECT AVG(total_value)
    FROM account_totals
)
ORDER BY total_value DESC
LIMIT 10;


-- 20. Subquery: Find transactions above the average amount
SELECT
    Transaction_ID,
    Account_Name,
    Transaction_Amount
FROM banking_transactions
WHERE Transaction_Amount > (
    SELECT AVG(Transaction_Amount)
    FROM banking_transactions
)
ORDER BY Transaction_Amount DESC
LIMIT 10;


-- 21. JOIN: Compare transaction counts and total values by transaction mode
SELECT
    m.Transaction_Mode,
    m.total_transactions,
    v.total_value
FROM (
    SELECT
        Transaction_Mode,
        COUNT(*) AS total_transactions
    FROM banking_transactions
    GROUP BY Transaction_Mode
) AS m
JOIN (
    SELECT
        Transaction_Mode,
        SUM(Transaction_Amount) AS total_value
    FROM banking_transactions
    GROUP BY Transaction_Mode
) AS v
ON m.Transaction_Mode = v.Transaction_Mode
ORDER BY v.total_value DESC;


-- FINAL PROJECT INSIGHTS

-- * Card Out has the highest transaction volume with 215,909 transactions.
-- * NGN to USD is the most common transaction type with 267,515 transactions.
-- * The dataset contains 14.43 trillion in total transaction value, with an average transaction of 13.76 million.
-- * 2020–2023 show relatively stable transaction volumes, while 2024 has unusually high transaction value, likely due to partial data or extreme values.
-- * January has the highest transaction volume with 107,915 transactions.
-- * Card Out has the highest total transaction value at approximately 297.06 billion.
-- * Transaction activity is almost evenly distributed across all seven days, with Saturday having the highest volume.
-- * Individual accounts generally have very few transactions, with the top accounts having only 2 transactions, suggesting the dataset is highly distributed/synthetic.


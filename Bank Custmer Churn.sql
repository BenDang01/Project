-- CLeaning data
-------------------------------------------------
SELECT * 
FROM `Bank Churn`.bank_churn;

-- Check null
SELECT COUNT(*),
	   SUM(CASE WHEN Balance IS NULL THEN 1 ELSE 0 END) AS null_balance,
       SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS null_creditscore,
       SUM(CASE WHEN Exited IS NULL THEN 1 ELSE 0 END) AS null_exited
FROM `Bank Churn`.bank_churn;

-- Check & Remove Duplicates
SELECT CustomerId, COUNT(*)
FROM `Bank Churn`.bank_churn
GROUP BY CustomerId
HAVING COUNT(*) > 1;


-----------------------------------------------------------------------
-- 1. What are the key characteristics of customers who have churned?
-- Total customers vs churned customers
SELECT 
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS  churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100/COUNT(*), 2) AS
FROM `Bank Churn`.bank_churn;

-- Churn Rate by Geography
SELECT 
    Geography,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM `Bank Churn`.bank_churn
GROUP BY Geography;
		
-- Churn Rate by Age Group
SELECT
	CASE
		WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
	END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100/COUNT(*),2) AS churn_rate_percent
FROM `Bank Churn`.bank_churn
GROUP BY age_group
ORDER BY age_group;

-- Churn Rate by Gender
SELECT
	Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100/COUNT(*),2) AS churn_rate_percent
FROM `Bank Churn`.bank_churn
GROUP BY Gender;

-- Churn Rate by Credit Card Ownership
SELECT 
    HasCrCard,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM `Bank Churn`.bank_churn
GROUP BY HasCrCard;

-- Churn Rate by Activity Status
SELECT 
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM `Bank Churn`.bank_churn
GROUP BY IsActiveMember;

-- Average Metrics of Churned vs Retained Customers
SELECT 
    Exited,
    ROUND(AVG(Age), 1) AS avg_age,
    ROUND(AVG(CreditScore), 1) AS avg_creditscore,
    ROUND(AVG(Balance), 2) AS avg_balance,
    ROUND(AVG(EstimatedSalary), 2) AS avg_salary,
    ROUND(AVG(NumOfProducts), 2) AS avg_products
FROM `Bank Churn`.bank_churn
GROUP BY Exited;
    

-----------------------------------------------------------------------
-- 2. What is the churn rate and total balance lost by geography?
SELECT Geography,
-- Total customers in each country
	COUNT(*) AS total_customers,
-- Churned customers in each country
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
-- Churn rate calculation
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate_percent,
-- Total balance lost from churned customers
	ROUND(SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END), 2) AS total_balance_lost
FROM `Bank Churn`.bank_churn
GROUP BY Geography
ORDER BY churn_rate_percent DESC;



-----------------------------------------------------------------------
-- 3. Which customer segment has the highest churn despite high balance or long tenure?
SELECT
  -- Define segment based on balance and tenure
  CASE
    WHEN Balance >= 100000 AND Tenure >= 5 THEN 'High Balance & Long Tenure'
    WHEN Balance >= 100000 AND Tenure < 5 THEN 'High Balance & Short Tenure'
    WHEN Balance < 100000 AND Tenure >= 5 THEN 'Low Balance & Long Tenure'
    ELSE 'Low Balance & Short Tenure'
  END AS customer_segment,

  COUNT(*) AS total_customers,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent

FROM `Bank Churn`.bank_churn
GROUP BY customer_segment
ORDER BY churn_rate_percent DESC;

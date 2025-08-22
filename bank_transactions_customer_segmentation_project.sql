USE mini_project_bank;
SELECT count(*) FROM mini_project_bank.transactions;
SELECT *
FROM transactions
LIMIT 2;

SELECT 
    COUNT(DISTINCT CustomerID) AS total_customers,
    COUNT(DISTINCT CustLocation) AS unique_locations,
    COUNT(TransactionID) AS total_transactions,
    ROUND(AVG(TransactionAmount), 2) AS avg_transaction_amount
FROM transactions;

#Customer Count by City (Identifying key markets)
SELECT CustLocation, COUNT(DISTINCT CustomerID) AS customer_count
FROM transactions
GROUP BY CustLocation
ORDER BY customer_count DESC
LIMIT 10;

#Average Account Balance by City (Identifying wealthier regions on average)
SELECT CustLocation, AVG(CustAccountBalance) AS avg_balance
FROM transactions
GROUP BY CustLocation
ORDER BY avg_balance DESC;

#Total Deposits Held by Location
SELECT CustLocation, SUM(CustAccountBalance) AS total_deposits
FROM transactions
GROUP BY CustLocation
ORDER BY total_deposits DESC
LIMIT 10;

#Average Transaction Amount by Location
#Cities with higher average transaction amounts might be good targets for premium credit cards, personal loan campaigns etc.
SELECT CustLocation, AVG(TransactionAmount) AS average_transaction_amount
FROM transactions
GROUP BY CustLocation
ORDER BY average_transaction_amount DESC;
#The average transaction amount measures the typical spending pattern or purchasing power of an individual in that city.
#It is influenced by wealth/income level. 

#Transaction Frequency by Location (Transaction Activity Level)
SELECT CustLocation, COUNT(DISTINCT(TransactionID)) AS total_transactions
FROM transactions
GROUP BY CustLocation
ORDER BY total_transactions DESC
LIMIT 10;
#Mumbai has the highest active customer base -these customers might be more receptive to digital banking features or loyalty programs.

#Total Transaction Volume by City
SELECT CustLocation, SUM(TransactionAmount) AS total_transaction_amount
FROM transactions
GROUP BY CustLocation
ORDER BY total_transaction_amount DESC
LIMIT 10;
#Which cities drive the most economic activity through the bank. Measures the overall economic activity or market size that the 
#bank facilitates in this city. For example mega cities such as Mumbai have large population size will typically have high total
#volume even if each customer doesn't spend that much.

#Peak Transaction Hours per Location
SELECT CustLocation, HOUR(TransactionTime) AS transaction_hour, COUNT(TransactionID) AS transaction_count
FROM transactions
GROUP BY CustLocation, HOUR(TransactionTime)
ORDER BY transaction_count DESC;

#Getting a Location Level Summary Report by Creating a Procedure
DELIMITER //

CREATE PROCEDURE GetCitySummary2(IN p_customer_location VARCHAR(255))
BEGIN
    -- Use a CTE to pre-calculate all the metrics for the specified city
    WITH CityData AS (
        SELECT
            CustLocation,
            COUNT(DISTINCT CustomerID) AS total_customers,
            SUM(CustAccountBalance) AS total_deposits,
            COUNT(TransactionID) AS total_transactions,
            SUM(TransactionAmount) AS total_volume,
            AVG(TransactionAmount) AS avg_transaction_value
        FROM transactions
        WHERE CustLocation = p_customer_location
        GROUP BY CustLocation
        
    )
    -- Main SELECT that uses the CTE
    SELECT * FROM CityData;
END //

DELIMITER ;
CALL GetCitySummary2('Mumbai');
CALL GetCitySummary2('Bangalore');

#Peak Transaction Months per Location
SELECT CustLocation, MONTH(TransactionDate) AS transaction_month, COUNT(TransactionID) AS transaction_count
FROM transactions
GROUP BY CustLocation, MONTH(TransactionDate)
ORDER BY transaction_count DESC;

#Weekday vs. Weekend Transaction Activity
SELECT
    CASE
        WHEN DAYOFWEEK(TransactionDate) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(TransactionID) AS transaction_count
FROM transactions
GROUP BY day_type;

#RFM Analysis: Segmenting customers based on their transaction behaviour.
#Recency: How recently did a customer transact? (Most recent transaction date)
#Frequency: How often do they transact? (Count of transactions)
#Monetary Value: How much do they spend? (Total amount transacted)

#Calculating the Recency, Frequency and Monetary Value assuming that today's date is 31/12/2016.
#MAX(STR_TO_DATE(TransactionDate, '%d/%m/%Y'))
#This part of the code returns the most recent transaction date for each customer, converted into a proper date format.
#DATEDIFF(earlier_date, later_date) returns later_date - earlier_date.
#The '2016-12-31' part: This is our reference date, acting as "today". Since the dataset is from 2016, 
#we use the last day of the year to calculate how many days have passed since a customer's last transaction until the end of 
#the observation period. Why it's needed: Recency is defined as "how many days ago was the last transaction?".
#A lower number means the customer transacted more recently (which is better).

SELECT CustomerID,
    -- RECENCY: Days since last transaction (assuming today's date is 2016-12-31)
    DATEDIFF('2016-12-31', MAX(STR_TO_DATE(TransactionDate, '%d/%m/%Y'))) AS Recency,
    -- FREQUENCY: Count of transactions
    COUNT(TransactionID) AS Frequency,
    -- MONETARY: Total amount spent/transacted
    SUM(TransactionAmount) AS Monetary
FROM transactions
-- Group by the individual customer to get their metrics
GROUP BY CustomerID
ORDER BY Recency, Monetary DESC; -- Orders results by biggest spenders and most recent

#Grouping the customers into three Segments (1,2,3) with two CTEs(customer_rfm and rfm_scores). The customer_rfm is fed into
#rfm_scores and the final SELECT uses the output rfm_scores. NTILE divides the RFM results into buckets.
WITH customer_rfm AS (
    SELECT 
        CustomerID,
        DATEDIFF('2016-12-31', MAX(STR_TO_DATE(TransactionDate, '%d/%m/%Y'))) AS Recency,
        COUNT(TransactionID) AS Frequency,
        SUM(TransactionAmount) AS Monetary
    FROM transactions
    GROUP BY CustomerID
),
rfm_scores AS (
    SELECT 
        *,
        -- Recency: Lower value is better (3 = most recent, 1 = least recent)
        NTILE(3) OVER (ORDER BY Recency DESC) AS R_Score,
        -- Frequency: Higher value is better (3 = most frequent, 1 = least frequent)
        NTILE(3) OVER (ORDER BY Frequency ASC) AS F_Score,
        -- Monetary: Higher value is better (3 = highest spending, 1 = lowest spending)
        NTILE(3) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM customer_rfm
)
SELECT 
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Cell,
    CASE
        -- Top Tier: Excellent across all dimensions
        WHEN R_Score = 3 AND F_Score = 3 AND M_Score = 3 THEN 'Elite Customers'
                -- Middle Tier: Good performance in some areas
        WHEN R_Score = 3 AND F_Score >= 2 THEN 'Active Regulars'
        WHEN R_Score >= 2 AND M_Score = 3 THEN 'High Value'
        WHEN F_Score = 3 AND M_Score >= 2 THEN 'Frequent Spenders'
                -- New/Low Engagement Tier
        WHEN R_Score = 3 AND F_Score = 1 THEN 'New/Low Engagement'
                -- Bottom Tier: Poor performance across dimensions
        WHEN R_Score = 1 AND F_Score = 1 AND M_Score = 1 THEN 'Inactive Low Value'
                -- At Risk: Were good but declining
        WHEN R_Score = 1 AND (F_Score >= 2 OR M_Score >= 2) THEN 'At Risk'
        
        ELSE 'Average Customers'
    END AS RFM_Segment
FROM rfm_scores
ORDER BY R_Score DESC, F_Score DESC, M_Score DESC;

SELECT 
    transactions_per_customer,
    COUNT(*) AS number_of_customers
FROM (
    SELECT 
        CustomerID, 
        COUNT(TransactionID) AS transactions_per_customer
    FROM transactions
    GROUP BY CustomerID
) AS customer_transaction_counts
GROUP BY transactions_per_customer
ORDER BY transactions_per_customer;


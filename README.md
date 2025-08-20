# MySQL Bank Customer Segmentation Project

## 📊 Project Overview
This project analyzes banking transaction data to segment customers based on their behavior, transaction patterns, and value using SQL. The goal is to derive actionable insights for targeted marketing, customer retention, and service optimization.

## 🔍 Insights to be Explored

### 1. Transaction Behavior per Customer
- Grouping customers according to the frequency and volume of transactions per month.

### 2. Monthly Transaction Trends
- During which months do we have the highest number and volume of transactions?

### 3. Time-Based Segmentation
- At which times during the day do we see the highest number of transactions?

### 4. Monetary Value Segmentation
- Segmenting customers based on the volume and number of transactions.

## 📈 RFM Analysis Framework

### 1. **Recency (R)**
Indicates an active relationship vs. a dormant account.
- **R=5 (Recent)**: Active relationship - active transactions (e.g., a customer who transferred money yesterday)
- **R=1 (Old)**: Dormant account - might be saving-only or about to churn (no transaction activity in 6 months)

### 2. **Frequency (F)**
How often does the customer conduct transactions?
- **F=5 (High-frequency)**: The customer depends heavily on the bank for daily transactions
- **F=1 (Low frequency)**: Occasional user (e.g., quarterly transactions only)

### 3. **Monetary (M)**
How valuable is the customer in terms of account balance and transaction amounts?
- **M=5**: High account balance, large transaction volume
- **M=1**: Low amount of transactions, low account balance
-


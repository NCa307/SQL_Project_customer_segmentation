# MySQL Bank Customer Segmentation Project

## Data Description

This dataset consists of 1 Million+ transaction by over 800K customers for a bank in India for the year 2016. The data contains customer information such as - customer ID, year of birth, location, gender, account balance at the time of the transaction, transaction date, transaction date, transaction time and transaction amount.

## 📊 Project Overview
This project analyzes banking transaction data to segment customers based on their behavior, transaction patterns, and value using SQL. The goal is to derive actionable insights for targeted marketing, customer retention, and service optimization.

## 🔍 Insights to be Explored

### 1. Customer Count By City
- Identifying Key Markets

### 2. Average Account Balance by City
- Identifying wealthier regions on average

### 3. Total Deposits Held by Location
- Sum of Account Balances per City 

### 4. Average Transaction Amount per Location
- Cities with higher average transaction amounts might be good targets for premium credit cards, personal loan campaigns etc.
  
### 5. Transaction Activity Level per Location (Transaction Frequency)

### 6. Total Transaction Volume per Location
-Which cities drive the most economic activity theough the bank? For example mega cities with large population sizes such as Mumbai will typically have higher volume even if each customer doesn't spend that much.

### 7. Peak Transaction Hours (number of transactions) per Location

### 8. Peak Transaction Months (number of transactions) per Location

### 9. Weekday vs. Weekend Activity (number of transactions)

## 📈 RFM Analysis Framework: Segmenting customers based on their transaction behaviour.
### Recency: How recently did a customer transact? (Most recent transaction date)
### Frequency: How often do they transact? (Count of transactions)
### Monetary Value: How much do they spend? (Total amount transacted)

### 1. **Recency (R)**
Indicates an active relationship vs. a dormant account.
- **R=3 (Recent)**: Active relationship - active transactions (e.g., a customer who transferred money yesterday)
- **R=1 (Old)**: Dormant account - might be saving-only or about to churn (e.g. no transaction activity in 6 months)

### 2. **Frequency (F)**
How often does the customer conduct transactions?
- **F=3 (High-frequency)**: The customer depends heavily on the bank for daily transactions
- **F=1 (Low frequency)**: Occasional user (e.g., quarterly transactions only)

### 3. **Monetary (M)**
How valuable is the customer in terms of account balance and transaction amounts?
- **M=3**: High account balance, large transaction volume
- **M=1**: Low amount of transactions, low account balance
### RFM Segments **
# RFM Customer Segmentation Analysis

## Overview
RFM (Recency, Frequency, Monetary) analysis is a powerful marketing technique used to segment customers based on their transaction behavior. This document outlines the 7 key customer segments derived from a 3-tier RFM analysis.

## RFM Segments

### 🥇 1. Elite Customers
**Criteria:** `R_Score = 3 AND F_Score = 3 AND M_Score = 3`  
**Description:** Top-performing customers across all dimensions - most recent, most frequent, and highest spending.

### 🔄 2. Active Regulars  
**Criteria:** `R_Score = 3 AND F_Score >= 2`  
**Description:** Recently active customers with solid engagement frequency.

### 💰 3. High Value
**Criteria:** `R_Score >= 2 AND M_Score = 3`  
**Description:** Big spenders who may be less recent but contribute significant value.

### 🛒 4. Frequent Spenders
**Criteria:** `F_Score = 3 AND M_Score >= 2`  
**Description:** Habitual buyers who transact frequently with consistent value.

### 🌱 5. New / Low Engagement
**Criteria:** `R_Score = 3 AND F_Score = 1`  
**Description:** Recently acquired customers or those with minimal engagement frequency.

### ⚠️ 6. At Risk
**Criteria:** `R_Score = 1 AND (F_Score >= 2 OR M_Score >= 2)`  
**Description:** Previously valuable customers who have become inactive recently.

### 💤 7. Inactive Low Value
**Criteria:** `R_Score = 1 AND F_Score = 1 AND M_Score = 1`  
**Description:** Least valuable and completely inactive customer segment.

## Scoring System
| Score | Recency | Frequency | Monetary |
|-------|---------|-----------|----------|
| 3 | Most Recent | Most Frequent | Highest Spending |
| 2 | Middle Tier | Middle Tier | Middle Tier |
| 1 | Least Recent | Least Frequent | Lowest Spending |

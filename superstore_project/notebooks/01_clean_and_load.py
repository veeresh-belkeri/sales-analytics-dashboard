"""
Sales/Retail Analytics — Data Cleaning & SQL Database Setup
Dataset: Sample Superstore (9,994 real transactions, US retail)
"""
import pandas as pd
import sqlite3

df = pd.read_csv('/home/claude/superstore_project/data/superstore.csv', encoding='latin1')
print("Shape:", df.shape)
print("\nColumns:", list(df.columns))
print("\nNulls:\n", df.isnull().sum()[df.isnull().sum() > 0])
print("\nDuplicate rows:", df.duplicated().sum())

# ---- Clean ----
df['Order Date'] = pd.to_datetime(df['Order Date'], format='%m/%d/%Y')
df['Ship Date'] = pd.to_datetime(df['Ship Date'], format='%m/%d/%Y')
df['Shipping Days'] = (df['Ship Date'] - df['Order Date']).dt.days

# Standardize column names for SQL (no spaces)
df.columns = [c.replace(' ', '_').replace('-', '_') for c in df.columns]

# Feature: Order Year/Month for trend analysis
df['Order_Year'] = df['Order_Date'].dt.year
df['Order_Month'] = df['Order_Date'].dt.to_period('M').astype(str)

# Feature: Profit Margin
df['Profit_Margin_Pct'] = (df['Profit'] / df['Sales'] * 100).round(2)

print("\nDate range:", df['Order_Date'].min(), "to", df['Order_Date'].max())
print("Total Sales: $", round(df['Sales'].sum(), 2))
print("Total Profit: $", round(df['Profit'].sum(), 2))
print("Overall Profit Margin: ", round(df['Profit'].sum() / df['Sales'].sum() * 100, 2), "%")

df.to_csv('/home/claude/superstore_project/data/superstore_clean.csv', index=False)

# ---- Load into a real SQLite database (proof of SQL skill) ----
conn = sqlite3.connect('/home/claude/superstore_project/data/superstore.db')
df.to_sql('orders', conn, if_exists='replace', index=False)
print("\nLoaded into SQLite database: orders table,", len(df), "rows")
conn.close()

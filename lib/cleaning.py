import pandas as pd
import os
print(os.getcwd()) 
# Load the data into a DataFrame
data = pd.read_csv("lib/expenses.csv")

# Remove rows where the Category is "Miscellaneous"
filtered_data = data[data["Category"] != "Miscellaneous"]
filtered_data = filtered_data[filtered_data["Category"] != "Education"]
filtered_data = filtered_data[filtered_data["Category"] != "Health"]
filtered_data = filtered_data[filtered_data["Category"] != "Shopping"]
filtered_data.drop(columns=["Description"], inplace=True)

# Save the filtered data back to a CSV file (optional)
filtered_data.to_csv("filtered_file.csv", index=False)


import pandas as pd

# Original dataset
data = pd.read_csv("filtered_file.csv")

# Convert "Date" column to datetime
data["Date"] = pd.to_datetime(data["Date"])

# Extract the month from the date
data["Month"] = data["Date"].dt.to_period("M").astype(str)  # Format: 'YYYY-MM'

# Group by "Month" and "Category" and sum the "Amount"
grouped_data = data.groupby(["Month", "Category"], as_index=False).agg({"Amount": "sum"})

# Rename columns to match the desired output
grouped_data.rename(columns={"Month": "month", "Amount": "total", "Category": "category"}, inplace=True)
grouped_data.to_csv("grouped.csv", index=False)
# Display the resulting dataset
print(grouped_data)

print(filtered_data)

import pandas as pd

# Read the CSV file
file_path = 'grouped.csv'  # Adjust this if the file path is different
df = pd.read_csv(file_path)

# Parse the 'month' column to datetime and format as 'YYYY-MM'
df['month'] = pd.to_datetime(df['month']).dt.strftime('%Y-%m')

# Extract unique months in sorted order
months = sorted(df['month'].unique().tolist())

# Group by category and prepare data for plotting
category_data = {}
for category, group in df.groupby('category'):
    monthly_totals = group.groupby('month')['total'].sum().reindex(months, fill_value=0)
    total_spent = monthly_totals.sum()
    category_data[category] = {
        'monthlyData': monthly_totals.to_dict(),
        'months': months,
        'totalSpent': total_spent
    }

# Convert data to JSON-like structure for Flutter
import json
with open('flutter_data.json', 'w') as f:
    json.dump(category_data, f, indent=4)

print("Data processed and saved to 'flutter_data.json'.")

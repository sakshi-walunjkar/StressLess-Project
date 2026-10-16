import pandas as pd

# Read the WESAD dataset
df = pd.read_excel('data/WESAD_Stress_Dataset_Final.xlsx')

print("=" * 80)
print("WESAD Dataset Analysis")
print("=" * 80)
print(f"\nDataset Shape: {df.shape}")
print(f"Rows: {df.shape[0]}, Columns: {df.shape[1]}")

print("\n" + "=" * 80)
print("Column Names:")
print("=" * 80)
for i, col in enumerate(df.columns, 1):
    print(f"{i}. {col}")

print("\n" + "=" * 80)
print("First 5 Rows:")
print("=" * 80)
print(df.head())

print("\n" + "=" * 80)
print("Data Types:")
print("=" * 80)
print(df.dtypes)

print("\n" + "=" * 80)
print("Statistical Summary:")
print("=" * 80)
print(df.describe())

print("\n" + "=" * 80)
print("Missing Values:")
print("=" * 80)
print(df.isnull().sum())

print("\n" + "=" * 80)
print("Unique Values in Each Column:")
print("=" * 80)
for col in df.columns:
    print(f"{col}: {df[col].nunique()} unique values")

# Check if there's a stress label column
print("\n" + "=" * 80)
print("Checking for Stress Labels:")
print("=" * 80)
for col in df.columns:
    if 'stress' in col.lower() or 'label' in col.lower() or 'class' in col.lower():
        print(f"\nFound: {col}")
        print(df[col].value_counts())

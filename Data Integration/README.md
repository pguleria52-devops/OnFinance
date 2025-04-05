## External Data Integration (API/ETL Pipeline)

We will implement a serverless ETL pipeline using AWS Lambda, EventBridge, S3, and Secrets Manager to fetch stock price data from a public API, store it in S3, and automate execution.

### Solution Overview
- Public API → Fetch stock price data from the Alpha Vantage API
- Storage → Store data in AWS S3 (JSON format)
- Automation → AWS Lambda + EventBridge Scheduler (Runs every hour)
- Security → API Key stored in AWS Secrets Manager
- Logging & Monitoring → CloudWatch Logs

### Architecture
- Lambda function calls the stock price API
- Extracts stock data and stores it in S3
- Triggered every hour by AWS EventBridge
- API Key is securely stored in AWS Secrets Manager
- Logs & errors are captured in CloudWatch

🔧 Step 1: Store API Key in AWS Secrets Manager
🔹 Store the API key securely
```
aws secretsmanager create-secret --name StockAPIKey --secret-string '{"api_key":"YOUR_ALPHA_VANTAGE_API_KEY"}'
```

🔧 Step 2: Create the Lambda Function
- Fetches stock data
- Stores the response in S3
- Uses Secrets Manager to retrieve the API key

✅ Python Code for Lambda (etl_stock_data.py)
```
import json
import boto3
import requests
import os
from datetime import datetime

# AWS Clients
s3 = boto3.client("s3")
secrets_manager = boto3.client("secretsmanager")

# Load API Key from Secrets Manager
def get_api_key():
    response = secrets_manager.get_secret_value(SecretId="StockAPIKey")
    secret = json.loads(response["SecretString"])
    return secret["api_key"]

# Fetch stock data from Alpha Vantage API
def fetch_stock_data(symbol="AAPL"):
    api_key = get_api_key()
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={symbol}&interval=60min&apikey={api_key}"
    response = requests.get(url)
    return response.json()

# Store data in S3
def store_data_in_s3(data, bucket_name, file_path):
    s3.put_object(Body=json.dumps(data), Bucket=bucket_name, Key=file_path)
    print(f"Data stored in S3: {file_path}")

# Lambda handler
def lambda_handler(event, context):
    bucket_name = os.environ["S3_BUCKET"]
    stock_data = fetch_stock_data()

    timestamp = datetime.utcnow().strftime("%Y-%m-%d_%H-%M-%S")
    file_path = f"stock_data/{timestamp}.json"

    store_data_in_s3(stock_data, bucket_name, file_path)
    
    return {"statusCode": 200, "body": "Data successfully stored in S3"}
```    
🔧 Step 3: Deploy Lambda Function to AWS
🔹 Create an S3 bucket for data storage
```
aws s3 mb s3://onfinance-stock-data
```
🔹 Deploy Lambda with Required IAM Role
```
zip etl_stock_data.zip etl_stock_data.py

aws lambda create-function \
    --function-name FetchStockData \
    --runtime python3.9 \
    --role arn:aws:iam::YOUR_ACCOUNT_ID:role/LambdaExecutionRole \
    --handler etl_stock_data.lambda_handler \
    --timeout 30 \
    --memory-size 128 \
    --environment Variables="{S3_BUCKET=onfinance-stock-data}" \
    --zip-file fileb://etl_stock_data.zip
```    
🔧 Step 4: Automate Execution via AWS EventBridge
🔹 Create a Rule to Trigger Lambda Every Hour
```
aws events put-rule \
    --name HourlyStockDataETL \
    --schedule-expression "rate(1 hour)"
```    
🔹 Add Lambda as Target
```
aws events put-targets --rule HourlyStockDataETL --targets "Id"="1","Arn"="arn:aws:lambda:us-east-1:YOUR_ACCOUNT_ID:function:FetchStockData"
```
🔧 Step 5: Verify the Integration
1. Check Logs
```
aws logs tail /aws/lambda/FetchStockData --follow
```
2. Retrieve Data from S3
```
aws s3 ls s3://onfinance-stock-data/stock_data/
aws s3 cp s3://onfinance-stock-data/stock_data/your-file.json .
cat your-file.json
```
import requests
import json
import boto3
from botocore import UNSIGNED
from botocore.config import Config
import os

s3_bucket_name_from_git = os.environ.get("S3_BUCKET_NAME")
cloudfront_url_from_git = os.environ.get("CLOUDFRONT_URL")

# A. Download JSON from https://dummyjson.com/products
url = "https://dummyjson.com/products"
response = requests.get(url)

# Check if the download was successful (status code 200)
if response.status_code == 200:
    data = response.json()

    # B. Parse the downloaded JSON and find products with prices >= 100
    filtered_products = [product for product in data['products'] if product['price'] >= 100]

    # Specify the keys to include in the output
    keys_to_include = ['id','title','price', 'discountPercentage','thumbnail']

    # Extract only the specified key-value pairs
    filtered_output = [{key: product[key] for key in keys_to_include} for product in filtered_products]

    # Save filtered products to a new JSON file
    output_file_path = "filtered_output.json"
    with open(output_file_path, 'w') as output_file:
        json.dump(filtered_output, output_file, indent=2)
        output_file.close()

    # C. upload the formated JSON file:
        
        #s3_bucket_name = "static-web-terraform-eladbe-prod"
        s3_key = "filtered_output.json"

        s3 = boto3.client('s3',config=Config(signature_version=UNSIGNED))
        s3.upload_file(output_file_path, s3_bucket_name_from_git, s3_key)

        s3_object = s3.get_object(Bucket=s3_bucket_name_from_git, Key=s3_key)
        s3_content = s3_object['Body'].read().decode('utf-8')
        print("S3 File Content:")
        print(s3_content)

        print("S3 File Size:", len(s3_content))
    

    # D. Download the JSON file via CloudFront and print if successful
    session = requests.Session()
    cloudfront_url = f'https://{cloudfront_url_from_git}/{s3_key}'
    cloudfront_response = session.get(cloudfront_url)

    if cloudfront_response.status_code == 200:
        # Change the output file name while saving
        output_file_path_cloudfront = "downloaded_file_from_cloudfront_terraform_ver1.json"
        # Check if the CloudFront response content is not empty
        if cloudfront_response.text:
            with open(output_file_path_cloudfront, 'w') as output_file_cloudfront:
                output_file_cloudfront.write(cloudfront_response.text)
            
            print(f"JSON file downloaded successfully via CloudFront and saved as {output_file_path_cloudfront}.")
        else:
            print("CloudFront response content is empty.")
    else:
        print("Failed to download JSON file via CloudFront. Status code:", cloudfront_response.status_code)
  

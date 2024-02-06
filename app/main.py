import requests
import json
import os

s3_bucket_name_from_git = os.environ.get("S3_BUCKET_NAME")
cloudfront_url_from_git = os.environ.get("CLOUDFRONT_URL")

url = "https://dummyjson.com/products"
response = requests.get(url)


# downloading the file locally, and filterring it according to the requirements:
if response.status_code == 200:
    data = response.json()
    filtered_products = [product for product in data['products'] if product['price'] >= 100]
    keys_to_include = ['id','title','price', 'discountPercentage','thumbnail']
    filtered_output = [{key: product[key] for key in keys_to_include} for product in filtered_products]
    output_file_path = "filtered_output.json"
    with open(output_file_path, 'w') as output_file:
        json.dump(filtered_output, output_file, indent=2)
        output_file.close()

# uploading the filtered file to S3 via CloudFront:

    file_path = "filtered_output.json"
    cloudfront = f'{cloudfront_url_from_git}/'
    with open(file_path, "rb") as file:
        p = requests.put(cloudfront+f'{file_path}',data=file)

    if p.status_code == 200:
        print (f'File was uploaded!')
    else:
        print ("Error!")

# Download the JSON file via CloudFront and print if successful
    session = requests.Session()
    cloudfront_url = f'{cloudfront_url_from_git}/{file_path}'
    cloudfront_response = session.get(cloudfront_url)
    if cloudfront_response.status_code == 200:
        output_file_path_cloudfront = "downloaded_file_from_cloudfront_terraform_ver1.json"
        if cloudfront_response.text:
            with open(output_file_path_cloudfront, 'w') as output_file_cloudfront:
                output_file_cloudfront.write(cloudfront_response.text)
            
            print(f"JSON file downloaded successfully via CloudFront and saved as {output_file_path_cloudfront}.")
            
        else:
            print("CloudFront response content is empty.")
    else:
        print("Failed to download JSON file via CloudFront. Status code:", cloudfront_response.status_code)
  

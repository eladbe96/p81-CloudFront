import requests
import json
import os

cloudfront_url_from_git = os.environ.get("CLOUDFRONT_URL")
commit_sha = os.environ.get("COMMIT_SHA")
url = "https://dummyjson.com/products"

response = requests.get(url)

# downloading the file locally, and filterring it according to the requirements:
if response.status_code == 200:
    data = response.json()
    filtered_products = [product for product in data['products'] if product['price'] >= 100]
    keys_to_include = ['id','title','price', 'discountPercentage','thumbnail']
    filtered_output = [{key: product[key] for key in keys_to_include} for product in filtered_products]
    filtered_file = f'filtered_{commit_sha}.json'
    with open(filtered_file, 'w') as output_file:
        json.dump(filtered_output, output_file, indent=2)
        output_file.close()
        print(f'Prodcuts filtered, file {filtered_file} saved.')

# uploading the filtered file to S3 via CloudFront:
    print ("Uploading file starts:")
    cloudfront = f'https://{cloudfront_url_from_git}/'
    with open(filtered_file, "rb") as file:
        p = requests.put(cloudfront+f'{filtered_file}',data=file)

    if p.status_code == 200:
        print (f'File {filtered_file} was uploaded to S3 via CloudFront!')
    else:
        print ("Error!")

# Download the JSON file via CloudFront and print if successful
    print ("Downloading file starts:")
    session = requests.Session()
    cloudfront_url = f'https://{cloudfront_url_from_git}/{filtered_file}'
    cloudfront_response = session.get(cloudfront_url)
    if cloudfront_response.status_code == 200:
        downloaded_file = f'downloaded_{filtered_file}'
        if cloudfront_response.text:
            with open(downloaded_file, 'w') as output_file_cloudfront:
                output_file_cloudfront.write(cloudfront_response.text)
            print (downloaded_file)
            print(f"{filtered_file} downloaded via CloudFront and saved as {downloaded_file}.")
        else:
            print("Error!")
    else:
        print(f'Failed to download {filtered_file} file via CloudFront. Status code:', cloudfront_response.status_code)
  

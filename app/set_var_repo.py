import requests
import os
api_version = "2022-11-28"
owner = os.environ.get("OWNER")
repo = os.environ.get("REPO")
token = os.environ.get("TOKEN")
s3_bukcet = os.environ.get("S3_BUCKET_NAME")

#Post Var:
url_post = f"https://api.github.com/repos/{owner}/{repo}/actions/variables"
headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": f"Bearer {token}",
    "X-GitHub-Api-Version": api_version
}
data = {
    "name": "s3",
    "value": f'"{s3_bukcet}"'
}
response_post = requests.post(url_post, headers=headers, json=data)
if response_post.status_code == 201:  
    print("Variable created successfully.")
else:
    print(f"Error: {response_post.status_code} - {response_post.text}")


#Get Var:
url_get = f"https://api.github.com/repos/{owner}/{repo}/actions/variables/{variable_name}"
headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": f"Bearer {token}",
    "X-GitHub-Api-Version": api_version
}
response_get = requests.get(url_get, headers=headers)
if response_get.status_code == 200:  
    data = response_get.json()
    print(f"Variable value {data['value']}")
else:
    print(f"Error: {response_get.status_code} - {response_get.text}")
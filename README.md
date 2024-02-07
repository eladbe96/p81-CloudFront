

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)


# Static web with CloudFront

This project is capable to deploy static web hosted on AWS S3 Bucket that can be accessed via CloudFront.

## Prerequisites

To use this project, make sure to meet the following prerequisites:

* AWS Access Key / Secret Key available.
* Terraform Client that will create the project.
* Terragrunt installed

## Cost, Load and Security

### Cost 

We are using the following AWS services:

* **S3** -  we are storing very small files in our project:
    * S3 bucket that contains the artifcat
    * S3 bucket thet contains the terragrunt remote state.
Therefore, we shouldn't pass the lowest price for month, which is "First 50 TB / Month / $0.023 per GB"

* **CloudFront** - As for the data transffer since we are using CloudFront, we shouldn't be charged for the Data transferred out to Amazon CloudFront (CloudFront),
    
    Same goes for the Data transferred in from the internet.

    Resource: https://aws.amazon.com/s3/pricing/

### Security

According to the requirements, the access to the S3 is allowed only via CloudFront, and thus a direct access to the
S3 bucket and its object is blocked.


## Project's Files

* **terragrunt** - Since we are using Terragrunt, we have build the following infrustructure:
```bash
├── live
│   ├── prod
│   │   ├── eu-west-1
│   │   │   ├── cloudfront
│   │   │   │   └── terragrunt.hcl
│   │   │   ├── policy
│   │   │   │   └── terragrunt.hcl
│   │   │   ├── region.hcl
│   │   │   └── s3
│   │   │       └── terragrunt.hcl
│   │   └── terragrunt.hcl
│   └── terragrunt_prod.hcl
└── terraform_source
    ├── cloudfront
    │   ├── main.tf
    │   ├── output.tf
    │   └── vars.tf
    ├── policy
    │   ├── main.tf
    │   └── vars.tf
    └── s3
        ├── main.tf
        ├── output.tf
        └── vars.tf
```
As you can see above, we have build the infrastructure to allow the creation of each main AWS resources seperatley, while taking the advantage
of using terragrunt to keep our code DRY as possible.


* **main.py** - This is the file containing the Python code that is being initated by the GitActions workflow to:

    -- Download the json file from the given URL

    -- Filter the JSON file to contain only the required products according to the requirements

    -- Uploading the filtered file to S3 via CloudFront

    -- Downloading the file from S3 via CloudFront

### Step-by-step guide

* **CI-CD Approach**

    This project contains a built-in CI-CD approach, using GitHub Actions, that is handling the whole
    deployment of the AWS infrastracture and can easily handle any change that needs to be deployed in the future
    to the infra.

    To use this approach, follow the below instructions:

    *  On the toolbar, go to actions
    * On the right side, under "All workflows", choose "Deploy AWS Infra"
        This GithubAction workflow will build the needed resources on AWS.
    * Once done, to upload/download the required JSON file to/from S3 via CloufFront, choose "download the file" workflow.
        The output should contains the requested products list, according to the requirements.

    ![App Screenshot](https://github.com/eladbe96/p81-CloudFront/blob/main/Screenshots/download_file_example.png)

Install Terraform on your client:
```bash
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```
Install terragrunt on your client:
```bash
https://terragrunt.gruntwork.io/docs/getting-started/install/
```

Install and configure AWS CLI on your client:
```bash
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```
```bash
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```
Authenticate the Terraform AWS provider using your IAM credentials:
```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
Clone this repo using 'git-clone':
```bash
git clone https://github.com/eladbe96/p81-CloudFront.git
```
Now we need to deploy our resources one after the other, considering the correct following order:
- s3
- cloudfront
- policy

Move to the folder of the cloned repository, directly to the s3 relevant folder:
```bash
cd p81-CloudFront/live/prod/eu-west-1/s3
```
Initialize the directory and validate your configuration using terragrunt:
```bash
terragrunt plan
terragrunt validate
```
Apply the configuration:
```bash
terragrunt apply
```



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

#### Cost 

We are using the following AWS services:

* **S3** -  we are storing very small files in our project:
1. S3 bucket that contains the artifcat
2. S3 bucket thet contains the terragrunt remote state.
Therefore, we shouldn't pass the lowest price for month, which is "First 50 TB / Month / $0.023 per GB"

* **CloudFront** - As for the data transffer since we are using CloudFront, we shouldn't be charged for the Data transferred out to Amazon CloudFront (CloudFront),
Same goes for the Data transferred in from the internet.

Resource: https://aws.amazon.com/s3/pricing/

#### Security

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

    -- Downloading the file fron S3 via CloudFront

* **vars.tf** - This file contains all the vars we are using in our project and their values. **Please note** that before running the ***'terraform apply'*** for the first time, some values will be empty, as they need to be filled by the User's input. **For example** github_token

* **output.tf** - This file contains the values that will be printed after using ***'terraform apply/plan'*** for an easier/faster reference for the user.

## Step-by-step guide

Clone this repo using 'git-clone':
```bash
git clone https://github.com/eladbe96/SRE-Task-Final.git
```
Install Terraform on your client:
```bash
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
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
Move to the folder of the cloned repository:
```bash
cd SRE-Task-Final
```
Initialize the directory and validate your configuration:
```bash
terraform init
terraform validate
```
Apply the configuration:
```bash
terraform apply
```

## Usage/Examples

Once a pull request is merged to your repo, check for your logs via one of the following:

* CloudWatch logs
* AWS CLI 
* External log viewer(for example: Grafana)

To check via AWS CLI, you can use the following command:
```bash
aws logs filter-log-events --log-group-name "/aws/lambda/function_name" | less
```
In our case, the function name is "github_logger:
```bash
aws logs filter-log-events --log-group-name "/aws/lambda/github_logger" | less
```

### Grafana example:

To view the logs via Grafana, access the below link for the installation according to your Operating System:

```bash
https://grafana.com/grafana/download
```
#### Login
* Open your web browser and go to ***http://localhost:3000/***.
* The default HTTP port that Grafana listens to is 3000 unless you have configured a different port.
* On the sign-in page, enter admin for the username and password.
* Click Sign in.
* If successful, you will see a prompt to change the password.
* Click OK on the prompt and change your password.

#### Adding Data source:

To access the CloudWatch logs via the Grafana dashboard, follow the instructions below:

* Click **Connections** in the left-side menu.
* Under Your connections, click **Data sources**.
* Enter **CloudWatch** in the search bar.
* Click **CloudWatch**.
* Fill in the required displayed configuration.

#### Import Lambda dashboard

* Click Dashboards in the left-side menu.
* Click New and select Import in the dropdown menu.

Perform one of the following steps:

* Upload a dashboard JSON file
* Paste a Grafana.com dashboard URL
* Copy the dashboard's ID

The import process enables you to change the dashboard's name, pick the data source you want the dashboard to use(CloudWatch in our case), and specify any metric prefixes (if the dashboard uses any).


### Accessing the logs

* Click Dashboards in the left-side menu.
* Click New and select **New Dashboard**
* In the next screen, select **Add Visualization."
* Select the **CloudWatch** Data source
* On the right-side menu, select **Table** instead of **Time-series**
* On the bottom left side, under the **Query** section, make sure to configure the query as below:

![Alt text](/Screenshots/Grafana_Query.png?raw=true "Grafana example")

* Once the above is configured, save and apply the changes on the top right-side menu, to view the CloudWatch logs of your Lambda function

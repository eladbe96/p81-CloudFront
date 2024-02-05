import os

s3_bucket_name_from_git = os.environ.get("GITHUB_ENV")

print(f'The bucket name is{s3_bucket_name_from_git}')

                            

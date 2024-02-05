import os

s3_bucket_name_from_git = os.getenv("GITHUB_ENV")

print(f'The bucket name is{s3_bucket_name_from_git}')

                            

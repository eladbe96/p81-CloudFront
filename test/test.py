import os

s3_bucket_name_from_git = os.environ.get("S3_BUCKET_NAME")
s3_bucket_owner_from_git = os.environ.get("S3_BUCKET_OWNER")

print(f'The bucket name is{s3_bucket_name_from_git}')
print(f'The bucket owner is{s3_bucket_owner_from_git}')
                            

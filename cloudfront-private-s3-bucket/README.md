# cloudfront-private-s3-bucket
Demonstration for how to front a private S3 bucket with Cloudfront for public access (limited by source IP address).
1. Copy file to S3 bucket (should be successful)
```
aws s3 cp output.tf s3://tf-djl-private-bucket --profile sfdc_s3
```

2. List the files on the S3 bucket (should be unsuccessful)
```
aws s3 ls s3://tf-djl-private-bucket  --profile sfdc_s3
```

3. Copy the file back down from the S3 bucket (should be unsuccessful)
```
aws s3 cp s3://tf-djl-private-bucket/output.tf new_output.txt  --profile sfdc_s3
```

4. Delete the file on the S3 bucket (should be unsuccessful) 
```
aws s3 rm s3://tf-djl-private-bucket/output.tf --profile sfdc_s3
```

```
aws acm-pca issue-certificate \
    --certificate-authority-arn arn:aws:acm-pca:us-east-1:614129417617:certificate-authority/d7d4c021-3f0a-4f77-86ae-2dbdd803f6dd \
    --csr fileb:///Users/lwdvin/Downloads/S3_Demo_Cert.csr \
    --signing-algorithm SHA256WITHRSA \
    --validity "Value=180,Type=DAYS"


## Helpful Links
  - [S3 Bucket Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
  - [Youtube: Best Practices for Integrating and Securing Salesforce Data with AWS](https://www.youtube.com/watch?v=kVmdCuRcpAg)
  - [Youtube: IAM Roles Anywhere](https://www.youtube.com/watch?v=DOH37VVadlc)
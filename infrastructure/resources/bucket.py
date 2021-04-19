from aws_cdk import aws_s3 as s3
from aws_cdk import core


class Bucket(s3.Bucket):
    def __init__(self, stack: core.Stack, *, bucket_name: str) -> None:
        super().__init__(
            stack,
            "bucket",
            bucket_name=bucket_name,
            removal_policy=core.RemovalPolicy.DESTROY,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            encryption=s3.BucketEncryption.S3_MANAGED,
        )

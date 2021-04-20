from aws_cdk import core

from .resources.bucket import Bucket
from .resources.distribution import Distribution


class WebsiteStack(core.Stack):

    BUCKET_NAME = "how.wtf"
    DOMAIN_NAMES = ["www.how.wtf", "how.wtf"]

    def __init__(self, app: core.App, id: str) -> None:
        super().__init__(app, id)
        bucket: Bucket = Bucket(self, bucket_name=WebsiteStack.BUCKET_NAME)
        distribution: Distribution = Distribution(
            self, bucket=bucket, domain_names=WebsiteStack.DOMAIN_NAMES
        )
        bucket.grant_read(distribution.origin_access_identity)
        core.CfnOutput(
            self,
            "distribution-id",
            value=distribution.distribution_id,
        )

from aws_cdk import core

from .resources.bucket import Bucket
from .resources.distribution import Distribution


class WebsiteStack(core.Stack):
    def __init__(self, app: core.App, id: str) -> None:
        super().__init__(app, id)
        bucket: Bucket = Bucket(self, bucket_name="how.wtf")
        distribution: Distribution = Distribution(
            self, bucket=bucket, domain_names=["www.how.wtf", "how.wtf"]
        )
        bucket.grant_read(distribution.origin_access_identity)

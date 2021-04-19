from typing import Dict, List

import boto3
from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import aws_iam as iam
from aws_cdk import aws_s3 as s3
from aws_cdk import core


class Distribution(cloudfront.CloudFrontWebDistribution):
    def __init__(
        self, stack: core.Stack, *, bucket: s3.Bucket, domain_names: List[str]
    ) -> None:

        origin_access_identity: cloudfront.OriginAccessIdentity = (
            cloudfront.OriginAccessIdentity(stack, "identity")
        )

        super().__init__(
            stack,
            "distribution",
            error_configurations=[
                {
                    "errorCode": s,
                    "responsePagePath": "/error.html",
                    "responseCode": 404,
                }
                for s in [400, 403, 404, 405, 414]
            ],
            alias_configuration=cloudfront.AliasConfiguration(
                acm_cert_ref=self.get_acm_certificate(stack),
                names=domain_names,
                ssl_method=cloudfront.SSLMethod.SNI,
                security_policy=cloudfront.SecurityPolicyProtocol.TLS_V1_2_2019,
            ),
            origin_configs=[
                cloudfront.SourceConfiguration(
                    s3_origin_source=cloudfront.S3OriginConfig(
                        s3_bucket_source=bucket,
                        origin_access_identity=origin_access_identity,
                    ),
                    behaviors=[cloudfront.Behavior(is_default_behavior=True)],
                )
            ],
        )
        self.origin_access_identity = origin_access_identity

    def get_acm_certificate(self, stack: core.Stack) -> str:
        acm: boto3.client = boto3.client("acm")
        response: Dict[str, List[Dict]] = acm.list_certificates(
            CertificateStatuses=["ISSUED"]
        )
        certificates: List[Dict] = response["CertificateSummaryList"]
        certificate_arn: str = next(
            (c["CertificateArn"] for c in certificates if c["DomainName"] == "how.wtf")
        )
        return certificate_arn

from typing import Dict, List

import boto3
from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import aws_s3 as s3
from aws_cdk import core

from .function import Function


class Distribution(cloudfront.CloudFrontWebDistribution):

    ERROR_RESPONSE_PATH = "/error.html"
    DOMAIN_NAME = "how.wtf"

    def __init__(
        self,
        stack: core.Stack,
        *,
        bucket: s3.Bucket,
        domain_names: List[str],
        functions: Dict[str, Function],
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
                    "responsePagePath": Distribution.ERROR_RESPONSE_PATH,
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
                    behaviors=[
                        cloudfront.Behavior(is_default_behavior=True),
                        cloudfront.Behavior(
                            path_pattern="*",
                            function_associations=[
                                cloudfront.FunctionAssociation(
                                    event_type=cloudfront.FunctionEventType.VIEWER_RESPONSE,
                                    function=functions["security-headers"],
                                ),
                            ],
                        ),
                    ],
                )
            ],
        )
        self.origin_access_identity = origin_access_identity

    def get_acm_certificate(self, stack: core.Stack) -> str:
        acm: boto3.client = boto3.client("acm")
        response: Dict[str, List[Dict[str, str]]] = acm.list_certificates(
            CertificateStatuses=["ISSUED"]
        )
        certificates: List[Dict[str, str]] = response["CertificateSummaryList"]
        certificate_arn: str = next(
            (
                c["CertificateArn"]
                for c in certificates
                if c["DomainName"] == Distribution.DOMAIN_NAME
            )
        )
        return certificate_arn

from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import core


class Function(cloudfront.Function):
    def __init__(self, stack: core.Stack, name: str) -> None:
        super().__init__(
            stack,
            name,
            code=cloudfront.FunctionCode.from_file(
                file_path=f"./how.wtf/functions/{name}.js",
            ),
            function_name=name,
        )

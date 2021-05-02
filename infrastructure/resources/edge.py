from aws_cdk import (
    aws_lambda as lambda_,
    core,
)


class EdgeFunction(lambda_.Function):
    def __init__(self, stack: core.Stack, name: str) -> None:
        super().__init__(
            stack,
            name,
            code=lambda_.Code.from_asset(f"./how.wtf/functions/{name}"),
            handler=f"{name}.handler",
            function_name=name,
            runtime=lambda_.Runtime.PYTHON_3_8,
        )
        self.current_version.add_alias("latest")

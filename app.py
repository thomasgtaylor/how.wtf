from aws_cdk import core
from infrastructure.stack import WebsiteStack

app = core.App()
WebsiteStack(app, "how-wtf")

app.synth()

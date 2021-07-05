Title: Deploy Cloudfront Functions to Add Security Headers with AWS CDK
Date: 2021-07-04 9:10
Category: AWS
Tags: AWS CDK, Python, Serverless
Authors: Thomas Taylor
Description: How to deploy Cloudfront functions using the AWS CDK to add security headers to responses.

With the newly published [CloudFront Functions](https://aws.amazon.com/blogs/aws/introducing-cloudfront-functions-run-your-code-at-the-edge-with-low-latency-at-any-scale/), developers can leverage fast and short lived functions to handle simplistic tasks for viewer requests and responses.

The AWS article covers the differences between Lambda@Edge and CloudFront Functions in detail. For a quick reference, here is the table from it:

 |CloudFront Functions|Lambda@Edge
- | - | -
Runtime support | JavaScript (ECMAScript 5.1 compliant) | Node.js / Python
Execution location | 218+ CloudFront Edge Locations | 13 CloudFront Regional Edge Caches
CloudFront triggers supported | Viewer request / Viewer response | Viewer request /Viewer response / Origin request / Origin response
Maximum execution time | Less than 1 millisecond | 5 seconds (viewer triggers) 30 seconds (origin triggers)
Maximum memory | 2MB | 128MB (viewer triggers) / 10GB (origin triggers)
Total package size | 10 KB | 1 MB (viewer triggers) / 50 MB (origin triggers)
Network access | No | Yes
File system access | No | Yes
Access to the request body | No | Yes
Pricing | Free tier available; charged per request | No free tier; charged per request and function duration

# The Cloudfront Function Code

Using Javascript (ECMAScript 5.1 compliant), the following code adds common security headers to viewer responses:

- permissions-policy
- referrer-policy
- strict-transport-security
- x-content-type-options
- x-frame-options
- x-xss-protection

Create a new file named `headers.js`:

```javascript
function handler(event) {
    var response = event.response
    var headers = response.headers;

    headers['permissions-policy'] = {
        value: 'accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()',
    }
    headers['referrer-policy'] = { value: 'same-origin'}; 
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
    headers['x-content-type-options'] = { value: 'nosniff' }; 
    headers['x-frame-options'] = { value: 'DENY' }; 
    headers['x-xss-protection'] = { value: '1; mode=block' }; 

    return response;
};
```

This code was a modified version from the AWS documentation described [here](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-security-headers.html).

# The AWS CDK Code

The production version of the code in this section can be found in the [how.wtf](https://github.com/t-h-o/how.wtf) open source repository.

### Install the AWS CDK dependencies

For this tutorial, version 1.111.0 of the AWS CDK was used. 

### Create a `requirements.txt`

```txt
aws-cdk.aws_cloudfront===1.111.0
aws-cdk.aws_s3===1.111.0
aws-cdk.core===1.111.0
```

### Install the dependencies

```bash
pip3 install -r requirements.txt
```

### Create `app.py`

```python
from aws_cdk import core
from stack import WebsiteStack

app = core.App()
WebsiteStack(app, "website")

app.synth()
```

### Create `cdk.json`

```json
{
    "app": "python3 app.py"
}
```

### Create `stack.py` with a basic S3 Bucket

```python
from aws_cdk import core
from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import aws_s3 as s3

class WebsiteStack(core.Stack):

    def __init__(self, app: core.App, id: str) -> None:
        super().__init__(app, id)

        bucket = s3.Bucket(
            self,
            "bucket",
            website_index_document="index.html",
            public_read_access=True,
            removal_policy=core.RemovalPolicy.DESTROY,
        )
```

### Add the CloudFront Function + Distribution

```python
from aws_cdk import core
from aws_cdk import aws_cloudfront as cloudfront
from aws_cdk import aws_s3 as s3

class WebsiteStack(core.Stack):

    def __init__(self, app, id):
        super().__init__(app, id)

        bucket = s3.Bucket(
            self,
            "bucket",
            website_index_document="index.html",
            public_read_access=True,
            removal_policy=core.RemovalPolicy.DESTROY,
        )

        security_headers = cloudfront.Function(
            self,
            "security_headers",
            code=cloudfront.FunctionCode.from_file(
                file_path="headers.js",
            ),
        )

        distribution = cloudfront.CloudFrontWebDistribution(
            self,
            "cdn",
            origin_configs=[
                cloudfront.SourceConfiguration(
                    s3_origin_source=cloudfront.S3OriginConfig(
                        s3_bucket_source=bucket,
                    ),
                    behaviors=[
                        cloudfront.Behavior(is_default_behavior=True),
                        cloudfront.Behavior(
                            path_pattern="*",
                            function_associations=[
                                cloudfront.FunctionAssociation(
                                    event_type=cloudfront.FunctionEventType.VIEWER_RESPONSE,
                                    function=security_headers,
                                ),
                            ],
                        ),
                    ],
                )
            ],
        )

        core.CfnOutput(
            self,
            "distribution-domain-name",
            value=distribution.distribution_domain_name,
        )
```

### Deploy the stack

```bash
cdk deploy website
```

Because of the `CfnOutput`, the distribution's domain name is exposed via an output on the stack:

```
Outputs:
website.distributiondomainname = hostname.cloudfront.net
```

### Add `index.html` document to the S3 bucket

```html
<h1>Security headers!</h1>
```

### Test the headers

After adding the `index.html` document, visit the distribution's domain name to ensure it is working correctly. 

To test the security headers, either use your favorite request tool or use https://securityheaders.com.
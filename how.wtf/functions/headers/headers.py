# Globally defined vars for lambda caching
PERMISSIONS_POLICY = [
    {
        "key": "Permissions-Policy",
        "value": "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()",
    }
]
REFERRER_POLICY = [{"key": "Referrer-Policy", "value": "same-origin"}]
STRICT_TRANSPORT_SECURITY = [
    {
        "key": "Strict-Transport-Security",
        "value": "max-age=63072000; includeSubdomains; preload",
    }
]
X_CONTENT_TYPE_OPTIONS = [{"key": "X-Content-Type-Options", "value": "nosniff"}]
X_FRAME_OPTIONS = [{"key": "X-Frame-Options", "value": "DENY"}]
X_XSS_PROTECTION = [{"key": "X-XSS-Protection", "value": "1; mode=block"}]


def handler(event, context):
    response = event["Records"][0]["cf"]["response"]
    response["headers"].update(
        {
            "permissions-policy": PERMISSIONS_POLICY,
            "referrer-policy": REFERRER_POLICY,
            "strict-transport-security": STRICT_TRANSPORT_SECURITY,
            "x-content-type-options": X_CONTENT_TYPE_OPTIONS,
            "x-frame-options": X_FRAME_OPTIONS,
            "x-xss-protection": X_XSS_PROTECTION,
        }
    )
    return response

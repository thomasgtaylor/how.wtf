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
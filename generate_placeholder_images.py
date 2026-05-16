import base64
import os

# 1x1 transparent PNG
img_data = b'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='

os.makedirs('assets/images', exist_ok=True)
with open('assets/images/app_logo.png', 'wb') as f:
    f.write(base64.b64decode(img_data))
with open('assets/images/app_logo_dark.png', 'wb') as f:
    f.write(base64.b64decode(img_data))

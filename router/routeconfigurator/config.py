import os

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'defaultsecret'
    env_content = os.environ.get("TEST_ENVIRONMENT", default='False')
    if env_content.lower() in ("t", "true"):
        TEST_ENVIRONMENT = True
    else:
        TEST_ENVIRONMENT = False

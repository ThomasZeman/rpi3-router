import os
import sys, traceback

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'defaultsecret'
    env_content = os.environ.get("TEST_ENVIRONMENT", default='False')
    if env_content.lower() in ("t", "true"):
        TEST_ENVIRONMENT = True
        DHCP_LEASES_FILE = './app_test/sampledhcpd.leases'
    else:
        TEST_ENVIRONMENT = False
        DHCP_LEASES_FILE = '/dhcp-data/dhcpd.leases'

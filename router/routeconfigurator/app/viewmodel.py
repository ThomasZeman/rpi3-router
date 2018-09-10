from isc_dhcp_leases import Lease, IscDhcpLeases
#from . import TEST_ENVIRONMENT
from config import Config

class ViewModel:

    def __init__(self):
        if Config.TEST_ENVIRONMENT:       
            leases = IscDhcpLeases('./app_test/sampledhcpd.leases') 
        else:
            leases = IscDhcpLeases('/dhcp-data/dhcpd.leases')
        self.devices = []
        ipsAdded = set()
        for lease in leases.get():
            if lease.active:
                # We show an IP only once
                if not lease.ip in ipsAdded:
                    ipsAdded.add(lease.ip)
                    self.devices.append(
                        {
                            'mac' : lease.ethernet,
                            'ipv4' : lease.ip, 
                            'description':lease.hostname
                        })

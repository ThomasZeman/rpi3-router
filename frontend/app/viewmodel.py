from isc_dhcp_leases import Lease, IscDhcpLeases

class ViewModel:

    def __init__(self):
        leases = IscDhcpLeases('c:\\temp\\dhcpd.leases')
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
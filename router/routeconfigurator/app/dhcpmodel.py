import os
from config import Config
from isc_dhcp_leases import Lease, IscDhcpLeases

class DhcpModel:

    def __init__(self):
        self.leases_file = os.path.join(os.getcwd(), Config.DHCP_LEASES_FILE)
        self.last_modification_time = 0        
        self.leases = dict()

    def update(self):
        modification_time = os.path.getmtime(self.leases_file)
        if modification_time != self.last_modification_time:
            self.last_modification_time = modification_time
            leases_list = IscDhcpLeases(self.leases_file).get()
            leases_dict = dict()
            for lease in leases_list:
                if lease.active:
                    leases_dict[lease.ethernet] = lease
            self.leases = leases_dict
            return True
        return False

            


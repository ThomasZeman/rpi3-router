from isc_dhcp_leases import Lease, IscDhcpLeases
from config import Config
from app.routingmodel import RoutingModel
from app.command_executor import OsCommandExecutor
from app.command_executor import PrintCommandExecutor
import os

class ViewModel:

    def __init__(self):
        leases = IscDhcpLeases(os.path.join(os.getcwd(), Config.DHCP_LEASES_FILE))
        if Config.TEST_ENVIRONMENT:       
            command_executor = PrintCommandExecutor()
        else:
            command_executor = OsCommandExecutor()
        self.routing_model = RoutingModel(command_executor)
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

    def set_route(self, ip, route):
        self.routing_model.set_route(ip, route)

    def get_route(self, ip):
        return self.routing_model.get_route(ip)

from app import dhcpmodel
from app import routingmodel
import sched, time, threading

class RoutableModel:

    def __init__(self,command_executor):
        self.routing_model = routingmodel.RoutingModel(command_executor)
        self.dhcp_model = dhcpmodel.DhcpModel()
        self.leases = dict()
        self.regular()
        print ("returned")

    def regular(self):
        if self.dhcp_model.update():
            added = self.dhcp_model.leases.keys() - self.leases.keys()
            removed = self.leases.keys() - self.dhcp_model.leases.keys()
            print ('Added devices:' + ', '.join(str(s) for s in added))
            print ('Removed devices:' + ', '.join(str(s) for s in removed))
            self.__setup_default_route(added, self.dhcp_model.leases)
            self.__remove_route(removed, self.leases)
            self.leases = self.dhcp_model.leases.copy()
        timer = threading.Timer(1, self.regular)
        timer.daemon = True
        timer.start()

    def __setup_default_route(self, added, leases):
        for key in added:
            self.routing_model.set_route(leases[key].ip, 2)

    def __remove_route(self, removed, leases):
        for key in removed:
            self.routing_model.remove_route(leases[key].ip)

    def set_route(self, ip, route:int):
        self.routing_model.set_route(ip, route)

    def get_route(self, ip):
        return self.routing_model.get_route(ip)


    

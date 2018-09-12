from config import Config
from app.routingmodel import RoutingModel
from app.command_executor import OsCommandExecutor
from app.command_executor import PrintCommandExecutor
from app import routablemodel
import os

class ViewModel:

    def __init__(self):
        if Config.TEST_ENVIRONMENT:       
            command_executor = PrintCommandExecutor()
        else:
            command_executor = OsCommandExecutor()
        self.routable_model = routablemodel.RoutableModel(command_executor)

    def get_devices(self):
        devices = []
        for k,v in self.routable_model.leases.items():
            print (v)
            devices.append(
            {
                'mac' : v.ethernet,
                'ipv4' : v.ip, 
                'description':v.hostname,
                'route_to': self.get_route(v.ip)
            })
        return devices

    def set_route(self, ip, route:int):
        self.routable_model.set_route(ip, route)

    def get_route(self, ip):
        return self.routable_model.get_route(ip)

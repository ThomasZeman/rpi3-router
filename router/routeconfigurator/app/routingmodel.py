from enum import Enum

class Operation(Enum):
    Add = 0,
    Delete = 1

class RoutingModel:

    def __init__(self, command_executor):
        self.devices = {}     
        self.command_executor = command_executor

    def get_route(self, ip):
        if ip not in self.devices:
            return 0
        return self.devices[ip]

    def set_route(self, ip, route):
        if ip in self.devices:
            current_route = self.devices[ip]
            if route == current_route:
                return
            RoutingModel.execute_routing_modifications(self.command_executor, Operation.Delete, ip, current_route)
            self.devices.pop(ip)
        self.devices.update({ip: route})
        RoutingModel.execute_routing_modifications(self.command_executor, Operation.Add, ip, route)    

    @staticmethod
    def execute_routing_modifications(command_executor, operation, ip, route):
        command_executor.execute(RoutingModel.create_iptables_command(operation, ip, route))
        command_executor.execute(RoutingModel.create_iprules_command(operation, ip, route))  

    @staticmethod 
    def create_iptables_command(operation, ip, route):
        mapping = {Operation.Add : 'A', Operation.Delete : 'D'}
        return ('iptables','-t mangle -{} PREROUTING -s {}/32 -j MARK --set-xmark {}'.format(mapping[operation], ip, route))
    
    @staticmethod
    def create_iprules_command(operation, ip, route):
        mapping = {Operation.Add : 'add', Operation.Delete : 'del'}
        return ('ip','rule {} from {} table {}'.format(mapping[operation], ip, route))


class RoutingTable:

    routes = [{'Sydney', 2},{'Munich',3}]     
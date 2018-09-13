from enum import Enum

class Operation(Enum):
    Add = 0,
    Delete = 1

class RoutingModel:

    def __init__(self, command_executor):
        self.devices = {}     
        self.command_executor = command_executor
        print ('Creating RoutingModel instance. Flushing table and rules')
        command_executor.execute(RoutingModel.create_flush_mark_table_command())
        command_executor.execute(('/bin/sh', '-c "while ip rule delete from 0/0 to 0/0 table 2; do true; done"'))
        command_executor.execute(('/bin/sh', '-c "while ip rule delete from 0/0 to 0/0 table 3; do true; done"'))

    def get_route(self, ip):
        if ip not in self.devices:
            return 0
        return self.devices[ip]

    def set_route(self, ip, route:int):
        self.remove_route(ip)
        print ('set_route ip: ' + ip + ' route: ' + str(route)) 
        self.devices.update({ip: route})
        RoutingModel.execute_routing_modifications(self.command_executor, Operation.Add, ip, route)    

    def remove_route(self, ip):
        if ip in self.devices:
            current_route = self.devices[ip]
            print ('remove_route ip: ' + ip + ' with existing route ' + str(current_route))
            RoutingModel.execute_routing_modifications(self.command_executor, Operation.Delete, ip, current_route)
            self.devices.pop(ip)
        else:
            print ('remove_route ip: ' + ip + ' nothing to remove')

    @staticmethod
    def execute_routing_modifications(command_executor, operation, ip, route):        
        command_executor.execute(RoutingModel.create_iptables_command(operation, ip, route))
        command_executor.execute(RoutingModel.create_iprules_command(operation, ip, route))  
        command_executor.execute(RoutingModel.create_conntrack_delete_command(ip))
 
    @staticmethod
    def create_flush_mark_table_command():
        return ('iptables','-t mangle --flush PREROUTING_MARKING')

    @staticmethod 
    def create_iptables_command(operation, ip, route:int):
        mapping = {Operation.Add : 'A', Operation.Delete : 'D'}
        return ('iptables','-t mangle -{} PREROUTING_MARKING -s {}/32 -j MARK --set-xmark {}'.format(mapping[operation], ip, route))
    
    @staticmethod
    def create_iprules_command(operation, ip, route:int):
        mapping = {Operation.Add : 'add', Operation.Delete : 'del'}
        return ('ip','rule {} from {} table {}'.format(mapping[operation], ip, route))

    @staticmethod
    def create_conntrack_delete_command(ip):
        return ('conntrack','-D -s {}'.format(ip))


class RoutingTable:

    routes = [{'Sydney', 2},{'Munich',3}]     

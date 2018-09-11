import unittest

from config import Config
Config.TEST_ENVIRONMENT = True
Config.DHCP_LEASES_FILE = 'app_test/sampledhcpd.leases'
from app.routingmodel import RoutingModel
from app.routingmodel import Operation

class CommandExecutor:

    def __init__(self):
        self.commands = []

    def execute(self, command_and_arguments):
        self.commands.append(command_and_arguments[0] + ' ' + command_and_arguments[1])

    def get_all_commands(self):
        return self.commands

class TestStringMethods(unittest.TestCase):

    def test_set_route_not_set_before(self):        
        command_executor = CommandExecutor()
        routing_model = RoutingModel(command_executor)
        routing_model.set_route("10.1.1.111", 3)
        self.assertEqual(2, len(command_executor.commands))
        self.assertEqual('ip rule add from 10.1.1.111 table 3', command_executor.commands[1])
        self.assertEqual('iptables -t mangle -A PREROUTING -s 10.1.1.111/32 -j MARK --set-xmark 3', command_executor.commands[0])

    def test_set_route_was_set_before(self):
        command_executor = CommandExecutor()
        routing_model = RoutingModel(command_executor)
        routing_model.set_route("10.1.1.111", 3)
        routing_model.set_route("10.1.1.111", 2)
        self.assertEqual(6, len(command_executor.commands))
        self.assertEqual('iptables -t mangle -A PREROUTING -s 10.1.1.111/32 -j MARK --set-xmark 3', command_executor.commands[0])
        self.assertEqual('ip rule add from 10.1.1.111 table 3', command_executor.commands[1])
        self.assertEqual('iptables -t mangle -D PREROUTING -s 10.1.1.111/32 -j MARK --set-xmark 3', command_executor.commands[2])
        self.assertEqual('ip rule del from 10.1.1.111 table 3', command_executor.commands[3])
        self.assertEqual('iptables -t mangle -A PREROUTING -s 10.1.1.111/32 -j MARK --set-xmark 2', command_executor.commands[4])
        self.assertEqual('ip rule add from 10.1.1.111 table 2', command_executor.commands[5])                


    def test_get_route_not_set_before(self):
        command_executor = CommandExecutor()
        routing_model = RoutingModel(command_executor)
        self.assertEqual(0, routing_model.get_route("10.1.1.111"))


    def test_get_route_was_set_before(self):
        command_executor = CommandExecutor()
        routing_model = RoutingModel(command_executor)
        routing_model.set_route("10.1.1.111", 2)
        self.assertEqual(2, routing_model.get_route("10.1.1.111"))        

    def test_iprule_add(self):
        self.assertEqual(
            ('ip','rule add from 10.1.1.100 table 2'),
            RoutingModel.create_iprules_command(Operation.Add, "10.1.1.100", 2))

    def test_iprule_delete(self):
        self.assertEqual(
            ('ip','rule del from 10.1.1.110 table 2'),
            RoutingModel.create_iprules_command(Operation.Delete, "10.1.1.110", 2))

    def test_iptables_add(self):
        self.assertEqual(
            ('iptables','-t mangle -A PREROUTING -s 10.1.1.190/32 -j MARK --set-xmark 2'),
            RoutingModel.create_iptables_command(Operation.Add, "10.1.1.190", 2))

    def test_iptables_delete(self):
        self.assertEqual(
            ('iptables','-t mangle -D PREROUTING -s 10.1.1.180/32 -j MARK --set-xmark 2'),
            RoutingModel.create_iptables_command(Operation.Delete, "10.1.1.180", 2))

if __name__ == '__main__':
    unittest.main()
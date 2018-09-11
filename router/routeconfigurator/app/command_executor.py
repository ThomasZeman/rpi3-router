from subprocess import call

class OsCommandExecutor:

    def execute(self, command_and_arguments):
        print('Executing : ' + command_and_arguments[0] + ' ' + command_and_arguments[1])
        call(command_and_arguments[0] + ' ' + command_and_arguments[1], shell=True)

class PrintCommandExecutor:
    def execute(self, command_and_arguments):
        print(command_and_arguments[0], command_and_arguments[1])
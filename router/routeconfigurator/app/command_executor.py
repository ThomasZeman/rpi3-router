from subprocess import call

class OsCommandExecutor:

    def execute(self, command_and_arguments):
        call([command_and_arguments[0], command_and_arguments[1]])

class PrintCommandExecutor:
    def execute(self, command_and_arguments):
        print(command_and_arguments[0], command_and_arguments[1])
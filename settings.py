#Set to False if you don't want debug mode to be on
debug = True 
#Set testing mode here
test = True
#Your credentials
username = 'postgres'
password = 'password'
host_name = 'localhost'
port_number = 5432 #default
database_name = 'foodsanta'

URI = f'postgresql://{username}:{password}@{host_name}:{port_number}/{database_name}'
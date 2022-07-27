from os import environ as env
import configparser

# Open the Airflow config file
config = configparser.ConfigParser()
config.read('/root/airflow/airflow.cfg')

# Store the URL of the MySQL database
config['database']['sql_alchemy_conn'] = 'mysql+mysqlconnector://{user}:{password}@db/{db}'.format(user=env.get('MYSQL_USER'), password=env.get('MYSQL_PASSWORD'), db=env.get('MYSQL_DATABASE'))
config['core']['executor'] = 'LocalExecutor'
config['core']['load_examples'] = 'false'
with open('/root/airflow/airflow.cfg', 'w') as f:
    config.write(f)

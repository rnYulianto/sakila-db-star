from email.policy import default
from datetime import timedelta
from airflow import DAG
from airflow.operators.mysql_operator import MySqlOperator
from airflow.utils.dates import days_ago

# DAG to create star schema and migrate the initial database, assuming that new data will be inserted in origin database on daily basis.

# Default arguments for DAG, here the retries initiated, this dag will only retried once on error
def_args = {
    'owner': 'rnyulianto',    
    'email': ['rn.yulianto@gmail.com'],
    'description': 'Create inital database and migrate existing data from sakila database into star schema',
    # If a task fails, retry it once after waiting
    # at least 5 minutes
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id = 'init_dag',
    default_args = def_args,
    # Because this DAG supposed only run once the system is ready, so I initiate this DAG to run on trigger
    schedule_interval = None,
    start_date = days_ago(1)
) as dag:
    # Create the star schema, I use MySQLOperator and define mysql_conn_id that need to be set on Connections setting once airflow is ready.
    create_star_schema  = MySqlOperator(
        task_id = 'create_star_schema',
        mysql_conn_id = 'local_mysql',
        sql = './sql/star-schema.sql'
    )

    # Migrate the initial data that already exist on the origin database.
    # I use MySQLOperator for this task
    migrate_to_star_schema = MySqlOperator(
        task_id = 'migrate_to_star_schema',
        mysql_conn_id = 'local_mysql',
        sql = './sql/init-migrate.sql'
    )

    # Making sure that migration happen after the star schema created
    create_star_schema >> migrate_to_star_schema
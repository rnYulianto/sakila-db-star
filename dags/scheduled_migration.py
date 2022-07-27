from datetime import timedelta
import airflow
from airflow import DAG
from airflow.operators.mysql_operator import MySqlOperator
from airflow.utils.dates import days_ago

def_args = {
    'owner': 'rnyulianto',    
    'email': ['rn.yulianto@gmail.com'],
    'description': 'Scheduling migration into star schema every day',
    # If a task fails, retry it once after waiting
    # at least 5 minutes
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# This DAG almost same with the initial_migration, the difference are that this DAG is sopposed to run daily to migrate 
with DAG(
    dag_id = 'daily_migration',
    default_args = def_args,
    schedule_interval = '@daily',
    start_date = days_ago(1)
) as dag:
    migrate_today_data  = MySqlOperator(
        task_id = 'create_star_schema',
        mysql_conn_id = 'local_mysql',
        sql = './sql/scheduled-migration.sql'
    )

    migrate_today_data
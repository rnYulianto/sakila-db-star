INIT_FILE=.airflowinitialized
if [ ! -f "$INIT_FILE" ]; then
    airflow db init

    # Wait until the DB is ready
    apt update && apt install -y netcat
    while ! nc -z db 3306; do   
        sleep 1
    done
    apt remove -y netcat

    # Setup the DB
    python mysqlconnect.py
    airflow db init

    # Allow XComs to store objects bigger than 65KB
    apt update && apt install -y default-mysql-client
    mysql --host db --user=root --password=$MYSQL_ROOT_PASSWORD --database=$MYSQL_DATABASE --execute="ALTER TABLE xcom MODIFY value LONGBLOB;"

    # This configuration is done only the first time
    touch "$INIT_FILE"
fi

# Create Admin
airflow users  create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin
# Create mysql Connection
airflow connections --add --conn-id local_mysql --conn_uri mysql+mysqlconnector://root:$MYSQL_ROOT_PASSWORD@db
# Run the Airflow webserver and scheduler
airflow scheduler &
airflow webserver &
wait

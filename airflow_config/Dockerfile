# Airflow seems to crash with Python 3.8, it's important to use version 3.7 instead
FROM python:3.7

# Install and setup Airflow
RUN pip3 install 'apache-airflow[mysql,crypto]' mysql-connector-python pandas jupyterlab

# Configure Airflow: connect to backend
WORKDIR /root/airflow/
COPY airflow.sh airflow.sh
RUN chmod +x airflow.sh
COPY mysqlconnect.py mysqlconnect.py
CMD ./airflow.sh
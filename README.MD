# Data Engineer Assignment
For this assignment in general I use docker-compose to build my containers, I use MySQL for Database, PHPMyAdmin to chek and query the data, and Airflow for scheduling.
1. Create Star Schema of Origin Sakila Database
   
   Using docker compose I initiate the original sakila database and INSERT the Data. For the next step I made an Airflow DAG that create star schema and migrate the initial data unsing MySQLExecutor. This DAG run on trigger and only supposed to run once. Before trigger the init_dag you need to set up connection to the database in `Admin > Connections`, the name of the connection are `local_mysql`, and the settings are:
   ```
   Host: db
   Schema: sakila
   Login: root
   password: root_pass
   ```
   I dont attach volume into this mysql container, bacause I need to init the Database everytime.
   For the star schema, because there are no matrix that explicitly mentioned, so I just assume that only standard dimension that needed.
   - Customer Dimension to capture information about Who rent the movie, about demography of our customer about where is the address and what movie for certain gender.
   - Date Dimension to capture When the actual transaction happend, so we know at what time high season or low season.
   - Store Dimension to capture Where, if we join store with customer dimension we can find where the customer live that rent from certain store. We can also plan for expanding the store if there are a lot of customer from certain area that far from our current store location.
   - Movie Dimension to capture What, we can understand what kind of movie that are high demand in certain period.
2. Create an airflow DAG that transform data from Origin Sakila Schema to your new Star Schema that run daily.

    Apart from DAG that create and migrate the initial star database, I also create DAG that run daily to migrate data from previous date, I assume that the original database will be updated with new data.
3. Comment Available in my code.
4. I create simple query to demonstrate the defference between Origin Database and Star Schema, I put the code on Jupyter Notebook file in eda folder.

jupyter lab --no-browser --ip="0.0.0.0" --allow-root --ServerApp.root_dir /opt/code
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eu

# List of databases to create
DATABASES=("cexplorer" "rosetta")

# PostgreSQL credentials
POSTGRES_USER="postgres"

# Function to create a database
create_database() {
    local db_name=$1
    echo "Creating database: $db_name"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $db_name;
	    GRANT ALL PRIVILEGES ON DATABASE $db_name TO $POSTGRES_USER;
EOSQL
}

# Loop through the list of databases and create each one
for db in "${DATABASES[@]}"; do
    create_database $db
done

echo "Database initialization complete."

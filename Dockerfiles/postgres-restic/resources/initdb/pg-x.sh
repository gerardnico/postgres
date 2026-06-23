echo "Creating the dbctl procedure"
psql -v ON_ERROR_STOP=1 -f /script/pgx.sql

-- Ensure we are running as the superuser
DO
$$
BEGIN
   IF session_user != 'postgres' THEN
      RAISE EXCEPTION 'This script must be run as the postgres superuser. Current user: %', session_user;
   END IF;
END
$$;


CREATE ROLE killer WITH LOGIN PASSWORD 'killerp';
CREATE DATABASE killer OWNER killer;
GRANT ALL PRIVILEGES ON DATABASE killer TO killer;

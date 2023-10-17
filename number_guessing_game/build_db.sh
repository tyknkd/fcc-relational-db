#! /bin/bash
PSQL_INIT="psql -X --username=freecodecamp --dbname=postgres --tuples-only -c"
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

# Remove previous database
RESULT=$($PSQL_INIT "DROP DATABASE number_guess")

RESULT=$($PSQL_INIT "CREATE DATABASE number_guess")

RESULT=$($PSQL "CREATE TABLE users(user_id SERIAL PRIMARY KEY NOT NULL, username VARCHAR(22) UNIQUE NOT NULL, games_played INT, best_game INT)")


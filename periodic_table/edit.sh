#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

# Reset database
RESULT=$(psql -U postgres < periodic_table.sql)

# Alter database
RESULT=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
RESULT=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
RESULT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")
RESULT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")
RESULT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")
RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
RESULT=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")
RESULT=$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")
RESULT=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
RESULT=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
RESULT=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")
RESULT=$($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY NOT NULL, type VARCHAR(30) NOT NULL)")
RESULT=$($PSQL "INSERT INTO types(type) VALUES('nonmetal'), ('metal'), ('metalloid')")
RESULT=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id)")
RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE REAL")
RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass SET NOT NULL")
RESULT=$($PSQL "UPDATE properties SET type_id=1 WHERE type='nonmetal'")
RESULT=$($PSQL "UPDATE properties SET type_id=2 WHERE type='metal'")
RESULT=$($PSQL "UPDATE properties SET type_id=3 WHERE type='metalloid'")
RESULT=$($PSQL "ALTER TABLE properties DROP COLUMN type")
RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
RESULT=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9,'F','Fluorine'), (10,'Ne','Neon')")
RESULT=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 18.998, -220, -188.1, 1), (10, 20.18, -248.6, -246.1, 1)")
RESULT=$($PSQL "UPDATE elements SET symbol='He' WHERE name='Helium'")
RESULT=$($PSQL "UPDATE elements SET symbol='Li' WHERE name='Lithium'")

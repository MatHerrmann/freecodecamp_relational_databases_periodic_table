#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table  --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  COLUMNS="atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
  if [[ $1 =~ ^[0-9]+ ]]
  then
    SELECT_ELEMENT_RESULT="$($PSQL "SELECT $COLUMNS FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = $1")"
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    SELECT_ELEMENT_RESULT="$($PSQL "SELECT $COLUMNS FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING (type_id) WHERE symbol = '$1'")"
  else
    SELECT_ELEMENT_RESULT="$($PSQL "SELECT $COLUMNS FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING (type_id) WHERE name = '$1'")"
  fi

  if [[ -z $SELECT_ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|"
    echo "$SELECT_ELEMENT_RESULT" | while read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed -E 's/^ *| *$//g')
      SYMBOL=$(echo $SYMBOL | sed -E 's/^ *| *$//g')
      NAME=$(echo $NAME | sed -E 's/^ *| *$//g')
      TYPE=$(echo $TYPE | sed -E 's/^ *| *$//g')
      ATOMIC_MASS=$(echo $ATOMIC_MASS | sed -E 's/^ *| *$//g')
      MELTING_POINT=$(echo $MELTING_POINT | sed -E 's/^ *| *$//g')
      BOILING_POINT=$(echo $BOILING_POINT | sed -E 's/^ *| *$//g')  
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi

#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

FILE="games.csv"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
    echo "$($PSQL "INSERT INTO teams(name) VALUES ('$winner')")"
    echo "$($PSQL "INSERT INTO teams(name) VALUES ('$opponent')")"
done < <(tail -n +2 "$FILE")

while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  # Obtener los IDs de los equipos (asumiendo que ya se han insertado en la tabla teams)
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")
  
  # Insertar el juego en la tabla games
  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")"
  
done < <(tail -n +2 "$FILE")
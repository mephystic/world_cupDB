#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

# Insertion data into teams table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
      # get winner_id
      TEAMW_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

      # if not found
      if [[ -z $TEAMW_ID ]]
      then
          # insert winner team
          INSERT_TEAMW_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          #if [[ $INSERT_TEAMW_RESULT == 'INSERT 0 1' ]]
          #then
          #    echo 'Inserted into teams,' $WINNER 
          #fi
      fi

      # get opponent_id
      TEAMO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      # if not found
      if [[ -z $TEAMO_ID ]]
      then
          # insert opponent team
          INSERT_TEAMO_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          #if [[ $INSERT_TEAMO_RESULT == 'INSERT 0 1' ]]
          #then
              #echo 'Inserted into teams,' $OPPONENT
          #fi
      fi
  fi
done

# Insertion data into games table

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
      # get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

      # get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      # Insert into 'games': year, round, winner_id, opponent_id, winner_goals and opponent goals
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      #echo 'Inserted into games, ' $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  fi
done

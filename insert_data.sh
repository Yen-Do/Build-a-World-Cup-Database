#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != 'year' ]]
  then
    # add teams
    # check if it already exists
    CHECK_IF_WINNER_TEAM_EXISTS=$($PSQL "SELECT count(team_id) FROM teams WHERE name = '$WINNER'")
    CHECK_IF_OPPONENT_TEAM_EXISTS=$($PSQL "SELECT count(team_id) FROM teams WHERE name = '$OPPONENT'")
    # add them if they don't exist
    if [[ $CHECK_IF_WINNER_TEAM_EXISTS == 0 ]]
    then
      echo -e "$($PSQL "INSERT INTO teams(name) values('$WINNER')")" team : $WINNER
    fi
    if [[ $CHECK_IF_OPPONENT_TEAM_EXISTS == 0 ]]
    then
      echo -e "$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")" team : $OPPONENT
    fi
    # add games
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    echo -e "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done
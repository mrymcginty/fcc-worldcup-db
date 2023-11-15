#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# empty tables
echo $($PSQL "TRUNCATE TABLE games,teams;");

# Do not change code above this line. Use the PSQL variable above to query your database.
# populate teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
    # get team ID for winner
    WINNER_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$WINNER'")
    # get team ID for the opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$OPPONENT'")
    if [[ -z $WINNER_ID ]]
      then 
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
    elif [[ -z $OPPONENT_ID ]]
      then 
        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
    fi
  fi
done

# populate games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
      then WINNER_ID=null
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
      then OPPONENT_ID=null
    fi
    # populate games table
    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)");
done

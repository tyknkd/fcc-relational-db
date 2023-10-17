#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

# clear database
# RESULT=$($PSQL "TRUNCATE users")

# randomly generate number between 1 and 1000
TARGET=$(( ( $RANDOM % 1000 ) + 1 ))

# keep count of guesses
COUNT=0

# initialize boolean flag
WRONG_GUESS=true

# prompt for 22-character username
echo -e "\nEnter your username:"
read USERNAME

# try to get user stats
USER_STATS=$($PSQL "SELECT games_played,best_game FROM users WHERE username='$USERNAME'")

# if new user
if [[ -z $USER_STATS ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  read GAMES_PLAYED BAR BEST_GAME <<< $USER_STATS
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# get user's first guess
echo -e "Guess the secret number between 1 and 1000:"
read GUESS

while $WRONG_GUESS
do
  # increment count
  (( COUNT++ ))
  
  # if not number
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    read GUESS
  
  # if guess is higher than target
  elif [[ $GUESS > $TARGET ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    read GUESS

  # if guess is lower than target
  elif [[ $GUESS < $TARGET ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    read GUESS

  # if success
  elif [[ $GUESS = $TARGET ]]
  then
    echo -e "\nYou guessed it in $COUNT tries. The secret number was $TARGET. Nice job!"

    # if first win
    if [[ -z $USER_STATS ]]
    then
      # Set as best game and 1 game played
      RESULT=$($PSQL "INSERT INTO users(username,games_played,best_game) VALUES ('$USERNAME',1,$COUNT)")

    # if best game yet
    elif [[ $COUNT < $BEST_GAME ]]
    then
      # Replace best game score and update number of games played
      RESULT=$($PSQL "UPDATE users SET best_game = $COUNT, games_played = ($GAMES_PLAYED + 1) WHERE username='$USERNAME'")
    else
      # Only increment number of games played
      RESULT=$($PSQL "UPDATE users SET games_played = ($GAMES_PLAYED + 1) WHERE username='$USERNAME'")
    fi
    # update boolean flag
    WRONG_GUESS=false
  fi
done

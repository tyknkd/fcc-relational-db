#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Clear appointments and customers tables
# echo $($PSQL "TRUNCATE customers, appointments")

# Header
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  # Print argument if exists
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  # echo -e "\n0) exit"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  # if exit selected
  # if [[ $SERVICE_ID_SELECTED = 0 ]]
  # then
  #   echo -e "\nThank you for stopping in.\n"
  
  # if not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # send to main menu
    MAIN_MENU "Please enter a number."
  else
    # get service name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    # if not a valid service
    if [[ -z $SERVICE_NAME ]]
    then
      # send to main menu
      MAIN_MENU "Please select an option from the list."
    else
      MAKE_APPOINTMENT $SERVICE_ID_SELECTED $SERVICE_NAME
    fi
  fi
}
MAKE_APPOINTMENT() {
  # get phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # get customer_id
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if no such customer
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # add to customers table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # get time
  echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
  read SERVICE_TIME
  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # add appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  # print confirmation
  echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
  # send to main menu
  # MAIN_MENU "Would you like to schedule another appointment?"
}

MAIN_MENU "Welcome to My Salon, how may I help you?"

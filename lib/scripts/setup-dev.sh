#!/bin/bash
# A little script to get a dev environment up and running

# Ask the user if they are sure that they would like to set-up their dev environtment
echo -e "Are you sure that you would like to set-up your dev environment? (yYnNqQ)"
read ANS

if [[ ! ($ANS = 'y') || ($ANS = 'Y') ]]; then
  exit 0
fi

# Get the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MIX_DIR="$(dirname "$SCRIPT_DIR")"

# The files to update
config_files=(ldap mailer print_service secrets)

# Remove the .sample from the config files
echo "Removing .sample from the config files..."
ls $SCRIPT_DIR/*.sample
SUCCESS=false
for i in ${config_files[@]}; do
  if [ -f $SCRIPT_DIR/${i}.yml.sample ]; then
    echo "Renaming ${i}"
    mv $SCRIPT_DIR/${i}.yml.sample $SCRIPT_DIR/${i}.yml
    SUCCESS=true
  else
    echo "${i} not found"
  fi
done

# If files were renamed, show listing of config dir
if [ "$SUCCESS" = true ]; then
  ls $SCRIPT_DIR/*.yml
fi

# Change the LDAP stub
echo "Changing the LDAP stub in config file..."
sed -i '' 's/config.stub_ldap = false/config.stub_ldap = true/' $SCRIPT_DIR/application.rb
echo "Done"

# Create the database if it does not yet exist
echo "Cheking for the developent database..."
if [ -f $MIX_DIR/db/development.sqlite3 ]; then
  echo "Development db already exists."
else
  echo "Creating development db..."
  `rake db:setup` > /dev/null 2>&1

  # Initialising some data
  echo "Initialising some data..."
  `rake consumables:load` > /dev/null 2>&1

  echo "Done"
fi

#!/bin/bash

#COMMAND=@Commands
#TITLE=Displays and manages all active commands

#@HELP -> Displays this help menu for this command
help() {
	#Pulls the help files from this command
	CMD=$(grep -e '^#COMMAND' $BASH_SOURCE | sed 's/#COMMAND=//g')
	echo ""
	echo "~~ $CMD Help Menu ~~"
	echo "----------------------------------"
	grep -e '^#@' $BASH_SOURCE | sed 's/#@//g'
	echo ""
	echo "Example: @commands add dock"
	echo ""
}

#@BLANK -> Displays the list of commands
list() {
	echo "---------------"
	echo "  COMMANDS  "
	echo "---------------"
	ls -1 ~/scripts/commands| sed -e 's/\..*$//'

	#TODO
		# Add function to grab title field from the script file for more information
		# Create a quiet flag
}

#@ADD -> Adds a new command
add() {
	#check for new name
	if [ -z "$1" ]
	then
		#if none, ask for it
		echo "Command Name: "
		read -r CMDNAME
	else
		CMDNAME=$1
	fi

	#create template for command
	cp ~/scripts/commands/.template.sh ~/scripts/commands/"$CMDNAME".sh
	sudo chmod +x ~/scripts/commands/"$CMDNAME".sh

	#adds alias for command
	echo "alias '@$CMDNAME'='source ~/scripts/commands/$CMDNAME.sh'" >> ~/scripts/command_aliases

	#refresh alias file
	source ~/.bashrc
}

#@EDIT -> Edits a command supplied
edit() {
	#check for new name
	if [ -z "$1" ]
	then
		#if none, ask for it
		echo "Command Name: "
		read -r CMDNAME
	else
		CMDNAME=$1
	fi

	vim ~/scripts/commands/"$CMDNAME".sh

}

#@DELETE -> Deletes a command supplied
delete() {
	#check for new name
	if [ -z "$1" ]
	then
		#if none, ask for it
		echo "Command Name: "
		read -r CMDNAME
	else
		CMDNAME=$1
	fi

	rm ~/scripts/commands/"$CMDNAME".sh

	#remove line from command_aliases
	sed -i /"$CMDNAME"/d ~/scripts/command_aliases
	#debugging - echo /"$CMDNAME"/d

	#refresh alias file
	. ~/.bashrc
}


case $1 in 
	add) add "$2" ;;
	delete) delete "$2" ;;
	edit) edit "$2" ;;
	help) help ;;
	*) list ;;
esac



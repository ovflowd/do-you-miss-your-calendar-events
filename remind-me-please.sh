#!/usr/bin/env bash

DEFAULT_REMAINING_TIME="1"
DEFAULT_VOICE_SPEED="150"
DEFAULT_VOICE="Samantha"
DEBUG_MODE=false
EXCLUDED_CALENDARS=""

while getopts ":t:s:v:e:d" arg; do
	case $arg in
		t)
      		DEFAULT_REMAINING_TIME="${OPTARG}"

      		if ! [[ $DEFAULT_REMAINING_TIME =~  ^[0-9]+$ ]]; then
   				echo "The given -t argument needs to be a number" >&2
   				exit 1
			fi
      		;;
		s)
      		DEFAULT_VOICE_SPEED="${OPTARG}"

      		if ! [[ $DEFAULT_VOICE_SPEED =~  ^[0-9]+$ ]]; then
   				echo "The given -s argument needs to be a number" >&2
   				exit 1
			fi
      		;;
      	v)
      		DEFAULT_VOICE="${OPTARG}"
      		;;
      	e)
			EXCLUDED_CALENDARS="${OPTARG}"
			;;
      	d)
			DEBUG_MODE=true
			;;
	esac
done

while :
do
	if [[ $DEBUG_MODE = true ]]; then
		echo "• Starting the Calendar Script"
	fi

	NEXT_ENTRY=$(/usr/local/bin/icalBuddy -n -ea -npn -nc -eed -iep "title,datetime" -ps "| : |" -po "datetime,title" -ec "$EXCLUDED_CALENDARS" -li 1 eventsToday)
	NEXT_ENTRY=${NEXT_ENTRY#"• "}

	if [[ $DEBUG_MODE = true ]]; then
		echo "• Got the following result from iCalBuddy: \"$NEXT_ENTRY\""
	fi

	if [[ $NEXT_ENTRY = *[!\ ]* ]]; then
		NEXT_ENTRY_ONLY_TIME="${NEXT_ENTRY% :*}"
		NEXT_ENTRY_ONLY_TEXT="${NEXT_ENTRY##*: }"

		CURRENT_TIME_PLUS_ONE=$(date -v "+${DEFAULT_REMAINING_TIME}M" +%H:%M)

		if [[ $DEBUG_MODE = true ]]; then
			echo "• Announce events that start at: $CURRENT_TIME_PLUS_ONE, Selected Event Time: $NEXT_ENTRY_ONLY_TIME"
		fi

		if [[ "$CURRENT_TIME_PLUS_ONE" == "$NEXT_ENTRY_ONLY_TIME" ]]
		then
			ANNOUNCE_MESSAGE="You have an upcoming event at $NEXT_ENTRY_ONLY_TIME, $NEXT_ENTRY_ONLY_TEXT"

			if [[ $DEBUG_MODE = true ]]; then
				echo "• Match found. Announcing: \"$ANNOUNCE_MESSAGE\""
			fi

			say -v "$DEFAULT_VOICE" -r "$DEFAULT_VOICE_SPEED" "$ANNOUNCE_MESSAGE"

			if [[ $DEBUG_MODE = true ]]; then
				echo "• Announcement Ended."
			fi
		else
			if [[ $DEBUG_MODE = true ]]; then
				echo "• Match not found for given time."
			fi
	    fi
	fi

	if [[ $DEBUG_MODE = true ]]; then
		echo "• Waiting for next iteration."
	fi

    sleep 60
done

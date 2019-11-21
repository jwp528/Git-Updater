# Josh Parsons
# Nov 20th 2019
# Updates all git repositories in the parent directory this script sits in
# and run npm i to install potentially new packages

#global vars
UPDATE_COUNT=0
START=$SECONDS

#param flags - all defaulted
quiet=0
silent=0

#loop through all params and configure
while test $# -gt 0
do
  case "$1" in
    -q) quiet=1
      ;;
    --quiet) quiet=1
      ;;
    -s) silent=1
      ;;
    --silent) silent=1
      ;;
    *) echo "Skipping $1. unsupported arg"
      ;;
  esac
  shift
done

#calculates time to minutes and seconds
function secondsToMinutes {
  TOTAL_TIME=$(bc<<<"scale=2; $1/$2");
}

# capture the time
function gettime {
  eval $1=$(date +%s.%N);
}

# calculates the difference between 2 provided times taken from gettime
# assigns this value to the first variable in the arg list
function diff {
  eval $1=$(bc<<<"scale=2; $3 - $2");

}

# start the timer
gettime S

for d in */; do
  ((UPDATE_COUNT++))
  SKIP=0
  (
    cd "$d"
    if [ ! -d ".git" ] && [ ! -f "package.json" ]
    then
      SKIP=1

      if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
      then
        echo "SKIPPING. No repo or node app found"
      fi
    fi

    if [ $SKIP = 0 ]
    then
      if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
      then
        echo ===============================
        echo "$UPDATE_COUNT: $d"
        echo ===============================
      fi

      if [ -d ".git" ]
      then
        cmdtime="$(\time -f %E git pull --quiet 2>&1 1>/dev/null)"
        if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
        then
          echo "Git Repo pulled in $cmdtime seconds"
        fi
      fi

      if [ -f "package.json" ]
      then
        nodetime="$(\time -f %E npm --silent i 2>&1 1>/dev/null)"
        if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
        then
	        echo "Node Modules updated in $nodetime seconds"
        fi
      fi
      
      if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
      then
        echo ""
      fi
    else
      ((UPDATE_COUNT--))
    fi
  )
done
# stop the total timer
gettime E

# calculate the total time
diff DIFF $S $E

TOTAL_TIME=$((SECONDS-START))

if [ "$quiet" -ne 1 ] && [ "$silent" -ne 1 ]
then
  echo ""
  echo ""
  echo "UPDATE COMPLETE!"
  echo "====================="
fi

if [ "$silent" -ne 1 ]
then
  echo "Repos Updated: $UPDATE_COUNT"
  printf "Time to update: %0.2f \n" $DIFF
fi


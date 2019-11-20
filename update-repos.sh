# Josh Parsons
# Nov 20th 2019
# Updates all git repositories in the parent directory this script sits in
# and run npm i to install potentially new packages
UPDATE_COUNT=0
for d in */; do
  ((UPDATE_COUNT++))
  SKIP=0
  (
    cd "$d"
    if [ ! -d ".git" ] && [ ! -d "node_modules" ]
    then
      echo SKIPPING. No repo or node app found && SKIP=1
    fi

    if [ $SKIP = 0 ]
    then
      echo ===============================
      echo "$UPDATE_COUNT: $d"
      echo ===============================

      if [ -d ".git" ]
      then
        git pull --quiet && echo Repo pulled
      fi

      if [ -d "node_modules" ]
      then
        npm --silent i
      fi

      echo ""
    else
      ((UPDATE_COUNT--))
    fi
  )
done

echo ""
echo ""
echo "UPDATE COMPLETE!"
echo "================"
echo "Repos Updated: $UPDATE_COUNT"

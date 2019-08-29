#!/bin/bash
# VARS
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PARENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
RUNTIME_NAME=${1:-nodejs10}
n=0

# FUNCS
read_trigger_name () {
  local triggerType=$(node -pe "require('$PARENT_DIR/package.json').functionConfig['$1'].trigger.type;")
  local triggerName=$(node -pe "require('$PARENT_DIR/package.json').functionConfig['$1'].trigger.name || '';")
  [ -z $triggerName ] && TRIGGER_NAME="$triggerType" || TRIGGER_NAME="$triggerType=$triggerName"
}

# START
# Check for gcloud command
if ! hash gcloud 2>/dev/null
then
    echo "'gcloud' was not found in PATH"
fi

if ! hash node 2>/dev/null
then
    echo "'node' was not found in PATH"
fi

for dirName in $(node -pe "require('fs').readdirSync('$PARENT_DIR/src/functions').filter(f => f.split('.').length <= 1).forEach(d => console.log(d));'';"); do
  DISPLAY_NAME=$dirName

  for funcName in $(node -pe "require('fs').readdirSync('./src/functions/$DISPLAY_NAME').forEach(d => console.log(d.split('.').shift()));'';"); do
    FUNCTION_NAME=$funcName
  done

  [ -z $FUNCTION_NAME ] && continue
  [ -z $DISPLAY_NAME ] && continue

  read_trigger_name $DISPLAY_NAME

  # Check if there's an env file
  if [ -f $PARENT_DIR/envs.yaml ]; then
    ENV_VAR="--env-vars-file=$PARENT_DIR/envs.yaml"
  fi

  # clear
  echo "### Deploying function '$FUNCTION_NAME' as '$DISPLAY_NAME' using trigger '--$TRIGGER_NAME' on runtime '$RUNTIME_NAME'"
  sleep 5

  set -x
  gcloud functions deploy $DISPLAY_NAME --entry-point=$FUNCTION_NAME --$TRIGGER_NAME --runtime=$RUNTIME_NAME $ENV_VAR
  set -

  counter=$((n+1))
  clear
done

echo "Successfuly deployed $n functions"
exit 0

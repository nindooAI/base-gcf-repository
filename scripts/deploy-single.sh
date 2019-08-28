#!/bin/bash
# VARS
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PARENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
RUNTIME_NAME=${1:-nodejs10}

# FUNCS
read_fn_name () {
  echo "Specify function name (exactly as it is exported from the file):"
  read functionName

  [ -z $functionName ] && read_fn_name

  FUNCTION_NAME=$functionName
}

read_trigger_name () {
  echo "Specify a trigger (one of: trigger-http, trigger-bucket, trigger-topic, trigger-event or --trigger-resource):"
  read TRIGGER_NAME
  [ -z $TRIGGER_NAME ] && read_trigger_name

  case $TRIGGER_NAME in
    "trigger-http")
      ;;

    "trigger-bucket")
      echo "Specify bucket name:"
      read bucketName
      TRIGGER_NAME="$TRIGGER_NAME=$bucketName"
      ;;

    "trigger-topic")
      echo "Specify topic name:"
      read topicName
      TRIGGER_NAME="$TRIGGER_NAME=$topicName"
      ;;

    "trigger-event")
      echo "Specify event name:"
      read eventName
      TRIGGER_NAME="$TRIGGER_NAME=$eventName"
      ;;

    "trigger-resource")
      echo "Specify resource name:"
      read resourceName
      TRIGGER_NAME="$TRIGGER_NAME=$resourceName"
      ;;

    *)
      echo "Invalid trigger"
      exit 1
      ;;
  esac
}

# START
# Check for gcloud command
if ! hash gcloud 2>/dev/null
then
    echo "'gcloud' was not found in PATH"
fi

read_fn_name

echo "Do you want to specify a display name? (the display name defaults to the function name of '$FUNCTION_NAME')"
read displayName
[ ! -z $displayName ] && DISPLAY_NAME=$displayName || DISPLAY_NAME=$FUNCTION_NAME

read_trigger_name

# Check if there's an env file
if [ -f $PARENT_DIR/envs.yaml ]; then
  ENV_VAR="--env-vars-file=$PARENT_DIR/envs.yaml"
fi

echo
echo "### Deploying function '$FUNCTION_NAME' as '$DISPLAY_NAME' using trigger '--$TRIGGER_NAME' on runtime '$RUNTIME_NAME' are you certain?"
read -n1 -r -p "Press any key to continue..." key

echo "Deploying..."
set -x

gcloud functions deploy $DISPLAY_NAME --entry-point=$FUNCTION_NAME --$TRIGGER_NAME --runtime=$RUNTIME_NAME $ENV_VAR

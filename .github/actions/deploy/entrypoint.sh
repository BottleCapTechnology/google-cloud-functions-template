#!/bin/sh

# Pending
PENDING_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status pending`

if [ -z "${GOOGLE_APPLICATION_CREDENTIALS-}" ]; then
   echo "GOOGLE_APPLICATION_CREDENTIALS not found. Exiting...."
   FAILURE_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status failure`
   exit 1
fi

if [ -z "${PROJECT_ID-}" ]; then
   echo "PROJECT_ID not found. Exiting...."
   FAILURE_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status failure`
   exit 1
fi

PROJECT=`cat $GITHUB_EVENT_PATH | ${HOME}/bin/JSON.sh | grep '\["deployment","payload","project"]' | cut -f2 | sed -e 's/"//g'`

RESULT=$?

if [ 0 != "${RESULT}" ]; then
  echo "Failed to fetch project: '$*'! Exit code '${RESULT}' is not equal to 0"
  FAILURE_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status failure`
  echo "$output"
  exit ${RESULT}
fi

TARGET=`cat $GITHUB_EVENT_PATH | ${HOME}/bin/JSON.sh | grep '\["deployment","environment"]' | cut -f2 | sed -e 's/"//g'`
RESULT=$?

if [ 0 != "${RESULT}" ]; then
  echo "Failed to fetch environment: '$*'! Exit code '${RESULT}' is not equal to 0"
  FAILURE_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status failure`
  echo "$output"
  exit ${RESULT}
fi

echo "$GOOGLE_APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json

gcloud auth activate-service-account --key-file=/tmp/account.json
gcloud config set project "$PROJECT_ID"

# Execute
echo "Running script/deploy processDBCommand -e $TARGET"
output=$(sh -c "$GITHUB_WORKSPACE/script/deploy -e $TARGET")
RESULT=$?
if [ 0 != "${RESULT}" ]; then
  echo "Failed '$*'! Exit code '${RESULT}' is not equal to 0"
  echo "$output"
  FAILURE_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status failure`
  exit ${RESULT}
fi

# Write output to STDOUT
echo "$output"

# Success
SUCCESS_STATUS_OUTPUT=`${HOME}/bin/deployment-create-status success`

exit 0

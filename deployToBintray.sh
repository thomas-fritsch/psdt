#!/bin/bash

# Deploys the generated p2 repository to Bintray.
#
# @see https://bintray.com/docs/api/#_upload_content

if [ $# != 4 ]
then
  echo "Usage: $0 bt_owner bt_repo bt_package bt_version"
  exit 1
fi

LOCAL_PATH=*.updatesite/target/repository
BT_OWNER=$1
BT_REPO=$2
BT_PACKAGE=$3
BT_VERSION=$4

echo "creating version $BT_VERSION ..."
curl -X POST -u $BINTRAY_USER:$BINTRAY_API_KEY -H "Content-Type: application/json" -d "{\"name\":\"$BT_VERSION\",\"desc\":\"Created by Travis CI\"}" "https://api.bintray.com/packages/$BT_OWNER/$BT_REPO/$BT_PACKAGE/versions"
echo
cd $LOCAL_PATH
for F in artifacts.* content.* plugins/* features/*
do
  echo "deploying $F ..."
  curl -X PUT -T $F -u $BINTRAY_USER:$BINTRAY_API_KEY "https://api.bintray.com/content/$BT_OWNER/$BT_REPO/$BT_PACKAGE/$BT_VERSION/$F;bt_package=$BT_PACKAGE;bt_version=$BT_VERSION;publish=1"
  echo
done

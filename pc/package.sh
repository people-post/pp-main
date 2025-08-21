#!/bin/bash
WORK_DIR=obj
if [ -d $WORK_DIR ]
then
    rm -r $WORK_DIR
fi
mkdir $WORK_DIR

REPO_PATH=$WORK_DIR/repo
git clone git@github.com:nfsc-brief-web3/personal-node.git $REPO_PATH

BUNDLE_JS_PATH=$WORK_DIR/bundle.js

pushd $REPO_PATH
npm i
./package.sh
popd

cp $REPO_PATH/obj/bundle.js $BUNDLE_JS_PATH

SEA_CONFIG_PATH=$WORK_DIR/sea_config.json
SEA_BLOB_PATH=$WORK_DIR/sea-prep.blob
APP_PATH=$WORK_DIR/node

# Prepare blob
SEA_CONFIG="
{
    \"main\": \"${BUNDLE_JS_PATH}\",
    \"output\": \"${SEA_BLOB_PATH}\"
}
"
echo $SEA_CONFIG > $SEA_CONFIG_PATH
node --experimental-sea-config $SEA_CONFIG_PATH

# Prepare binary
cp $(command -v node) $APP_PATH
npx postject $APP_PATH NODE_SEA_BLOB $SEA_BLOB_PATH  --sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2

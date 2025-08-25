#!/bin/bash
# Dir prep
REPO_DIR=repo
if [ ! -d $REPO_DIR ]
then
    mkdir $REPO_DIR
fi

WORK_DIR=obj
if [ -d $WORK_DIR ]
then
    rm -r $WORK_DIR
fi
mkdir $WORK_DIR

DIST_DIR_NAME=dist
DIST_DIR_PATH=$WORK_DIR/$DIST_DIR_NAME
mkdir $DIST_DIR_PATH

# Repo operation
PN_REPO_DIR=$REPO_DIR/pn
if [ ! -d $PN_REPO_DIR ]
then
    git clone git@github.com:nfsc-brief-web3/personal-node.git $PN_REPO_DIR
fi

FRONTEND_REPO_DIR=$REPO_DIR/frontend
if [ ! -d $FRONTEND_REPO_DIR ]
then
    git clone git@github.com:nfsc-brief-team/frontend.git $FRONTEND_REPO_DIR
fi

pushd $PN_REPO_DIR
git pull
npm i
./package.sh
popd

pushd $FRONTEND_REPO_DIR
git pull
./package.sh
popd

FRONTEND_PKG_SRC_PATH=$FRONTEND_REPO_DIR/web3.tar.gz
FRONTEND_DIR_PATH=$DIST_DIR_PATH/static
tar -C $DIST_DIR_PATH -zxvf $FRONTEND_PKG_SRC_PATH
# Folder name "web3" is from fronend packaging script
mv $DIST_DIR_PATH/web3 $FRONTEND_DIR_PATH

BACKEND_JS_SRC_PATH=$PN_REPO_DIR/obj/bundle.js
BACKEND_JS_PATH=$DIST_DIR_PATH/host.js

cp $BACKEND_JS_SRC_PATH $BACKEND_JS_PATH

SEA_CONFIG_PATH=$WORK_DIR/sea_config.json
SEA_BLOB_PATH=$WORK_DIR/sea-prep.blob
APP_PATH=$WORK_DIR/node

# Prepare blob
SEA_CONFIG="
{
    \"main\": \"${BACKEND_JS_PATH}\",
    \"output\": \"${SEA_BLOB_PATH}\"
}
"
echo $SEA_CONFIG > $SEA_CONFIG_PATH
node --experimental-sea-config $SEA_CONFIG_PATH

# Prepare binary
cp $(command -v node) $APP_PATH
npx postject $APP_PATH NODE_SEA_BLOB $SEA_BLOB_PATH  --sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2

cp install.sh $DIST_DIR_PATH/.

# Packaging
PACKAGE_PATH=package.tar
# Create tarball
tar -C $WORK_DIR -cf $PACKAGE_PATH $DIST_DIR_NAME

# Zip package
gzip -f $PACKAGE_PATH

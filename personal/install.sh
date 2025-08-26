#!/bin/bash
# ------- Reading inputs --------
USER=$(id -un)
GROUP=$(id -gn)

read -p "Work dir root [$HOME/data]:" WORK_DIR_PATH
WORK_DIR_PATH=${WORK_DIR_PATH:-$HOME/data}

# ------- Prepare directories --------
if [ ! -d $WORK_DIR_PATH ]
then
    mkdir -p $WORK_DIR_PATH
fi

SERVER_DIR_PATH=$WORK_DIR_PATH/server
if [ ! -d $SERVER_DIR_PATH ]
then
    mkdir -p $SERVER_DIR_PATH
fi

IPFS_DATA_DIR_PATH=$WORK_DIR_PATH/ipfs
if [ ! -d $IPFS_DATA_DIR_PATH ]
then
    mkdir -p $IPFS_DATA_DIR_PATH
fi

# ------- Prepare dependencies --------
echo "Preparing ipfs..."
if command -v ipfs >/dev/null 2>&1
then
    echo "Ipfs exists."
else
    echo "Installing ipfs..."
    wget https://github.com/ipfs/kubo/releases/download/v0.36.0/kubo_v0.36.0_linux-arm64.tar.gz
    tar -xvzf kubo_v0.36.0_linux-arm64.tar.gz
    sudo mv kubo/ipfs /usr/local/bin/ipfs 
fi

IPFS_BIN_PATH=$(command -v ipfs)

# Systemd file
IPFS_SERVICE_FILE_PATH=/etc/systemd/system/ipfs.service
echo "Preparing ipfs service..."
cp ipfs.service.template ipfs.service
sed -i "s/__USER__/${USER}/g" ipfs.service
sed -i "s/__GROUP__/${GROUP}/g" ipfs.service
sed -i "s|__WORK_DIR__|${IPFS_DATA_DIR_PATH}|g" ipfs.service
sed -i "s|__IPFS_BIN__|${IPFS_BIN_PATH}|g" ipfs.service
if [ ! -f $IPFS_SERVICE_FILE_PATH ]
then
    sudo cp ipfs.service $IPFS_SERVICE_FILE_PATH
    sudo systemctl daemon-reload
    sudo systemctl start ipfs
    sudo systemctl enable ipfs
fi

echo "Preparing nodejs..."
if command -v node >/dev/null 2>&1
then
    echo "Nodejs exists."
else
    echo "Installing nodejs..."
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install 22
    source $HOME/.bashrc
fi
NODE_BIN_PATH=$(command -v node)

# Systemd file
NODE_SERVICE_FILE_PATH=/etc/systemd/system/node.service
echo "Preparing node service..."
cp node.service.template node.service
sed -i "s/__USER__/${USER}/g" node.service
sed -i "s/__GROUP__/${GROUP}/g" node.service
sed -i "s|__WORK_DIR__|${SERVER_DIR_PATH}|g" node.service
sed -i "s|__NODE_BIN__|${NODE_BIN_PATH}|g" node.service

if [ ! -f $NODE_SERVICE_FILE_PATH ]
then
    sudo cp node.service $NODE_SERVICE_FILE_PATH
    sudo systemctl daemon-reload
    sudo systemctl start node
    sudo systemctl enable node
fi

# ------- Unpack files --------
echo "Installing files..."
# Static
TMP_DIR=$WORK_DIR_PATH/server/static
if [ -d $TMP_DIR ]
then
    rm -r $TMP_DIR
fi
echo "Copying static files..."
cp -r static $TMP_DIR 

# Server code
echo "Copying server code..."
cp host.js $SERVER_DIR_PATH/index.js
pushd $SERVER_DIR_PATH
npm i sharp
popd

# Config.json file
CONFIG_FILE_PATH=$SERVER_DIR_PATH/config.json
if [ ! -f $CONFIG_FILE_PATH ]
then
    echo "Initializing server config..."
    # TODO:
fi

# Restart service
echo "Restarting server..."
sudo systemctl restart node

echo "Done"

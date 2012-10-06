#!/bin/bash
nodezmq_version="2.1.0"
stackio_version="0.2.1"
project_dir="/home/dotcloud/project"
node_root="/opt/node"
node_version="v0.8.9"

# Installing the zeromq library if it hasn't been yet.
# No system package for zeromq in Lucid :(
echo "# Checking for ZeroMQ presence"
test -f ~/.zmq_installed || (
    echo "# Installing zeromq-2.2.0"
    mkdir -p /home/dotcloud/installs/zeromq
    mkdir builds && cd builds
    wget http://download.zeromq.org/zeromq-2.2.0.tar.gz
    tar -xvf zeromq-2.2.0.tar.gz
    cd zeromq-2.2.0
    ./configure --prefix=/home/dotcloud/installs/zeromq; make; make install
    cd ../..
    rm -rf builds
    touch ~/.zmq_installed
)

echo "# Installing node $node_version"

[ "$node_version" ] &&
[ "$node_version" != "$(node --version)" ] &&
(
    rm -rf $node_root/*
    cd $node_root
    curl -L https://github.com/joyent/node/tarball/$node_version | tar -zxf -
    cd joyent-node-*
    ./configure --prefix=$node_root
    make
    make install
)

cd ${SERVICE_APPROOT:=.}

# Some user have their packages in their repository let's remove them,
# there is good chances that we are on a different architecture anyway.
[ -e "$project_dir/node_modules" ] && rm -rf "$project_dir/node_modules"

# Copy code to $HOME.
rsync -aH ./ $HOME/

# Install the specified dependencies.
# This will re-use already installed dependencies.
# To force the use of the latest version of a package:
# - specify a version specification in package.json;
# - or push with the "--clean" flag to discard the incremental build.
cd $HOME
echo "# Installing npm dependencies"
[ -f "$project_dir/package.json" ] && cd $project_dir && npm install

# OK, so this is where it gets bloody.
# We're installing node-zmq manually because we need to have
# the PKG_CONFIG_PATH configured properly for it to find the zeromq
# library we installed earlier.

echo "# Exporting PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/home/dotcloud/installs/zeromq/lib/pkgconfig"

echo "# Downloading node-zmq $nodezmq_version tarball"
mkdir -p /tmp/zmqnode && rm -rf /tmp/zmqnode/* && cd /tmp/zmqnode
curl -L https://github.com/shin-/zeromq.node/tarball/$nodezmq_version | tar -zxf -

echo "# Moving downloaded folder to node_modules"
mkdir $project_dir/node_modules # If no package.json / no other dependency
rm -rf $project_dir/node_modules/zmq
mv shin--* $project_dir/node_modules/zmq
cd $project_dir/node_modules/zmq

echo "# node-waf configure build"
PKG_CONFIG_PATH=/home/dotcloud/installs/zeromq/lib/pkgconfig node-waf configure build

# Finally, we can install stack.io
echo "# npm install stack.io"
cd $project_dir && npm install zerorpc@0.9.x stack.io@$stackio_version
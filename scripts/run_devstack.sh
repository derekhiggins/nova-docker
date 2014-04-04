#!/bin/bash

set -eux

BASEDIR=$(realpath $(dirname $0)/..)

export DEST=${DEST:-/opt/stack/new}
for PATCH in $(ls $BASEDIR/patches/* | sort -n) ; do
    PROJECTTOPATCH=$(basename $PATCH)
    PROJECTTOPATCH=${PROJECTTOPATCH%%_*}

    cd $DEST/$PROJECTTOPATCH
    git am < $PATCH
done

cd $BASEDIR
rm -f dist/*
python setup.py sdist
sudo pip install dist/*
cp $BASEDIR/etc/nova/rootwrap.d/docker.filters $DEST/nova/etc/nova/rootwrap.d/docker.filters

$DEST/devstack/tools/docker/install_docker.sh
#cp /opt/stack/new/devstack/samples/local.conf /opt/stack/new/devstack/local.conf
#./stack.sh
#. openrc admin
#nova boot --image cirros:latest --flavor m1.small testcontainer
#sleep 20
#nova list
#nova list | grep ACTIVE

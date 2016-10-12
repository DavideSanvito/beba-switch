#!/usr/bin/env bash

# Beba install script for Mininet 2.2.1 on Ubuntu 14.04 (64 bit)
# (https://github.com/mininet/mininet/wiki/Mininet-VM-Images)
# This script is based on "Mininet install script" by Brandon Heller
# (brandonh@stanford.edu)
#
# Authors: Davide Sanvito, Luca Pollini, Carmelo Cascone

CTRLURL="https://github.com/DavideSanvito/beba-ctrl.git"

# Exit immediately if a command exits with a non-zero status.
set -e

# Exit immediately if a command tries to use an unset variable
set -o nounset

# Install beba-ctrl
function beba-ctrl {
    echo "Installing Beba controller based on RYU..."

    # install beba-ctrl dependencies"
    sudo apt-get -y install autoconf automake g++ libtool python make libxml2 \
        libxslt-dev python-pip python-dev python-matplotlib hping3

    sudo pip install gevent pbr pulp networkx fnss numpy scapy
    sudo pip install -I six==1.9.0

    # fetch beba-ctrl
    cd ~/
    git clone -b travis-tests ${CTRLURL} beba-ctrl
    cd beba-ctrl

    # install beba-ctrl
    sudo pip install -r tools/pip-requires
    sudo python ./setup.py install
}

# Install Mininet
function mininet {
    echo "Installing Mininet"

    sudo apt-get install tcpdump

    # fetch Mininet
    cd ~/
    git clone -b 2.2.1 --single-branch https://github.com/mininet/mininet.git

    # install Mininet
    ~/mininet/util/install.sh -n
}

# Test BEBA applications
function test_beba_applications {
    cd ~/beba-ctrl/ryu/app/beba/test/
    ./run_all.sh verbose
}

sudo apt-get update
mininet
beba-ctrl
test_beba_applications


#!/bin/bash

# Since general public connectivity check need PUBLIC_TEST_IP for verification,
# Please set this environment if you cannot ping the default 8.8.8.8

# copy plugin functional tests to fuel-qa submodule
if [[ -z "$UNITY_SAN_IP" ]];then
    echo "Please set UNITY_SAN_IP in test environment."
    exit 1
fi


if [[ -z "$UNITY_PLUGIN_PATH" ]];then
    echo "Please set UNITY_PLUGIN_PATH in test environment."
    exit 2
fi
# Driver/plugin options
#export UNITY_SAN_IP="10.244.223.61"
export UNITY_SAN_LOGIN=${UNITY_SAN_LOGIN:-"admin"}
export UNITY_SAN_PASSWORD=${UNITY_SAN_PASSWORD:-"Password123!"}
export UNITY_VOLUME_BACKEND_NAME=${UNITY_VOLUME_BACKEND_NAME:-"unity-test"}

# export UNITY_PLUGIN_PATH="/home/jenkins/cinder-unity-1.0-1.0.0-1.noarch.rpm"
# Test environment options
export VENV_PATH=${VENV_PATH:-"/home/jenkins/venv-nailgun-tests-2.9"}
export TEST_GROUP=${TEST_GROUP:-"fuel_plugin_unity"}
export ISO_PATH=${ISO_PATH:-"/home/jenkins/fuel-9.0.iso"}

PLUGIN_TEST=$(dirname $0)
cd $PLUGIN_TEST

# init submodule

git submodule init
git submodule update
# copy plugin functional tests to fuel-qa submodule
cp -v unity_settings.py fuel-qa/fuelweb_test/

cp -rv tests/ fuel-qa/fuelweb_test/

fuel-qa/utils/jenkins/system_tests.sh -k -K -w $PWD/fuel-qa -j plugins -i $ISO_PATH -o --group=${TEST_GROUP}


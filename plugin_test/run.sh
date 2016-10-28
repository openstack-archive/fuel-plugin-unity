#!/bin/bash

# Since general public connectivity check need PUBLIC_TEST_IP for verification,
# Please set this environment if you cannot ping the default 8.8.8.8
export VENV_PATH="/home/jenkins/venv-nailgun-tests-2.9"

# copy plugin functional tests to fuel-qa submodule
export UNITY_SAN_IP="10.244.223.61"
export UNITY_SAN_LOGIN="admin"
export UNITY_SAN_PASSWORD="Password123!"
export UNITY_VOLUME_BACKEND_NAME="unity-test"
export UNITY_PLUGIN_PATH="/home/jenkins/cinder-unity-1.0-1.0.0-1.noarch.rpm"

export TEST_GROUP="fuel_plugin_unity"
export ISO_PATH="/home/jenkins/fuel-9.0.iso"

# init submodule

git submodule init
git submodule update
# copy plugin functional tests to fuel-qa submodule
cp -v unity_settings.py fuel-qa/fuelweb_test/

cp -rv tests/ fuel-qa/fuelweb_test/

fuel-qa/utils/jenkins/system_tests.sh -k -K -w $PWD/fuel-qa -j plugins -i $ISO_PATH -o --group=${TEST_GROUP}


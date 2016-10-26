#!/bin/bash

# copy plugin functional tests to fuel-qa submodule
export UNITY_SAN_IP=10.244.223.61
export UNITY_VOLUME_BACKNED_NAME=unity-test
cp -v unity_settings.py fuel-qa/fuelweb_test/

cp -rv tests/ fuel-qa/fuelweb_test/

cd fuel-qa

# TODO run tests


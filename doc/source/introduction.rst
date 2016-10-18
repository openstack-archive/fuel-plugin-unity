Introduction
============

Purpose
-------
This document will introduce the steps to install, configure, troublesthoot the
Unity Fuel plugin.

Overview
--------

Unity is great product, descibed as `Here
<https://www.emc.com/en-us/storage/unity.htm>`_:

   Unity delivers the ultimate in simplicity and value, enabling your
   organization to speed deployment, streamline management and seamlessly tier
   storage to the cloud.

This plugin introduces a graceful way to deploy Unity in Fuel OpenStack
environment.

Following procedures are processed in Unity plugin:

#. Install Unity Cinder driver.
#. Install *multipath-tools* and set *multipath.conf* if multipath is enabled.
#. Configure *cinder.conf* on *Controller node* to enable Unity back-end.
#. Restart *cinder-volume* on *Controller node* and *nova-compute* services on
   *Compute node*.


Limitations
-----------

#. Unity plugin is deployed on all *Controller node(s)*, it enables Unity as one
   Cinder volume backend by modify *enabled_backends*. If certain Cinder plugin
   places all its options under *[DEFALUT]* section, it will be disabled after
   deploying Unity plugin.


#. Unity plugin can only deploy one Unity in a Fuel cluster, to manage multiple
   Unity in one Unity, User needs to manually update */etc/cinder/cinder.conf*
   as follows.

    * Copy the existing section *[unity]* and append it at the end of
       */etc/cinder/cinder.conf*.

    * Change copied section name from *unity* to *whatever-you-want*.

    * Append the new section name *whatever-you-want* to *enabled_backends*.

    * Restart *cinder-volume* services on all *Controller node*.


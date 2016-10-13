User Guide
==========

Install and Configure
---------------------

#. Install Unity plugin as descripted `Installation Guide <./installation.rst>`_

#. Verify the Unity driver is up and running from the OpenStack Controller:
   ::

     root@node-9:~# cinder service-list
     +------------------+-------------------------+------+---------+-------+
     |      Binary      |           Host          | Zone |  Status | State |
     +------------------+-------------------------+------+---------+-------+
     |  cinder-backup   |    node-5.domain.tld    | nova | enabled |   up  |
     |  cinder-backup   |    node-9.domain.tld    | nova | enabled |   up  |
     | cinder-scheduler |    node-5.domain.tld    | nova | enabled |   up  |
     | cinder-scheduler |    node-9.domain.tld    | nova | enabled |   up  |
     |  cinder-volume   |      ha:unity@unity     | nova | enabled |   up  |
     +------------------+-------------------------+------+---------+-------+

   .. note:: Make sure *State* of *cinder-volume*  with name *ha:unity@unity* is *up*

#. Create a volume type with extra spec *volume_backend_name*, set value to
   *emc-unity*

     .. image:: images/unity-extra-specs.png

#. Create a volume with above created type, make sure volume is *available*.


#. Attach the volume to a VM instance.


FAQ
---

#. Failed to create/attach volume.
   Please inspect *cinder-volume.log* on controller node from mode detailed
   information.

#. Volume is not created on EMC Unity array.
   Double check extra specs for the emc volume type. Refer to
   above steps for details.

#. How can I Manage more than one Unity array in one OpenStack deployment.
   Due to the limitation of Fuel Web UI framework, Plugin can hardly define a
   approach to configure multiple Unity array in one time.
   To do this, User has to append new Unity array configuration to existing
   */etc/cinder/cinder.conf* and restart *cinder-volume* service on all
   controller nodes.

#. Cannot see plugin pages in Fuel Web UI.
   This is a limitation of Fuel:user cannot enable new plugin for a existing
   OpenStack deployment. User need to install the Unity plugin before creating new
   OpenStack deployment.


Installation Guide
==================

Install the Unity Cinder Fuel plugin
------------------------------------

#. Download rpm from the
   `Unlocked Partners >>EMC <https://www.mirantis.com/partners/emc/>`_.

#. Copy the *rpm* file to the Fuel Master node:
   ::

     [root@home ~]# scp cinder-unity-1.0-1.0.0-1.noarch.rpm root@fuel-master:/tmp

#. Log into Fuel Master node and install the plugin using the
   `Fuel CLI <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#using-fuel-cli>`_:

   ::

     [root@fuel ~]# fuel plugins --install /tmp/cinder-unity-1.0-1.0.0-1.noarch.rpm

#. Verify that the plugin is installed correctly:
   ::

    [root@fuel ~]# fuel plugins
    id | name          | version | package_version | releases
    ---+---------------+---------+-----------------+-----------------------------------------------
    18 | cinder-unity  | 1.0.0   | 3.0.0           | ubuntu (2015.1.0-7.0, liberty-8.0, mitaka-9.0)


.. raw::pdf

   PageBreak

Configure Unity plugin
----------------------
Once the plugin has been copied and installed at the
Fuel Master node, you can configure the nodes and set the parameters for the plugin:

#. Create a new OpenStack environment by following:
   `Mirantis OpenStack User Guide <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

#. `Configure your environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#configure-your-environment>`_. according to your requirements.


#. Open the **Settings**  tab of the Fuel web UI and click *Unity fuel plugin for Cinder*.
   Select the Fuel plugin checkbox to enable Unity plugin:

   .. image:: images/unity-plugin-settings.png

   .. note:: Please refer to `Unity Cinder driver <https://github.com/emc-openstack/unity-cinder-driver>`_ for each option.


#. You can run the network verification check and
   `deploy changes <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#deploy-changes>`_ then.

#. After deployment is completed, you should see a success message:

    .. image:: images/unity-deploy-success.png


.. note:: It may take an hour or more for the OpenStack deployment
          to complete, depending on your hardware configuration.


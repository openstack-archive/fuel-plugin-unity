#    Copyright 2016 DELL EMC, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
import os

from proboscis.asserts import assert_equal, assert_true
from proboscis import test

from fuelweb_test import logger
from fuelweb_test.helpers.decorators import log_snapshot_after_test
from fuelweb_test.helpers import checkers
from fuelweb_test.helpers import utils
from fuelweb_test.settings import DEPLOYMENT_MODE
from fuelweb_test.settings import NEUTRON_SEGMENT
from fuelweb_test.tests.base_test_case import SetupEnvironment
from fuelweb_test.tests.base_test_case import TestBasic

from fuelweb_test import unity_settings


def get_opts_from_settings(settings):

    options = {
        'metadata/enabled': True,
        'san_ip': unity_settings.UNITY_SAN_IP,
        'san_login': unity_settings.UNITY_SAN_LOGIN,
        'san_password': unity_settings.UNITY_SAN_PASSWORD,
        'storage_protocol': unity_settings.UNITY_STORAGE_PROTOCOL,
        'volume_driver': unity_settings.UNITY_VOLUME_DRIVER,
        'volume_backend_name': unity_settings.UNITY_VOLUME_BACKEND_NAME,
        'use_multipath': unity_settings.UNITY_USE_MULTIPATH}
    if unity_settings.UNITY_STORAGE_POOL_NAMES:
        options.update(
            {'storage_pool_names':
                unity_settings.UNITY_STORAGE_POOL_NAMES})
    return options


def verify_cinder_opts(cinder_node, options):
    result = cinder_node.open('/etc/cinder/cinder.conf')
    conf_for_check = utils.get_ini_config(result)
    expected_options = options.copy()
    expected_options.pop('metadata/enabled')
    for key, value in expected_options.items():
        utils.check_config(conf_for_check,
                           '/etc/cinder/cinder.conf',
                           'unity',
                           ('use_multipath_for_image_xfer' if key ==
                            'use_multipath' else key),
                           value)


def verify_nova_opts(nova_node, options):
    result = nova_node.open('/etc/nova/nova.conf')
    conf_for_check = utils.get_ini_config(result)
    use_multipath = options['use_multipath']
    utils.check_config(conf_for_check,
                       '/etc/nova/nova.conf',
                       'libvirt',
                       'iscsi_use_multipath',
                       use_multipath)


@test(groups=["fuel_plugins", "fuel_plugin_unity"])
class UnityPlugin(TestBasic):
    """Unity plugin related functional tests."""

    @test(depends_on=[SetupEnvironment.prepare_slaves_9],
          groups=["deploy_ha_unity"])
    @log_snapshot_after_test
    def deploy_ha_3_controller(self):
        """Deploy cluster with 3 controllers, ceph nodes and Unity plugin

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 3 nodes with controller role
            5. Add 3 nodes with ceph role
            6. Add 3 node with compute role
            7. Deploy the cluster
            8. Run network verification
            9. Check plugin health
            10. Run OSTF

        Duration 35m
        Snapshot deploy_ha_3_controller
        """
        checkers.check_plugin_path_env(
            var_name='UNITY_PLUGIN_PATH',
            plugin_path=unity_settings.UNITY_PLUGIN_PATH
        )

        self.env.revert_snapshot("ready_with_9_slaves")

        # copy plugin to the master node
        checkers.check_archive_type(unity_settings.UNITY_PLUGIN_PATH)

        utils.upload_tarball(
            ip=self.ssh_manager.admin_ip,
            tar_path=unity_settings.UNITY_PLUGIN_PATH,
            tar_target='/var')

        # install plugin

        utils.install_plugin_check_code(
            ip=self.ssh_manager.admin_ip,
            plugin=os.path.basename(unity_settings.UNITY_PLUGIN_PATH))

        segment_type = NEUTRON_SEGMENT['vlan']
        cluster_id = self.fuel_web.create_cluster(
            name=self.__class__.__name__,
            mode=DEPLOYMENT_MODE,
            settings={
                "net_provider": 'neutron',
                "net_segment_type": segment_type,
                "propagate_task_deploy": True,
                "volumes_ceph": True,
                "images_ceph": True,
                "volumes_lvm": False,
            }
        )

        plugin_name = 'cinder-unity'
        msg = "Plugin couldn't be enabled. Check plugin version. Test aborted"
        assert_true(
            self.fuel_web.check_plugin_exists(cluster_id, plugin_name),
            msg)
        options = get_opts_from_settings(unity_settings)
        self.fuel_web.update_plugin_data(cluster_id, plugin_name, options)

        self.fuel_web.update_nodes(
            cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['controller'],
                'slave-03': ['controller'],
                'slave-04': ['compute'],
                'slave-05': ['compute'],
                'slave-06': ['compute'],
                'slave-07': ['ceph-osd'],
                'slave-08': ['ceph-osd'],
                'slave-09': ['ceph-osd'],
            }
        )
        self.fuel_web.deploy_cluster_wait(cluster_id)

        self.fuel_web.verify_network(cluster_id)

        # check if service ran on controller
        logger.debug("Start to check service on node {0}".format('slave-01'))
        cmd = 'pgrep -f cinder-volume'

        with self.fuel_web.get_ssh_for_node("slave-01") as remote:
            verify_cinder_opts(remote, options)
            res_pgrep = remote.execute(cmd)
            assert_equal(0, res_pgrep['exit_code'],
                         'Failed with error {0}'.format(res_pgrep['stderr']))
            assert_equal(3, len(res_pgrep['stdout']),
                         'Failed with error {0}'.format(res_pgrep['stderr']))

        with self.fuel_web.get_ssh_for_node('slave-04') as nova:
            verify_nova_opts(nova, options)

        self.fuel_web.run_ostf(
            cluster_id=cluster_id)

        self.env.make_snapshot("deploy_ha_3_controller")

    @test(depends_on=[SetupEnvironment.prepare_slaves_5],
          groups=["deploy_ha_unity"])
    @log_snapshot_after_test
    def deploy_ha_lvm_cinder(self):
        """Deploy cluster with 2 controllers(lvm cinder nodes) and Unity plugin

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 2 nodes with controller role
            5. Add 1 node with compute role
            5. Add 2 nodes with cinder role
            6. Deploy the cluster
            7. Run network verification
            8. Check plugin health
            9. Run OSTF

        Duration 35m
        Snapshot deploy_ha_lvm_cinder
        """
        checkers.check_plugin_path_env(
            var_name='UNITY_PLUGIN_PATH',
            plugin_path=unity_settings.UNITY_PLUGIN_PATH
        )

        self.env.revert_snapshot("ready_with_5_slaves")

        # copy plugin to the master node
        checkers.check_archive_type(unity_settings.UNITY_PLUGIN_PATH)

        utils.upload_tarball(
            ip=self.ssh_manager.admin_ip,
            tar_path=unity_settings.UNITY_PLUGIN_PATH,
            tar_target='/var')

        # install plugin

        utils.install_plugin_check_code(
            ip=self.ssh_manager.admin_ip,
            plugin=os.path.basename(unity_settings.UNITY_PLUGIN_PATH))

        segment_type = NEUTRON_SEGMENT['vlan']
        cluster_id = self.fuel_web.create_cluster(
            name=self.__class__.__name__,
            mode=DEPLOYMENT_MODE,
            settings={
                "net_provider": 'neutron',
                "net_segment_type": segment_type,
                "propagate_task_deploy": True,
            }
        )

        plugin_name = 'cinder-unity'
        msg = "Plugin couldn't be enabled. Check plugin version. Test aborted"
        assert_true(
            self.fuel_web.check_plugin_exists(cluster_id, plugin_name),
            msg)

        options = get_opts_from_settings(unity_settings)
        self.fuel_web.update_plugin_data(cluster_id, plugin_name, options)

        self.fuel_web.update_nodes(
            cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['controller'],
                'slave-03': ['compute'],
                'slave-04': ['cinder'],
                'slave-05': ['cinder'],
            }
        )
        self.fuel_web.deploy_cluster_wait(cluster_id)

        self.fuel_web.verify_network(cluster_id)

        # check if service ran on controller
        logger.debug("Start to check service on node {0}".format('slave-01'))
        cmd = 'pgrep -f cinder-volume'

        # Check Cinder and Nova config
        with self.fuel_web.get_ssh_for_node("slave-01") as remote:
            verify_cinder_opts(remote, options)
            res_pgrep = remote.execute(cmd)
            assert_equal(0, res_pgrep['exit_code'],
                         'Failed with error {0}'.format(res_pgrep['stderr']))
            assert_equal(2, len(res_pgrep['stdout']),
                         'Failed with error {0}'.format(res_pgrep['stderr']))

        self.fuel_web.run_ostf(
            cluster_id=cluster_id)

        self.env.make_snapshot("deploy_ha_lvm_cinder")

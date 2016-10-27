import os


UNITY_PLUGIN_NAME = 'cinder-unity'
UNITY_VERSION = '1.0.0'

UNITY_PLUGIN_PATH = os.environ.get('UNITY_PLUGIN_PATH')


# Driver specific options

# Storage protocol
UNITY_STORAGE_PROTOCOL = os.environ.get('UNITY_STORAGE_PROTOCOL', 'iSCSI')
# Storage pool which the backend is going to manage
UNITY_STORAGE_POOL_NAMES = os.environ.get('UNITY_STORAGE_POOL_NAMES')
# Unisphere IP
UNITY_SAN_IP = os.environ.get('UNITY_SAN_IP')
# Unisphere username and password
UNITY_SAN_LOGIN = os.environ.get('UNITY_SAN_LOGIN', 'Local/admin')
UNITY_SAN_PASSWORD = os.environ.get('UNITY_SAN_PASSWORD', 'Password123!')
# Volume driver name
UNITY_VOLUME_DRIVER = os.environ.get(
    'UNITY_VOLUME_DRIVER',
    'cinder.volume.drivers.emc.emc_unity.EMCUnityDriver')
# backend's name
UNITY_VOLUME_BACKEND_NAME = os.environ.get('UNITY_VOLUME_BACKEND_NAME')

UNITY_USE_MULTIPATH = os.environ.get('UNITY_USE_MULTIPATH', 'True')

# Unity Plugin for Fuel

## Overview

This plugin configures Unity storage for Cinder using multi-backend feature.

## Requirements

### Mirantis OpenStack version

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Mirantis OpenStack               | 7.0             |
| Mirantis OpenStack               | 8.0             |
| Mirantis OpenStack               | 9.0             |

### Unity version

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Unity                            | OE v4.0.x       |

## Recommendations

* Configure at least 2 paths on Unity to establish HA of storage data path.
* Enable multipath for both Nova and cinder side.

## Limitations

* Plugin supports Ubuntu environment only

# Installation Guide

## Install from rpm

1. Download rpm from [Fuel Plugins
   Catalog](https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/)

2. Copy the rpm file to the Fuel master node

    ```
    [root@home ~]# scp fuel-plugin-unity-x.x-x.x.x-1.noarch.rpm root@fuel-master:/tmp
    ```

3. Log into Fuel master and install it using Fuel CLI

    ```
    [root@fuel ~]# fuel plugins --install /tmp/cinder-unity-1.0-1.0.0-1.noarch.rpm
    ```

## Install from source

1. Clone this Unity Fuel plugin git repository:

    ```
    git clone https://github.com/openstack/fuel-plugin-unity.git
    cd fuel-plugin-unity
    # checkout certain branch if necessary
    # git checkout xxxx
    ```

2. Validate the plugin:

    ```
    fpb --check .
    ```

3. Build the plugin:

    ```
    fpb --build .
    ```

4. Copy the built `cinder-unity-1.0-1.0.0-1.noarch.rpm` to Fuel master:

    ```
    scp cinder-unity-1.0-1.0.0-1.noarch.rpm root@fuel-master:/tmp
    ```

5. Install plugin using Fuel CLI:

    ```
    fuel plugins --install /tmp/cinder-unity-1.0-1.0.0-1.noarch.rpm
    ```

# Contributions

This is a standard OpenStack project, please refe to [How To
Contribute](https://wiki.openstack.org/wiki/How_To_Contribute).

# Bugs, requests, questions

Please use the [Launchpad project site](
https://launchpad.net/fuel-plugin-unity) to report bugs, request features,
ask questions, etc.

# License

Please read the [LICENSE](LICENSE) document for the latest licensing information.

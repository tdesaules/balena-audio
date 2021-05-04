# BLUETOOTH CONTAINER

## Details

## Workaround dbus org.bluealsa

1. mount the root file system in rw :

    `mount -o remount, rw /`

2. edit file :

    `/etc/dbus-1/system.d/bluealsa.conf`

3. copy content :

    ```xml
    <!-- This configuration file specifies the required security policies
        for BlueALSA core daemon to work. -->

    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
    "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>

    <!-- ../system.conf have denied everything, so we just punch some holes -->

    <policy user="root">
        <allow own_prefix="org.bluealsa"/>
        <allow send_destination="org.bluealsa"/>
    </policy>

    <policy group="audio">
        <allow send_destination="org.bluealsa"/>
    </policy>

    </busconfig>
    ```

4. reboot BalenaOS

    `reboot`
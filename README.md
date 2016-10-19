# huawei-yota
Init script for auto choosing light tarif on hello.yota.ru.
For easy using Huawei modems for IoT.
Tested on E8372 and E3372

## provision

    telnet 192.168.8.1
    mount -o rw,remount,rw /system
    # copy and paste this autorun.sh without shebang to the end of
    busybox vi /etc/autorun.sh
    # press 'i' to start editing and ':wq!' then done
    mount -o ro,remount,ro /system

#!/bin/bash -e

function usage() {
    echo "Usage: $0 [options...]" 1>&2
    echo ""
    echo "Available options:"
    echo "    <-i image_file> - indicates the path to the image file (e.g. -i /home/user/Download/file.img.gz)"
    echo "    <-d sdcard_dev> - indicates the path to the sdcard block device (e.g. -d /dev/mmcblk0)"
    echo "    [-m modem:apn:user:pwd:pin] - configures the mobile network modem (e.g. -m ttyUSB0:internet)"
    echo "    [-n ssid:psk] - sets the wireless network name and key (e.g. -n mynet:mykey1234)"
    echo "    [-s ip/cidr:gw:dns] - sets a static IP configuration instead of DHCP (e.g. -s 192.168.1.101/24:192.168.1.1:8.8.8.8)"
    exit 1
}

function msg() {
    echo "$(date) $1"
}

# use this function to unmount regardless of MAC OS or not
function smartUnmount() {
	msg "Unmounting $1"

	# if MAC OS
	if [ `uname` == "Darwin" ]; then
	    diskutil unmountDisk $1
	else # assuming Linux
		# unmount sdcard
    	umount $1* >/dev/null 2>&1
	fi
}

# use this function to mount regardless of MAC OS or not
function smartMount() {
	msg "Mounting $1"

	# if MAC OS
	if [ `uname` == "Darwin" ]; then
	    diskutil mountDisk $1
	else # assuming Linux
		# unmount sdcard
    	umount $1* >/dev/null 2>&1
	fi
}

# This function will be ran upon script EXIT (using trap)
function cleanup {
	msg "Performing cleanup"

    set +e

    # unmount sdcard
    smartUnmount ${SDCARD_DEV}
}

if [ -z "$1" ]; then
    usage
fi

if [[ $(id -u) -ne 0 ]]; then echo "please run as root"; exit 1; fi

while getopts "a:d:f:h:i:lm:n:o:p:s:w" o; do
    case "$o" in
        d)
            SDCARD_DEV=$OPTARG
            ;;
        i)
            DISK_IMG=$OPTARG
            ;;
        m)
            IFS=":" SETTINGS=($OPTARG)
            MODEM=${SETTINGS[0]}
            APN=${SETTINGS[1]}
            MUSER=${SETTINGS[2]}
            MPWD=${SETTINGS[3]}
            PIN=${SETTINGS[4]}
            ;;
        n)
            IFS=":" NETWORK=($OPTARG)
            SSID=${NETWORK[0]}
            PSK=${NETWORK[1]}
            ;;
        s)
            IFS=":" S_IP=($OPTARG)
            IP=${S_IP[0]}
            GW=${S_IP[1]}
            DNS=${S_IP[2]}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "$SDCARD_DEV" ] || [ -z "$DISK_IMG" ]; then
    usage
fi

trap cleanup EXIT

BOOT=$(dirname $0)/.boot

if ! [ -f $DISK_IMG ]; then
    echo "could not find image file $DISK_IMG"
    exit 1
fi

gunzip=$(which unpigz || which gunzip)

if [[ $DISK_IMG == *.gz ]]; then
    msg "decompressing the gzipped image"
    $gunzip -c $DISK_IMG > ${DISK_IMG::-3}
    DISK_IMG=${DISK_IMG::-3}
fi

smartUnmount ${SDCARD_DEV}
msg "writing disk image to sdcard"
dd if=$DISK_IMG of=$SDCARD_DEV bs=1048576
sync

if which partprobe > /dev/null 2>&1; then
    msg "re-reading sdcard partition table"
    partprobe ${SDCARD_DEV}
fi

mkdir -p $BOOT

if [ `uname` == "Darwin" ]; then
    BOOT_DEV=${SDCARD_DEV}s1 # e.g. /dev/disk4s1

    # mount the disk
    hdiutil attach ${BOOT_DEV}

    BOOT=$(pwd)/.boot

    echo "set BOOT for MAC to $BOOT"
else # assuming Linux
    BOOT_DEV=${SDCARD_DEV}p1 # e.g. /dev/mmcblk0p1
    if ! [ -e ${SDCARD_DEV}p1 ]; then
        BOOT_DEV=${SDCARD_DEV}1 # e.g. /dev/sdc1
    fi
    mount $BOOT_DEV $BOOT
fi

# wifi
if [ -n "$SSID" ]; then
    msg "creating wireless configuration"
    conf=$BOOT/wpa_supplicant.conf
    echo "update_config=1" > $conf
    echo "ctrl_interface=/var/run/wpa_supplicant" >> $conf
    echo "network={" >> $conf
    echo "    scan_ssid=1" >> $conf
    echo "    ssid=\"$SSID\"" >> $conf
    if [ -n "$PSK" ]; then
        echo "    psk=\"$PSK\"" >> $conf
    fi
    echo -e "}\n" >> $conf
fi

# modem
if [ -n "$MODEM" ]; then
    msg "creating mobile network configuration"
    conf=$BOOT/ppp
    mkdir -p $conf
    echo $MODEM > $conf/modem
    echo "AT+CGDCONT=1,\"IP\",\"$APN\"" > $conf/apn
    echo > $conf/extra
    echo > $conf/auth
    echo > $conf/pin
    if [ -n "$MUSER" ]; then
        echo "user \"$MUSER\"" > $conf/auth
        echo "password \"$MPWD\"" >> $conf/auth
    fi
    if [ -n "$PIN" ]; then
        echo "AT+CPIN=$PIN" > $conf/pin
    fi
fi

# static ip
if [ -n "$IP" ] && [ -n "$GW" ] && [ -n "$DNS" ]; then
    msg "setting static IP configuration"
    conf=$BOOT/static_ip.conf
    echo "static_ip=\"$IP\"" > $conf
    echo "static_gw=\"$GW\"" >> $conf
    echo "static_dns=\"$DNS\"" >> $conf
fi

if [ `uname` == "Darwin" ]; then
	# copy created files over to the disk
	DISK_PARTITION=`diskutil info $BOOT_DEV | grep "Mount Point:" | sed 's/^[^/]*//' | sed 's/ /\\ /g'`

	echo "moving $BOOT/* to $DISK_PARTITION"

	mv -v "$BOOT"/* "$DISK_PARTITION"

	sync
	smartUnmount ${SDCARD_DEV}
	rmdir $BOOT
	diskutil eject ${SDCARD_DEV}
else
	sync
	smartUnmount $BOOT
	rmdir $BOOT
fi

msg "***you can now remove the sdcard***"

#!/bin/bash -e


function usage() {
    cat <<END_USAGE
Usage: $0 [options...]

Available options:
    <-i image_file> - indicates the path to the image file (e.g. -i /home/user/Download/file.img.gz)
    <-d sdcard_dev> - indicates the path to the sdcard block device (e.g. -d /dev/mmcblk0)
    [-m modem:apn:user:pwd:pin] - configures the mobile network modem (e.g. -m ttyUSB0:internet)
    [-n ssid:psk] - sets the wireless network name and key (e.g. -n mynet:mykey1234)
    [-s ip/cidr:gw:dns] - sets a static IP configuration instead of DHCP (e.g. -s 192.168.1.101/24:192.168.1.1:8.8.8.8)
END_USAGE
    exit 1
}

if [ -z "$1" ]; then
    usage 1>&2
fi

function msg() {
    echo " * $1"
}

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
            usage 1>&2
            ;;
    esac
done

if [ -z "$SDCARD_DEV" ] || [ -z "$DISK_IMG" ]; then
    usage 1>&2
fi

function cleanup {
    set +e

    # unmount sdcard
    umount "${SDCARD_DEV}"* >/dev/null 2>&1
}

trap cleanup EXIT

BOOT=$(dirname "$0")/.boot

if ! [ -f "$DISK_IMG" ]; then
    echo "could not find image file $DISK_IMG"
    exit 1
fi

if [[ $(id -u) -ne 0 ]]; then echo "please run as root"; exit 1; fi

gzip=$(which pigz 2>/dev/null || which gzip 2>/dev/null || true)
xz=$(which xz 2>/dev/null || true)
pv=$(which pv 2>/dev/null || true)
ddopts="status=none"
if [ -z "$pv" ]; then
	pv=cat
	ddopts="status=progress"
fi

extractor=""
extractopts=(-d -c)
if [[ $DISK_IMG == *.gz ]]; then
    if [ -z "$gzip" ]; then
        msg "make sure you have the gzip package installed"
        exit 1
    fi
    extractor=$gzip
elif [[ $DISK_IMG == *.xz ]]; then
    if [ -z "$xz" ]; then
        msg "make sure you have the xz package installed"
        exit 1
    fi
	extractor=$xz
fi

if [ -z "$extractor" ]; then
	msg "Could not determine archive type!"
	exit 1
fi

umount "${SDCARD_DEV}"* 2>/dev/null || true
msg "extracting disk image to sdcard"
do_extract=("$extractor" ${extractopts[@]})
$pv "$DISK_IMG" | "${do_extract[@]}" | dd of="$SDCARD_DEV" bs=4M iflag=fullblock oflag=direct,sync $ddopts
#sync

if which partprobe > /dev/null 2>&1; then
    msg "re-reading sdcard partition table"
    partprobe "${SDCARD_DEV}"
    sleep 1
fi

msg "mounting sdcard"
mkdir -p "$BOOT"

if [ "$(uname)" == "Darwin" ]; then
    BOOT_DEV=${SDCARD_DEV}s1 # e.g. /dev/disk4s1
    diskutil unmountDisk "${SDCARD_DEV}"
    mount -ft msdos "$BOOT_DEV" "$BOOT"
else # assuming Linux
    BOOT_DEV=${SDCARD_DEV}p1 # e.g. /dev/mmcblk0p1
    if ! [ -e "${SDCARD_DEV}p1" ]; then
        BOOT_DEV=${SDCARD_DEV}1 # e.g. /dev/sdc1
    fi
    mount "$BOOT_DEV" "$BOOT"
fi

# wifi
if [ -n "$SSID" ]; then
    msg "creating wireless configuration"
    conf=$BOOT/wpa_supplicant.conf
    {
    echo "update_config=1"
    echo "ctrl_interface=/var/run/wpa_supplicant"
    echo "network={"
    echo "    scan_ssid=1"
    echo "    ssid=\"$SSID\""
    if [ -n "$PSK" ]; then
        echo "    psk=\"$PSK\""
    fi
    echo "}"
    echo ""
    } > "$conf"
fi

# modem
if [ -n "$MODEM" ]; then
    msg "creating mobile network configuration"
    conf=$BOOT/ppp
    mkdir -p "$conf"
    echo "$MODEM" > "$conf/modem"
    echo "AT+CGDCONT=1,\"IP\",\"$APN\"" > "$conf/apn"
    echo > "$conf/extra"
    if [ -n "$MUSER" ]; then
        echo "user \"$MUSER\""
        echo "password \"$MPWD\""
    else
        echo
    fi > "$conf/auth"
    if [ -n "$PIN" ]; then
        echo "AT+CPIN=$PIN"
    else
        echo
    fi > "$conf/pin"
fi

# static ip
if [ -n "$IP" ] && [ -n "$GW" ] && [ -n "$DNS" ]; then
    msg "setting static IP configuration"
    conf=$BOOT/static_ip.conf
    {
    echo "STATIC_IP=\"$IP\""
    echo "STATIC_GW=\"$GW\""
    echo "STATIC_DNS=\"$DNS\""
    } > "$conf"
fi

msg "unmounting sdcard"
sync
umount "$BOOT"
rmdir "$BOOT"

msg "you can now remove the sdcard"


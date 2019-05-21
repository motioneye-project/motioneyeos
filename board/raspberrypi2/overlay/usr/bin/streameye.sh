#!/bin/bash

RASPIMJPEG_CONF=/data/etc/raspimjpeg.conf
RASPIMJPEG_LOG=/var/log/raspimjpeg.log
GSTREAMER_LOG=/var/log/gstreamer.log
MOTIONEYE_CONF=/data/etc/motioneye.conf
STREAMEYE_CONF=/data/etc/streameye.conf
STREAMEYE_LOG=/var/log/streameye.log


test -r ${RASPIMJPEG_CONF} || exit 1
test -r ${STREAMEYE_CONF} || exit 1

function watch() {
    source ${STREAMEYE_CONF}
    count=0
    while true; do
        sleep 5
        if [ "${PROTO}" = "rtsp" ]; then
            if ! ps aux | grep test-launch | grep -v grep &>/dev/null; then
                logger -t streameye -s "not running, respawning"
                start
            fi
        else
            if ! ps aux | grep raspimjpeg.py | grep -v grep &>/dev/null; then
                logger -t streameye -s "not running, respawning"
                start
            fi
        fi
    done
}

function configure_v4l2_cam() {
    video_arg="-d $1"

    horizontal_flip="0"
    hflip=$(grep -e ^hflip ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ "${hflip}" = "true" ]; then horizontal_flip="1"; fi
    v4l2-ctl ${video_arg} --set-ctrl=horizontal_flip=${horizontal_flip} &>/dev/null

    vertical_flip="0"
    vflip=$(grep -e ^vflip ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ "${vflip}" = "true" ]; then vertical_flip="1"; fi
    v4l2-ctl ${video_arg} --set-ctrl=vertical_flip=${vertical_flip} &>/dev/null

    rotate=$(grep -e ^rotation ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${rotate}" ]; then rotate="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=rotate=${rotate} &>/dev/null

    brightness=$(grep -e ^brightness ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${brightness}" ]; then brightness="50"; fi
    v4l2-ctl ${video_arg} --set-ctrl=brightness=${brightness} &>/dev/null

    contrast=$(grep -e ^contrast ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${contrast}" ]; then contrast="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=contrast=${contrast} &>/dev/null

    saturation=$(grep -e ^saturation ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${saturation}" ]; then saturation="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=saturation=${saturation} &>/dev/null

    sharpness=$(grep -e ^sharpness ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${sharpness}" ]; then sharpness="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=sharpness=${sharpness} &>/dev/null

    vstab=$(grep -e ^vstab ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${vstab}" ]; then vstab="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=image_stabilization=${vstab} &>/dev/null

    shutter=$(grep -e ^shutter ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${shutter}" ]; then shutter="0"; fi
    if [ "${#shutter}" -gt 2 ]; then shutter=$(echo ${shutter/%??/}); else shutter="0"; fi
    v4l2-ctl ${video_arg} --set-ctrl=exposure_time_absolute=${shutter} &>/dev/null

    iso=$(grep -e ^iso ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${iso}" ]; then iso="0"; fi
    if [ "${iso}" -ge 800 ]; then iso="4"
    elif [ "${iso}" -ge 400 ]; then iso="3"
    elif [ "${iso}" -ge 200 ]; then iso="2"
    elif [ "${iso}" -ge 100 ]; then iso="1"
    else iso="0"
    fi
    v4l2-ctl ${video_arg} --set-ctrl=iso_sensitivity=${iso} &>/dev/null

    awb=$(grep -e ^awb ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ "${awb}" = "off" ]; then awb="0"
    elif [ "${awb}" = "auto" ]; then awb="1"
    elif [ "${awb}" = "sunlight" ]; then awb="6"
    elif [ "${awb}" = "cloudy" ]; then awb="8"
    elif [ "${awb}" = "shade" ]; then awb="9"
    elif [ "${awb}" = "tungsten" ]; then awb="4"
    elif [ "${awb}" = "fluorescent" ]; then awb="3"
    elif [ "${awb}" = "incandescent" ]; then awb="2"
    elif [ "${awb}" = "flash" ]; then awb="7"
    elif [ "${awb}" = "horizon" ]; then awb="5"
    else awb="1"
    fi
    v4l2-ctl ${video_arg} --set-ctrl=white_balance_auto_preset=${awb} &>/dev/null

    metering=$(grep -e ^metering ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ "${metering}" = "spot" ]; then metering="2"
    elif [ "${metering}" = "center" ]; then metering="1"
    else metering="0"
    fi
    v4l2-ctl ${video_arg} --set-ctrl=exposure_metering_mode=${awb} &>/dev/null

    scene="0"
    exposure=$(grep -e ^exposure ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ "${exposure}" = "off" ]; then
        exposure="1"
    else
        if [ "${exposure}" = "night" ]; then scene="8"
        elif [ "${exposure}" = "backlight" ]; then scene="1"
        elif [ "${exposure}" = "sports" ]; then scene="11"
        elif [ "${exposure}" = "snow" ]; then scene="2"
        elif [ "${exposure}" = "beach" ]; then scene="2"
        elif [ "${exposure}" = "fireworks" ]; then scene="6"
        fi
        exposure="0"
    fi
    v4l2-ctl ${video_arg} --set-ctrl=auto_exposure=${exposure} &>/dev/null
    v4l2-ctl ${video_arg} --set-ctrl=scene_mode=${scene} &>/dev/null

    ev=$(grep -e ^ev ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${ev}" ]; then ev="0"; fi
    ev=$(expr ${ev} + 25)
    ev=$(expr ${ev} / 2)
    if [ "${ev}" -gt 24 ]; then ev="24"; fi
    v4l2-ctl ${video_arg} --set-ctrl=auto_exposure_bias=${ev} &>/dev/null

    video_bitrate=$(grep -e ^bitrate ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
    if [ -z "${video_bitrate}" ]; then video_bitrate="1000000"; fi
    v4l2-ctl ${video_arg} --set-ctrl=video_bitrate=${video_bitrate} &>/dev/null
}

function invalid_opt() {
    local e match="$1"
    shift
    for e; do [[ "${e}" == "${match}" ]] && return 1; done
    return 0
}

function start() {
    source ${STREAMEYE_CONF}
    streameye_opts="-p ${PORT}"
    if [ -n "${CREDENTIALS}" ] && [ "${AUTH}" = "basic" ]; then
        streameye_opts="${streameye_opts} -a basic -c ${CREDENTIALS}"
    fi
    
    if [ "${PROTO}" = "rtsp" ]; then
        pid=$(ps | grep test-launch | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
        if [ -n "${pid}" ]; then
            return
        fi
        
        RTSP_PORT=${RTSP_PORT:-554}

        iptables -A INPUT -p tcp -s localhost --dport ${RTSP_PORT} -j ACCEPT
        iptables -A INPUT -p tcp --dport ${RTSP_PORT} -j DROP

        audio_opts=""
        if [ -n "${AUDIO_DEV}" ]; then
            audio_bitrate=$(grep -e ^audio_bitrate ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            audio_channels=$(grep -e ^audio_channels ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            audio_extras=""
            if [ -n "${audio_bitrate}" ]; then
                audio_extras="${audio_extras},rate=${audio_bitrate}"
            fi
            if [ -n "${audio_channels}" ]; then
                audio_extras="${audio_extras},channels=${audio_channels}"
            fi
            audio_opts="alsasrc device=${AUDIO_DEV} ! audioresample ! audio/x-raw${audio_extras} ! queue ! voaacenc ! rtpmp4gpay pt=97 name=pay1"
        fi
        video_path="/dev/video0"
        if [ -n "${VIDEO_DEV}" ]; then
            video_path=${VIDEO_DEV}
        fi
        if [ -e "${video_path}" ]; then
            # Only configure camera if it is a Pi Cam
            if v4l2-ctl -d ${video_path} -D | grep -q 'bm2835 mmal'; then
                configure_v4l2_cam ${video_path}
            fi
            width=$(grep -e ^width ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            height=$(grep -e ^height ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            framerate=$(grep -e ^framerate ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            video_extras=""
            if [ -n "${width}" ]; then
                video_extras="${video_extras},width=${width}"
            fi
            if [ -n "${height}" ]; then
                video_extras="${video_extras},height=${height}"
            fi
            if [ -n "${framerate}" ]; then
                video_extras="${video_extras},framerate=${framerate}/1"
            fi
            video_opts="v4l2src device=${video_path} ! video/x-h264${video_extras} ! h264parse ! rtph264pay name=pay0 pt=96"

            if [ -r ${MOTIONEYE_CONF} ] && grep 'log-level debug' ${MOTIONEYE_CONF} >/dev/null; then
                streameye_opts="${streameye_opts} -d"
            fi

            test-launch -p ${RTSP_PORT} -m h264 "\"( ${video_opts} ${audio_opts} )\"" &>${GSTREAMER_LOG} &
            sleep 10
            gst-launch-1.0 -v rtspsrc location=rtsp://127.0.0.1:${RTSP_PORT}/h264 latency=0 drop-on-latency=1 ! rtph264depay ! h264parse ! omxh264dec ! videorate ! video/x-raw,framerate=5/1 ! jpegenc ! filesink location=/dev/stdout | streameye ${streameye_opts} &>${STREAMEYE_LOG} &
            sleep 5
        fi

        iptables -D INPUT -p tcp --dport ${RTSP_PORT} -j DROP
        iptables -D INPUT -p tcp -s localhost --dport ${RTSP_PORT} -j ACCEPT

    else
        pid=$(ps | grep raspimjpeg.py | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
        if [ -n "${pid}" ]; then
            return
        fi

        valid_opts=("awb" "brightness" "contrast" "denoise" "drc" "ev" "exposure" "framerate" "height" "hflip" "imxfx" "iso" "metering" "preview" "quality" "rotation" "saturation" "sharpness" "shutter" "vflip" "vstab" "width" "zoom")
        raspimjpeg_opts=""
        while read line; do
            key=$(echo ${line} | cut -d ' ' -f 1)
            if invalid_opt "${key}" "${valid_opts[@]}"; then
                continue
            fi
            if echo "${line}" | grep false &>/dev/null; then
                continue
            fi
            if echo "${line}" | grep true &>/dev/null; then
                line=${key}
            fi
            raspimjpeg_opts="${raspimjpeg_opts} --${line}"
        done < ${RASPIMJPEG_CONF}

        if [ -r ${MOTIONEYE_CONF} ] && grep 'log-level debug' ${MOTIONEYE_CONF} >/dev/null; then
            raspimjpeg_opts="${raspimjpeg_opts} -d"
            streameye_opts="${streameye_opts} -d"
        fi

        raspimjpeg.py ${raspimjpeg_opts} 2>${RASPIMJPEG_LOG} | streameye ${streameye_opts} &>${STREAMEYE_LOG} &

    fi
}

function stop() {
    # stop the streameye background watch process
    ps | grep streameye.sh | grep -v $$ | grep -v S94streameye| grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1 | xargs -r kill

    # stop the raspimjpeg process
    raspimjpeg_pid=$(ps | grep raspimjpeg.py | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
    # stop the gst-launch-1.0 process
    gst_launch_pid=$(ps | grep gst-launch-1.0 | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
    # stop the test-launch process
    test_launch_pid=$(ps | grep test-launch | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)

    if [ -n "${raspimjpeg_pid}" ]; then
        kill -HUP "${raspimjpeg_pid}" &>/dev/null
        count=0
        while kill -0 "${raspimjpeg_pid}" &>/dev/null && [ ${count} -lt 5 ]; do
            sleep 1
            count=$((${count} + 1))
        done
        kill -KILL "${raspimjpeg_pid}" &>/dev/null || true
    fi
    
    if [ -n "${gst_launch_pid}" ]; then
        kill -HUP "${gst_launch_pid}" &>/dev/null
        count=0
        while kill -0 "${gst_launch_pid}" &>/dev/null && [ ${count} -lt 5 ]; do
            sleep 1
            count=$((${count} + 1))
        done
        kill -KILL "${gst_launch_pid}" &>/dev/null || true
    fi

    if [ -n "${test_launch_pid}" ]; then
        kill -HUP "${test_launch_pid}" &>/dev/null
        count=0
        while kill -0 "${test_launch_pid}" &>/dev/null && [ ${count} -lt 5 ]; do
            sleep 1
            count=$((${count} + 1))
        done
        kill -KILL "${test_launch_pid}" &>/dev/null || true
    fi
}

case "$1" in
    start)
        start
        watch &
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        start
        watch &
        ;;

    *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 1
esac


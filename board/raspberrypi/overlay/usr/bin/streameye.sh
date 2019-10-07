#!/bin/bash

RASPIMJPEG_CONF=/data/etc/raspimjpeg.conf
RASPIMJPEG_LOG=/var/log/raspimjpeg.log
RTSPSERVER_LOG=/var/log/rtspserver.log
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
            if ! ps aux | grep v4l2multi_stream_mmal | grep -v grep &>/dev/null; then
                logger -t streameye -s "not running, respawning"
                start
            elif ! ps aux | grep v4l2rtspserver | grep -v grep &>/dev/null; then
                logger -t streameye -s "not running, respawning"
                start
            fi
        else
            if ! ps aux | grep raspimjpeg.py | grep -v grep &>/dev/null; then
                logger -t streameye -s "raspimjpeg.py not running, respawning"
                start
            fi
        fi
    done
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
    rtspserver_opts=""
    if [ -n "${CREDENTIALS}" ] && [ "${AUTH}" = "basic" ]; then
        streameye_opts="${streameye_opts} -a basic -c ${CREDENTIALS}"
        # TODO: Add RTSP Auth
    fi

    if [ "${PROTO}" = "rtsp" ]; then
        v4l2rtspserver_pid=$(ps | grep v4l2rtspserver | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
        v4l2multi_stream_mmal_pid=$(ps | grep v4l2multi_stream_mmal | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
        if [ -n "${v4l2rtspserver_pid}" ]; then
            if [ -n "${v4l2multi_stream_mmal_pid}" ]; then
                return
            fi
        fi

        RTSP_PORT=${RTSP_PORT:-554}
        MJPEG_WIDTH=${MJPEG_WIDTH:-640}
        MJPEG_HEIGHT=${MJPEG_HEIGHT:-480}
        MJPEG_FRAMERATE=${MJPEG_FRAMERATE:-5}
        MJPEG_BITRATE=${MJPEG_BITRATE:-800000}

        audio_path=""
        audio_opts=""
        if [ -n "${AUDIO_DEV}" ]; then
            audio_path=",${AUDIO_DEV}"

            # Audio bitrate: default 44100
            audio_bitrate=$(grep -e ^audio_bitrate ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            # Audio channels: default 2
            audio_channels=$(grep -e ^audio_channels ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            # Valid audio formats: S16_BE, S16_LE, S24_BE, S24_LE, S32_BE, S32_LE, ALAW, MULAW, S8, MPEG
            audio_format=$(grep -e ^audio_format ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            if [ -n "${audio_bitrate}" ]; then
                audio_opts="${audio_opts} -A ${audio_bitrate}"
            fi
            if [ -n "${audio_channels}" ]; then
                audio_opts="${audio_opts} -C ${audio_channels}"
            fi
            if [ -n "${audio_format}" ]; then
                audio_opts="${audio_opts} -a ${audio_format}"
            fi
        fi
        # hardcode to 90 for now
        vidid=90
        video_path="/dev/video${vidid}"
        rmmod v4l2loopback
        modprobe v4l2loopback video_nr=${vidid}
        if [ -e "${video_path}" ]; then
            valid_opts=("analoggain" "awb" "awbgains" "bitrate" "brightness" "colfx" "contrast" "denoise" "digitalgain" "drc" "ev" "exposure" "flicker" "framerate" "height" "hflip" "imxfx" "intra" "irefresh" "level" "metering" "profile" "roi" "rotation" "saturation" "sharpness" "shutter" "vflip" "vstab" "width" "mjpegbitrate" "mjpegframerate" "mjpegwidth" "mjpegheight")
            raspimjpeg_opts="--videoout ${video_path}"
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

            video_iso=$(grep -e ^iso ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            if [ -n "${video_iso}" ]; then
                raspimjpeg_opts="${raspimjpeg_opts} --ISO ${video_iso}"
            fi

            if [ -r ${MOTIONEYE_CONF} ] && grep 'log-level debug' ${MOTIONEYE_CONF} >/dev/null; then
                raspimjpeg_opts="${raspimjpeg_opts} -v"
                streameye_opts="${streameye_opts} -d"
            fi

            rtspserver_opts="${rtspserver_opts} -P ${RTSP_PORT} -u h264"
            video_framerate=$(grep -e ^framerate ${RASPIMJPEG_CONF} | cut -d ' ' -f 2)
            if [ -n "${video_framerate}" ]; then
                rtspserver_opts="${rtspserver_opts} -F ${video_framerate}"
            fi

            mjpeg_opts="--mjpegbitrate ${MJPEG_BITRATE} --mjpegwidth ${MJPEG_WIDTH} --mjpegheight ${MJPEG_HEIGHT} --mjpegframerate ${MJPEG_FRAMERATE}"
            raspimjpeg_opts="${raspimjpeg_opts} --intra 50 ${mjpeg_opts}"

            if [ -z "${v4l2multi_stream_mmal_pid}" ]; then
                v4l2multi_stream_mmal -v ${raspimjpeg_opts} -o - 2>${RTSPSERVER_LOG} | streameye ${streameye_opts} &>${STREAMEYE_LOG} &
                sleep 10
            fi

            if [ -z "${v4l2rtspserver_pid}" ]; then
                v4l2rtspserver ${rtspserver_opts} ${audio_opts} ${video_path}${audio_path} &>${RTSPSERVER_LOG} &
                sleep 5
            fi
        fi

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

    # stop the running streaming process
    processes=( "raspimjpeg.py" "v4l2rtspserver" "v4l2multi_stream_mmal" )
    for i in "${processes[@]}"
    do
        pid=$(ps | grep $i | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
        if [ -n "${pid}" ]; then
            kill -HUP "${pid}" &>/dev/null
            count=0
            while kill -0 "${pid}" &>/dev/null && [ ${count} -lt 5 ]; do
                sleep 1
                count=$((${count} + 1))
            done
            kill -KILL "${pid}" &>/dev/null || true
        fi
    done

    # stop the loopback device
    rmmod v4l2loopback
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

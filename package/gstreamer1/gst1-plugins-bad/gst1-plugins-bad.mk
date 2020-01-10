################################################################################
#
# gst1-plugins-bad
#
################################################################################

GST1_PLUGINS_BAD_VERSION = 1.16.2
GST1_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST1_PLUGINS_BAD_VERSION).tar.xz
GST1_PLUGINS_BAD_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-bad
GST1_PLUGINS_BAD_INSTALL_STAGING = YES
# Additional plugin licenses will be appended to GST1_PLUGINS_BAD_LICENSE and
# GST1_PLUGINS_BAD_LICENSE_FILES if enabled.
GST1_PLUGINS_BAD_LICENSE_FILES = COPYING.LIB
GST1_PLUGINS_BAD_LICENSE = LGPL-2.0+, LGPL-2.1+

GST1_PLUGINS_BAD_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

GST1_PLUGINS_BAD_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Ddirectsound=disabled \
	-Dd3dvideosink=disabled \
	-Dwinks=disabled \
	-Dandroidmedia=disabled \
	-Dapplemedia=disabled \
	-Dintrospection=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled

# Options which require currently unpackaged libraries
GST1_PLUGINS_BAD_CONF_OPTS += \
	-Dopensles=disabled \
	-Duvch264=disabled \
	-Dmsdk=disabled \
	-Dvoamrwbenc=disabled \
	-Dbs2b=disabled \
	-Dchromaprint=disabled \
	-Ddc1394=disabled \
	-Ddts=disabled \
	-Dresindvd=disabled \
	-Dfaac=disabled \
	-Dflite=disabled \
	-Dgsm=disabled \
	-Dkate=disabled \
	-Dladspa=disabled \
	-Dlv2=disabled \
	-Dlibde265=disabled \
	-Dmodplug=disabled \
	-Dmplex=disabled \
	-Dofa=disabled \
	-Dopenexr=disabled \
	-Dopenni2=disabled \
	-Dteletextdec=disabled \
	-Dwildmidi=disabled \
	-Dsmoothstreaming=disabled \
	-Dsoundtouch=disabled \
	-Dgme=disabled \
	-Dvdpau=disabled \
	-Dspandsp=disabled \
	-Diqa=disabled \
	-Dopencv=disabled

GST1_PLUGINS_BAD_DEPENDENCIES = gst1-plugins-base gstreamer1

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WAYLAND),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dwayland=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libdrm wayland wayland-protocols
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dwayland=disabled
endif

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_BAD_DEPENDENCIES += orc
GST1_PLUGINS_BAD_CONF_OPTS += -Dorc=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dorc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BLUEZ),y)
GST1_PLUGINS_BAD_DEPENDENCIES += bluez5_utils
GST1_PLUGINS_BAD_CONF_OPTS += -Dbluez=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dbluez=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ACCURIP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daccurip=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daccurip=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMDEC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dadpcmdec=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dadpcmdec=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dadpcmenc=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dadpcmenc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AIFF),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daiff=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daiff=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ASFMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dasfmux=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dasfmux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOBUFFERSPLIT),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiobuffersplit=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiobuffersplit=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOFXBAD),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiofxbad=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiofxbad=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOLATENCY),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiolatency=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiolatency=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOMIXMATRIX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiomixmatrix=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiomixmatrix=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOVISUALIZERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiovisualizers=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Daudiovisualizers=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dautoconvert=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dautoconvert=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BAYER),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dbayer=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dbayer=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CAMERABIN2),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dcamerabin2=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dcamerabin2=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_COLOREFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dcoloreffects=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dcoloreffects=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddebugutils=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddebugutils=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVBSUBOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvbsuboverlay=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvbsuboverlay=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvdspu=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvdspu=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FACEOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfaceoverlay=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfaceoverlay=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfestival=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfestival=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FIELDANALYSIS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfieldanalysis=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfieldanalysis=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREEVERB),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfreeverb=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfreeverb=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREI0R),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfrei0r=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfrei0r=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GAUDIEFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dgaudieffects=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dgaudieffects=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GEOMETRICTRANSFORM),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dgeometrictransform=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dgeometrictransform=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GDP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dgdp=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dgdp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ID3TAG),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Did3tag=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Did3tag=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTER),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dinter=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dinter=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTERLACE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dinterlace=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dinterlace=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVFPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Divfparse=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Divfparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVTC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Divtc=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Divtc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JP2KDECIMATOR),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Djp2kdecimator=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Djp2kdecimator=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JPEGFORMAT),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Djpegformat=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Djpegformat=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dlibrfb=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dlibrfb=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MIDI),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmidi=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmidi=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegdemux=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegdemux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGPSMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegpsmux=enabled
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegpsmux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegtsmux=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegtsmux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegtsdemux=enabled
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpegtsdemux=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MXF),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmxf=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmxf=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NETSIM),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dnetsim=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dnetsim=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ONVIF),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Donvif=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Donvif=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dpcapparse=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dpcapparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PNM),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dpnm=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dpnm=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PROXY),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dproxy=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dproxy=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RAWPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Drawparse=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Drawparse=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_REMOVESILENCE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dremovesilence=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dremovesilence=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RTMP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Drtmp=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += rtmpdump
else
GST1_PLUGINS_BAD_CONF_OPTS += -Drtmp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsdp=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsdp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SEGMENTCLIP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsegmentclip=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsegmentclip=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SIREN),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsiren=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsiren=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SMOOTH),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsmooth=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsmooth=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SPEED),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dspeed=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dspeed=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SUBENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsubenc=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsubenc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_TIMECODE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dtimecode=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dtimecode=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOFILTERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideofilters=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideofilters=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOFRAME_AUDIOLEVEL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideoframe_audiolevel=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideoframe_audiolevel=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOPARSERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideoparsers=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideoparsers=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOSIGNAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideosignal=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvideosignal=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VMNC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvmnc=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvmnc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_Y4M),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dy4m=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dy4m=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_YADIF),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dyadif=enabled
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dyadif=disabled
endif

# Plugins with dependencies

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ASSRENDER),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dassrender=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libass
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dassrender=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BZ2),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dbz2=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dbz2=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CURL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dcurl=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libcurl
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dcurl=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DASH),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddash=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libxml2
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddash=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DECKLINK),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddecklink=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddecklink=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DIRECTFB),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddirectfb=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += directfb
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddirectfb=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVB),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvb=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += dtv-scan-tables
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddvb=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FAAD),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfaad=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += faad2
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfaad=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FBDEV),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfbdev=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfbdev=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FDK_AAC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfdkaac=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += fdk-aac
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfdkaac=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FLUIDSYNTH),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dfluidsynth=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += fluidsynth
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dfluidsynth=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dgl=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dgl=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_HLS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dhls=enabled

ifeq ($(BR2_PACKAGE_NETTLE),y)
GST1_PLUGINS_BAD_DEPENDENCIES += nettle
GST1_PLUGINS_BAD_CONF_OPTS += -Dhls-crypto='nettle'
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
GST1_PLUGINS_BAD_DEPENDENCIES += libgcrypt
GST1_PLUGINS_BAD_CONF_OPTS += -Dhls-crypto='libgcrypt'
else
GST1_PLUGINS_BAD_DEPENDENCIES += openssl
GST1_PLUGINS_BAD_CONF_OPTS += -Dhls-crypto='openssl'
endif

else
GST1_PLUGINS_BAD_CONF_OPTS += -Dhls=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_KMS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dkms=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libdrm
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dkms=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBMMS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dlibmms=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libmms
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dlibmms=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DTLS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Ddtls=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += openssl
GST1_PLUGINS_BAD_HAS_BSD2C_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Ddtls=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_TTML),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dttml=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += cairo libxml2 pango
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dttml=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEG2ENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpeg2enc=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libmpeg2 mjpegtools
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmpeg2enc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MUSEPACK),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dmusepack=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += musepack
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dmusepack=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NEON),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dneon=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += neon
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dneon=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPENAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenal=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += openal
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenal=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPENH264),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenh264=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libopenh264
GST1_PLUGINS_BAD_HAS_BSD2C_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenh264=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPENJPEG),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenjpeg=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += openjpeg
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dopenjpeg=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPUS),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dopus=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += opus
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dopus=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RSVG),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Drsvg=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += librsvg
else
GST1_PLUGINS_BAD_CONF_OPTS += -Drsvg=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SBC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsbc=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += sbc
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsbc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SHM),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dshm=enabled
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dshm=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SNDFILE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsndfile=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libsndfile
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsndfile=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SRTP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dsrtp=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libsrtp
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dsrtp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VOAACENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dvoaacenc=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += vo-aacenc
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dvoaacenc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WEBP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebp=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += webp
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WEBRTC),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebrtc=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += gst1-plugins-base libnice
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebrtc=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WEBRTCDSP),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebrtcdsp=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += webrtc-audio-processing
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dwebrtcdsp=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WPE),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dwpe=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += libwpe wpewebkit wpebackend-fdo
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dwpe=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_X265),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dx265=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += x265
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dx265=disabled
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_ZBAR),y)
GST1_PLUGINS_BAD_CONF_OPTS += -Dzbar=enabled
GST1_PLUGINS_BAD_DEPENDENCIES += zbar
else
GST1_PLUGINS_BAD_CONF_OPTS += -Dzbar=disabled
endif

# Add GPL license if GPL licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_GPL_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += , GPL-2.0+
GST1_PLUGINS_BAD_LICENSE_FILES += COPYING
endif

# Add BSD license if BSD licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_BSD2C_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += , BSD-2-Clause
endif

# Add Unknown license if Unknown licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += , UNKNOWN
endif

# Use the following command to extract license info for plugins.
# # find . -name 'plugin-*.xml' | xargs grep license

$(eval $(meson-package))

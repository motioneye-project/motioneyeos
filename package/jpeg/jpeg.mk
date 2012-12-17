#############################################################
#
# jpeg
#
#############################################################

jpeg: $(if $(BR2_PACKAGE_JPEG_TURBO),jpeg-turbo,libjpeg)

host-jpeg: host-libjpeg
host-jpeg-source: host-libjpeg-source

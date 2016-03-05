################################################################################
#
# unzip
#
################################################################################

UNZIP_VERSION = 60
UNZIP_SOURCE = unzip$(UNZIP_VERSION).tgz
UNZIP_SITE = ftp://ftp.info-zip.org/pub/infozip/src
# take precedence over busybox implementation
UNZIP_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
UNZIP_LICENSE = Info-ZIP
UNZIP_LICENSE_FILES = LICENSE

$(eval $(cmake-package))

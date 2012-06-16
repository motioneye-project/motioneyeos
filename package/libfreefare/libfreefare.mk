#############################################################
#
# libfreefare
#
#############################################################
LIBFREEFARE_VERSION = 0.3.2
LIBFREEFARE_SITE = http://nfc-tools.googlecode.com/files
LIBFREEFARE_DEPENDENCIES = libnfc openssl

$(eval $(call AUTOTARGETS))

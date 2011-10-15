#############################################################
#
# gob2
#
#############################################################

GOB2_VERSION = 2.0.18
GOB2_SITE = http://ftp.5z.com/pub/gob
GOB2_DEPENDENCIES = libglib2 flex bison host-pkg-config host-flex
HOST_GOB2_DEPENDENCIES = host-libglib2

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))

# gob2 for the host
GOB2_HOST_BINARY:=$(HOST_DIR)/usr/bin/gob2

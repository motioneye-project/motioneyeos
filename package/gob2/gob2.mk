#############################################################
#
# gob2
#
#############################################################
GOB2_VERSION = 2.0.15
GOB2_SOURCE = gob2-$(GOB2_VERSION).tar.gz
GOB2_SITE = http://ftp.5z.com/pub/gob/
IPERF_CONF_ENV = ac_cv_lib_lex=-lfl

GOB2_DEPENDENCIES = libglib2 flex bison host-pkg-config host-flex

HOST_GOB2_DEPENDENCIES = host-libglib2

$(eval $(call AUTOTARGETS,package,gob2))
$(eval $(call AUTOTARGETS,package,gob2,host))

# gob2 for the host
GOB2_HOST_BINARY:=$(HOST_DIR)/usr/bin/gob2

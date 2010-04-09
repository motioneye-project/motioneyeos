#############################################################
#
# lzma
#
#############################################################
LZMA_VERSION:=4.32.7
LZMA_SOURCE:=lzma-$(LZMA_VERSION).tar.gz
LZMA_SITE:=http://tukaani.org/lzma/
LZMA_INSTALL_STAGING = YES
LZMA_INSTALL_TARGET = YES
LZMA_CONF_OPT = $(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)

$(eval $(call AUTOTARGETS,package,lzma))
$(eval $(call AUTOTARGETS,package,lzma,host))

LZMA=$(HOST_DIR)/usr/bin/lzma

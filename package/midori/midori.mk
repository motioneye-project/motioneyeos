#############################################################
#
# midori
#
#############################################################

MIDORI_VERSION = 0.2.6
MIDORI_SOURCE = midori-$(MIDORI_VERSION).tar.bz2
MIDORI_SITE = http://archive.xfce.org/src/apps/midori/0.2/
MIDORI_INSTALL_STAGING = NO
MIDORI_INSTALL_TARGET = YES

MIDORI_DEPENDENCIES = host-pkg-config host-intltool webkit libsexy libgtk2

define MIDORI_CONFIGURE_CMDS
       (cd $(@D); \
               $(TARGET_CONFIGURE_OPTS)        \
               ./waf configure                 \
               --prefix=/usr                   \
       )
endef

define MIDORI_BUILD_CMDS
       (cd $(@D); ./waf build -j $(BR2_JLEVEL))
endef

define MIDORI_INSTALL_TARGET_CMDS
       (cd $(@D); ./waf --destdir=$(TARGET_DIR) install)
endef

$(eval $(call GENTARGETS,package,midori))

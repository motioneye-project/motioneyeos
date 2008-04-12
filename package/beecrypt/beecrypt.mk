#############################################################
#
# beecrypt
#
#############################################################
BEECRYPT_VERSION = 4.1.2
BEECRYPT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/beecrypt
BEECRYPT_AUTORECONF = YES
BEECRYPT_INSTALL_STAGING = YES

BEECRYPT_CONF_OPT =  --without-cplusplus \
		--without-java \
		--without-python  \
		--disable-rpath

BEECRYPT_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,beecrypt))

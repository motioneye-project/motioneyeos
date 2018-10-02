################################################################################
#
# strongswan
#
################################################################################

STRONGSWAN_VERSION = 5.6.3
STRONGSWAN_SOURCE = strongswan-$(STRONGSWAN_VERSION).tar.bz2
STRONGSWAN_SITE = http://download.strongswan.org
STRONGSWAN_PATCH = \
	$(STRONGSWAN_SITE)/patches/27_gmp_pkcs1_verify_patch/strongswan-5.6.1-5.6.3_gmp-pkcs1-verify.patch \
	$(STRONGSWAN_SITE)/patches/28_gmp_pkcs1_overflow_patch/strongswan-4.4.0-5.7.0_gmp-pkcs1-overflow.patch
STRONGSWAN_LICENSE = GPL-2.0+
STRONGSWAN_LICENSE_FILES = COPYING LICENSE
STRONGSWAN_DEPENDENCIES = host-pkgconf
STRONGSWAN_INSTALL_STAGING = YES
STRONGSWAN_CONF_OPTS += \
	--without-lib-prefix \
	--enable-led \
	--enable-pkcs11=yes \
	--enable-kernel-netlink=yes \
	--enable-socket-default=yes \
	--enable-openssl=$(if $(BR2_PACKAGE_STRONGSWAN_OPENSSL),yes,no) \
	--enable-gcrypt=$(if $(BR2_PACKAGE_STRONGSWAN_GCRYPT),yes,no) \
	--enable-gmp=$(if $(BR2_PACKAGE_STRONGSWAN_GMP),yes,no) \
	--enable-af-alg=$(if $(BR2_PACKAGE_STRONGSWAN_AF_ALG),yes,no) \
	--enable-curl=$(if $(BR2_PACKAGE_STRONGSWAN_CURL),yes,no) \
	--enable-charon=$(if $(BR2_PACKAGE_STRONGSWAN_CHARON),yes,no) \
	--enable-tnccs-11=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_11),yes,no) \
	--enable-tnccs-20=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_20),yes,no) \
	--enable-tnccs-dynamic=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_DYNAMIC),yes,no) \
	--enable-eap-sim-pcsc=$(if $(BR2_PACKAGE_STRONGSWAN_EAP_SIM_PCSC),yes,no) \
	--enable-unity=$(if $(BR2_PACKAGE_STRONGSWAN_UNITY),yes,no) \
	--enable-stroke=$(if $(BR2_PACKAGE_STRONGSWAN_STROKE),yes,no) \
	--enable-sql=$(if $(BR2_PACKAGE_STRONGSWAN_SQL),yes,no) \
	--enable-pki=$(if $(BR2_PACKAGE_STRONGSWAN_PKI),yes,no) \
	--enable-scepclient=$(if $(BR2_PACKAGE_STRONGSWAN_SCEP),yes,no) \
	--enable-scripts=$(if $(BR2_PACKAGE_STRONGSWAN_SCRIPTS),yes,no) \
	--enable-vici=$(if $(BR2_PACKAGE_STRONGSWAN_VICI),yes,no) \
	--enable-swanctl=$(if $(BR2_PACKAGE_STRONGSWAN_VICI),yes,no) \
	--with-ipseclibdir=/usr/lib \
	--with-plugindir=/usr/lib/ipsec/plugins \
	--with-imcvdir=/usr/lib/ipsec/imcvs \
	--with-dev-headers=/usr/include

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
STRONGSWAN_CONF_ENV += LIBS='-latomic'
endif

ifeq ($(BR2_PACKAGE_STRONGSWAN_EAP),y)
STRONGSWAN_CONF_OPTS += \
	--enable-eap-sim \
	--enable-eap-sim-file \
	--enable-eap-aka \
	--enable-eap-aka-3gpp2 \
	--enable-eap-simaka-sql \
	--enable-eap-simaka-pseudonym \
	--enable-eap-simaka-reauth \
	--enable-eap-identity \
	--enable-eap-md5 \
	--enable-eap-gtc \
	--enable-eap-mschapv2 \
	--enable-eap-tls \
	--enable-eap-ttls \
	--enable-eap-peap \
	--enable-eap-tnc \
	--enable-eap-dynamic \
	--enable-eap-radius
STRONGSWAN_DEPENDENCIES += gmp
endif

STRONGSWAN_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_STRONGSWAN_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_STRONGSWAN_GCRYPT),libgcrypt) \
	$(if $(BR2_PACKAGE_STRONGSWAN_GMP),gmp) \
	$(if $(BR2_PACKAGE_STRONGSWAN_CURL),libcurl) \
	$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_11),libxml2) \
	$(if $(BR2_PACKAGE_STRONGSWAN_EAP_SIM_PCSC),pcsc-lite)

ifeq ($(BR2_PACKAGE_STRONGSWAN_SQL),y)
STRONGSWAN_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_SQLITE),sqlite) \
	$(if $(BR2_PACKAGE_MYSQL),mysql)
endif

# disable connmark/forecast until net/if.h vs. linux/if.h conflict resolved
# problem exist since linux 4.5 header changes
STRONGSWAN_CONF_OPTS += \
	--disable-connmark \
	--disable-forecast

$(eval $(autotools-package))

################################################################################
#
# strongswan
#
################################################################################

STRONGSWAN_VERSION = 5.0.4
STRONGSWAN_SOURCE = strongswan-$(STRONGSWAN_VERSION).tar.bz2
STRONGSWAN_SITE = http://download.strongswan.org
STRONGSWAN_LICENSE = GPLv2+
STRONGSWAN_LICENSE_FILES = COPYING LICENSE
STRONGSWAN_CONF_OPT +=                                                             \
      --enable-pkcs11=yes                                                          \
      --enable-kernel-netlink=$(if $(BR2_INET_IPV6),yes,no)                        \
      --enable-socket-default=$(if $(BR2_INET_IPV6),yes,no)                        \
      --enable-openssl=$(if $(BR2_PACKAGE_STRONGSWAN_OPENSSL),yes,no)              \
      --enable-gcrypt=$(if $(BR2_PACKAGE_STRONGSWAN_GCRYPT),yes,no)                \
      --enable-gmp=$(if $(BR2_PACKAGE_STRONGSWAN_GMP),yes,no)                      \
      --enable-af-alg=$(if $(BR2_PACKAGE_STRONGSWAN_AF_ALG),yes,no)                \
      --enable-curl=$(if $(BR2_PACKAGE_STRONGSWAN_CURL),yes,no)                    \
      --enable-charon=$(if $(BR2_PACKAGE_STRONGSWAN_CHARON),yes,no)                \
      --enable-tnccs-11=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_11),yes,no)            \
      --enable-tnccs-20=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_20),yes,no)            \
      --enable-tnccs-dynamic=$(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_DYNAMIC),yes,no)  \
      --enable-eap-sim-pcsc=$(if $(BR2_PACKAGE_STRONGSWAN_EAP_SIM_PCSC),yes,no)    \
      --enable-unity=$(if $(BR2_PACKAGE_STRONGSWAN_UNITY),yes,no)                  \
      --enable-stroke=$(if $(BR2_PACKAGE_STRONGSWAN_STROKE),yes,no)                \
      --enable-sql=$(if $(BR2_PACKAGE_STRONGSWAN_SQL),yes,no)                      \
      --enable-tools=$(if $(BR2_PACKAGE_STRONGSWAN_TOOLS),yes,no)                  \
      --enable-scripts=$(if $(BR2_PACKAGE_STRONGSWAN_SCRIPTS),yes,no)

ifeq ($(BR2_PACKAGE_STRONGSWAN_EAP),y)
STRONGSWAN_CONF_OPT +=              \
      --enable-eap-sim              \
      --enable-eap-sim-file         \
      --enable-eap-aka              \
      --enable-eap-aka-3gpp2        \
      --enable-eap-simaka-sql       \
      --enable-eap-simaka-pseudonym \
      --enable-eap-simaka-reauth    \
      --enable-eap-identity         \
      --enable-eap-md5              \
      --enable-eap-gtc              \
      --enable-eap-mschapv2         \
      --enable-eap-tls              \
      --enable-eap-ttls             \
      --enable-eap-peap             \
      --enable-eap-tnc              \
      --enable-eap-dynamic          \
      --enable-eap-radius
STRONGSWAN_DEPENDENCIES += gmp
endif

STRONGSWAN_DEPENDENCIES +=                               \
      $(if $(BR2_PACKAGE_STRONGSWAN_OPENSSL),openssl)    \
      $(if $(BR2_PACKAGE_STRONGSWAN_GCRYPT),libgcrypt)   \
      $(if $(BR2_PACKAGE_STRONGSWAN_GMP),gmp)            \
      $(if $(BR2_PACKAGE_STRONGSWAN_CURL),libcurl)       \
      $(if $(BR2_PACKAGE_STRONGSWAN_TNCCS_11),libxml2)   \
      $(if $(BR2_PACKAGE_STRONGSWAN_EAP_SIM_PCSC),pcsc-lite)

ifeq ($(BR2_PACKAGE_STRONGSWAN_SQL),y)
STRONGSWAN_DEPENDENCIES +=                               \
      $(if $(BR2_PACKAGE_SQLITE),sqlite)                 \
      $(if $(BR2_PACKAGE_MYSQL_CLIENT),mysql_client)
endif

$(eval $(autotools-package))

################################################################################
#
# json-c
#
################################################################################

JSON_C_VERSION = 0.9
JSON_C_SITE = http://oss.metaparadigm.com/json-c/
JSON_C_INSTALL_STAGING = YES

$(eval $(autotools-package))

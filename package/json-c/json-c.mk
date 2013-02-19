################################################################################
#
# json-c
#
################################################################################

JSON_C_VERSION = 0.10
JSON_C_SITE = https://github.com/downloads/json-c/json-c
JSON_C_INSTALL_STAGING = YES

$(eval $(autotools-package))

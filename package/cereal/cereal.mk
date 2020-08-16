################################################################################
#
# cereal
#
################################################################################

CEREAL_VERSION = 1.3.0
CEREAL_SITE = $(call github,USCiLab,cereal,v$(CEREAL_VERSION))
# For licensing, see also: https://github.com/USCiLab/cereal/issues/609
CEREAL_LICENSE = BSD-3-Clause (cereal), Zlib (base64.hpp), MIT (rapidjson), BSL-1.0 or MIT (rapidxml)
CEREAL_LICENSE_FILES = LICENSE include/cereal/external/base64.hpp include/cereal/external/rapidjson/rapidjson.h include/cereal/external/rapidxml/license.txt
CEREAL_INSTALL_STAGING = YES
CEREAL_INSTALL_TARGET = NO
CEREAL_CONF_OPTS = \
	-DTHREAD_SAFE=ON \
	-DJUST_INSTALL_CEREAL=ON

$(eval $(cmake-package))

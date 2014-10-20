################################################################################
#
# yaml-cpp
#
################################################################################

YAML_CPP_VERSION = 0.5.1
YAML_CPP_SITE = https://yaml-cpp.googlecode.com/files
YAML_CPP_INSTALL_STAGING = YES
YAML_CPP_LICENSE = MIT
YAML_CPP_LICENSE_FILES = license.txt

$(eval $(cmake-package))

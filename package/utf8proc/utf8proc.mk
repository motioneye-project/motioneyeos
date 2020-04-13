################################################################################
#
# utf8proc
#
################################################################################

UTF8PROC_VERSION = 2.5.0
UTF8PROC_SITE = $(call github,JuliaStrings,utf8proc,v$(UTF8PROC_VERSION))
UTF8PROC_LICENSE = MIT
UTF8PROC_LICENSE_FILES = LICENSE.md
UTF8PROC_INSTALL_STAGING = YES
UTF8PROC_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(cmake-package))

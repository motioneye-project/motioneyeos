################################################################################
#
# fdk-aac
#
################################################################################

FDK_AAC_VERSION = 0.1.5
FDK_AAC_SITE = http://downloads.sourceforge.net/project/opencore-amr/fdk-aac
FDK_AAC_LICENSE = fdk-aac license
FDK_AAC_LICENSE_FILES = NOTICE

FDK_AAC_INSTALL_STAGING = YES

$(eval $(autotools-package))

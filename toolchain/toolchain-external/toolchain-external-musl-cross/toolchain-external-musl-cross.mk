################################################################################
#
# toolchain-external-musl-cross
#
################################################################################

TOOLCHAIN_EXTERNAL_MUSL_CROSS_VERSION = 1.1.12
TOOLCHAIN_EXTERNAL_MUSL_CROSS_SITE = https://googledrive.com/host/0BwnS5DMB0YQ6bDhPZkpOYVFhbk0/musl-$(TOOLCHAIN_EXTERNAL_MUSL_CROSS_VERSION)

TOOLCHAIN_EXTERNAL_MUSL_CROSS_SOURCE = crossx86-$(TOOLCHAIN_EXTERNAL_PREFIX)-$(TOOLCHAIN_EXTERNAL_MUSL_CROSS_VERSION).tar.xz

$(eval $(toolchain-external-package))

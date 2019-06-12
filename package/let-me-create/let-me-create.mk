################################################################################
#
# LetMeCreate
#
################################################################################

LET_ME_CREATE_VERSION = 1.5.2
LET_ME_CREATE_SITE = $(call github,CreatorDev,LetMeCreate,v$(LET_ME_CREATE_VERSION))
LET_ME_CREATE_INSTALL_STAGING = YES
LET_ME_CREATE_LICENSE = BSD-3-Clause
LET_ME_CREATE_LICENSE_FILES = LICENSE

# pure static build not supported
ifeq ($(BR2_SHARED_LIBS),y)
LET_ME_CREATE_CONF_OPTS += -DBUILD_STATIC=OFF -DBUILD_SHARED=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LET_ME_CREATE_CONF_OPTS += -DBUILD_STATIC=ON -DBUILD_SHARED=ON
endif

ifeq ($(BR2_PACKAGE_LET_ME_CREATE_EXAMPLES),y)
LET_ME_CREATE_CONF_OPTS += -DBUILD_EXAMPLES=ON
else
LET_ME_CREATE_CONF_OPTS += -DBUILD_EXAMPLES=OFF
endif

$(eval $(cmake-package))

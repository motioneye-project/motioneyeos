#############################################################
#
# docker
#
#############################################################
DOCKER_VERSION = 1.5
DOCKER_SOURCE = docker-$(DOCKER_VERSION).tar.gz
DOCKER_SITE = http://icculus.org/openbox/2/docker
DOCKER_AUTORECONF = NO
DOCKER_INSTALL_STAGING = NO
DOCKER_INSTALL_TARGET = YES

DOCKER_MAKE_OPT = CC=$(TARGET_CC) CXX=$(TARGET_CXX) LD=$(TARGET_LD) \
					CFLAGS="-I$(STAGING_DIR)/usr/include" \
					LDFLAGS="-L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/lib"

DOCKER_INSTALL_TARGET_OPT = PREFIX=$(TARGET_DIR)/usr install

DOCKER_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,docker))


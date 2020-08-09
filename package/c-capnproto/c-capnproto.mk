################################################################################
#
# c-capnproto
#
################################################################################

C_CAPNPROTO_VERSION = 9053ebe6eeb2ae762655b982e27c341cb568366d
C_CAPNPROTO_SITE = https://github.com/opensourcerouting/c-capnproto.git
C_CAPNPROTO_SITE_METHOD = git
C_CAPNPROTO_GIT_SUBMODULES = YES
C_CAPNPROTO_LICENSE = MIT
C_CAPNPROTO_LICENSE_FILES = COPYING
C_CAPNPROTO_INSTALL_STAGING = YES

# Fetched from git with no configure script
C_CAPNPROTO_AUTORECONF = YES

# As a plugin for capnproto's capnpc, requires capnproto. Needs to be on the
# host to generate C code from message definitions.
C_CAPNPROTO_DEPENDENCIES = host-c-capnproto capnproto
HOST_C_CAPNPROTO_DEPENDENCIES = host-capnproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))

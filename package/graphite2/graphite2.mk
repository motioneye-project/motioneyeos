################################################################################
#
# graphite2
#
################################################################################

GRAPHITE2_VERSION = 1.3.10
GRAPHITE2_SOURCE = graphite2-$(GRAPHITE2_VERSION).tgz
GRAPHITE2_SITE = http://downloads.sourceforge.net/project/silgraphite/graphite2
GRAPHITE2_INSTALL_STAGING = YES
GRAPHITE2_LICENSE = LGPL-2.1+
GRAPHITE2_LICENSE_FILES = LICENSE

# Avoid building docs and tests to save time
define GRAPHITE2_DISABLE_TESTS_DOC
	$(SED) '/^add_subdirectory(doc)/d' \
		-e '/^add_subdirectory(tests)/d' \
		-e '/add_subdirectory(gr2fonttest)/d' \
		$(@D)/CMakeLists.txt
endef
GRAPHITE2_POST_PATCH_HOOKS += GRAPHITE2_DISABLE_TESTS_DOC

$(eval $(cmake-package))

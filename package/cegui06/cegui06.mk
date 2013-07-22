################################################################################
#
# cegui06
#
################################################################################

# Do not update the version, we need exactly that one for Spice.
CEGUI06_VERSION_MAJOR   = 0.6.2
CEGUI06_VERSION         = $(CEGUI06_VERSION_MAJOR)b
CEGUI06_SOURCE          = CEGUI-$(CEGUI06_VERSION).tar.gz
CEGUI06_SITE            = http://downloads.sourceforge.net/project/crayzedsgui/CEGUI%20Mk-2/$(CEGUI06_VERSION_MAJOR)
CEGUI06_LICENSE         = MIT
CEGUI06_LICENSE_FILES   = COPYING
CEGUI06_INSTALL_STAGING = YES

CEGUI06_DEPENDENCIES    =       \
    expat                       \
    freetype                    \
    pcre                        \

CEGUI06_CONF_OPT =              \
    --enable-expat              \
    --disable-external-tinyxml  \
    --disable-xerces-c          \
    --disable-libxml            \
    --disable-tinyxml           \
    --disable-opengl-renderer   \
    --disable-external-glew     \
    --disable-irrlicht-renderer \
    --disable-directfb-renderer \
    --disable-samples           \
    --disable-lua-module        \
    --disable-toluacegui        \
    --disable-external-toluapp  \

$(eval $(autotools-package))

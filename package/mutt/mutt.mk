#############################################################
#
# mutt
#
#############################################################
MUTT_VERSION:=1.5.17+20080114
MUTT_SOURCE:=mutt_$(MUTT_VERSION).orig.tar.gz
MUTT_PATCH:=mutt_$(MUTT_VERSION)-1.diff.gz
MUTT_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/m/mutt/
MUTT_DEPENDENCIES=ncurses
MUTT_CONF_OPT = \
		--disable-smtp \
		--disable-iconv \
		--without-wc-funcs
MUTT_AUTORECONF=YES

define MUTT_APPLY_DEBIAN_PATCHES
        if [ -d $(@D)/debian/patches ]; then \
                toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*.patch; \
        fi
endef

MUTT_POST_PATCH_HOOKS += MUTT_APPLY_DEBIAN_PATCHES

$(eval $(call AUTOTARGETS,package,mutt))
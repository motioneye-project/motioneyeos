############################################################
#
# Tremor (Integer decoder for Vorbis)
#
############################################################

TREMOR_SITE:=http://svn.xiph.org/trunk/Tremor/
TREMOR_SITE_METHOD:=svn
TREMOR_VERSION:=16259

TREMOR_AUTORECONF = YES
TREMOR_INSTALL_STAGING = YES
TREMOR_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package/multimedia,tremor))

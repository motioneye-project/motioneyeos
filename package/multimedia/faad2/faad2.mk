################################################################################
#
# faad2
#
################################################################################

FAAD2_VERSION = 2.7
FAAD2_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/faac
FAAD2_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/multimedia,faad2))

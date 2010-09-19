#############################################################
#
# genext2fs
#
#############################################################

GENEXT2FS_VERSION=1.4.1
GENEXT2FS_SOURCE=genext2fs-$(GENEXT2FS_VERSION).tar.gz
GENEXT2FS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/genext2fs

$(eval $(call AUTOTARGETS,package,genext2fs))
$(eval $(call AUTOTARGETS,package,genext2fs,host))

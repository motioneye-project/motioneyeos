#############################################################
#
# gzip
#
#############################################################
GZIP_VERSION:=1.4
GZIP_SOURCE:=gzip-$(GZIP_VERSION).tar.gz
GZIP_SITE:=$(BR2_GNU_MIRROR)/gzip

$(eval $(call AUTOTARGETS,package,gzip))

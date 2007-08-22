################################################################################
#
# a PPTP client
#
################################################################################

PPTP_LINUX_VERSION=1.7.0
PPTP_LINUX_SOURCE=pptp-linux_$(PPTP_LINUX_VERSION).orig.tar.gz
PPTP_LINUX_PATCH=pptp-linux_$(PPTP_LINUX_VERSION)-2.diff.gz
PPTP_LINUX_SITE=http://ftp.debian.org/debian/pool/main/p/pptp-linux/

$(eval $(call AUTOTARGETS,pptp-linux))

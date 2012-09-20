#############################################################
#
# socketcand
#
#############################################################
SOCKETCAND_VERSION = 7d06986
SOCKETCAND_SITE = http://github.com/dschanoeh/socketcand/tarball/master
SOCKETCAND_AUTORECONF = YES
SOCKETCAND_DEPENDENCIES = libconfig

$(eval $(autotools-package))

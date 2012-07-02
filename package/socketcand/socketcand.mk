#############################################################
#
# socketcand
#
#############################################################
SOCKETCAND_VERSION = 7d06986fa4b5fd2c210ec4e248dab41107be1ccd
SOCKETCAND_SITE = git://github.com/dschanoeh/socketcand.git
SOCKETCAND_AUTORECONF = YES
SOCKETCAND_DEPENDENCIES = libconfig

$(eval $(autotools-package))

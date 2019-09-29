################################################################################
#
# nohash
#
################################################################################

NOHASH_VERSION = a238b1dfcd825d47d834af3c5223417c8411d90d
NOHASH_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git

$(eval $(generic-package))

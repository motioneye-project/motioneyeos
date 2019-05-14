################################################################################
#
# git-sha1-tag-points-to
#
################################################################################

GIT_SHA1_TAG_POINTS_TO_VERSION = 516c9c5f64ec66534d4d069c2e408d9ae4dce023
GIT_SHA1_TAG_POINTS_TO_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_SHA1_TAG_POINTS_TO_LICENSE_FILES = file

$(eval $(generic-package))

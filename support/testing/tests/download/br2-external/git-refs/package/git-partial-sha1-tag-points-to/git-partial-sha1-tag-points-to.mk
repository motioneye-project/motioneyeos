################################################################################
#
# git-partial-sha1-tag-points-to
#
################################################################################

GIT_PARTIAL_SHA1_TAG_POINTS_TO_VERSION = 516c9c5f64ec66534d4d
GIT_PARTIAL_SHA1_TAG_POINTS_TO_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_PARTIAL_SHA1_TAG_POINTS_TO_LICENSE_FILES = file

$(eval $(generic-package))

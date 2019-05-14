################################################################################
#
# git-partial-sha1-reachable-by-tag
#
################################################################################

GIT_PARTIAL_SHA1_REACHABLE_BY_TAG_VERSION = 46bae5b639e5a18e2cc4
GIT_PARTIAL_SHA1_REACHABLE_BY_TAG_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_PARTIAL_SHA1_REACHABLE_BY_TAG_LICENSE_FILES = file

$(eval $(generic-package))

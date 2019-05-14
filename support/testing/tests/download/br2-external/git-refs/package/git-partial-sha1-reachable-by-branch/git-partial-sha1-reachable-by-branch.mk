################################################################################
#
# git-partial-sha1-reachable-by-branch
#
################################################################################

GIT_PARTIAL_SHA1_REACHABLE_BY_BRANCH_VERSION = 317406308d9259e2231b
GIT_PARTIAL_SHA1_REACHABLE_BY_BRANCH_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_PARTIAL_SHA1_REACHABLE_BY_BRANCH_LICENSE_FILES = file

$(eval $(generic-package))

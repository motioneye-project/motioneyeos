################################################################################
#
# git-sha1-reachable-by-branch
#
################################################################################

GIT_SHA1_REACHABLE_BY_BRANCH_VERSION = 317406308d9259e2231bd0d6ddad3de3832bce08
GIT_SHA1_REACHABLE_BY_BRANCH_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_SHA1_REACHABLE_BY_BRANCH_LICENSE_FILES = file

$(eval $(generic-package))

################################################################################
#
# git-partial-sha1-branch-head
#
################################################################################

GIT_PARTIAL_SHA1_BRANCH_HEAD_VERSION = 68c197d0879d485f4f6c
GIT_PARTIAL_SHA1_BRANCH_HEAD_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_PARTIAL_SHA1_BRANCH_HEAD_LICENSE_FILES = file

$(eval $(generic-package))

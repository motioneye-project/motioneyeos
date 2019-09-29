################################################################################
#
# git-tag
#
################################################################################

GIT_TAG_VERSION = mytag
GIT_TAG_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_TAG_LICENSE_FILES = file

$(eval $(generic-package))

################################################################################
#
# git-wrong-content
#
################################################################################

GIT_WRONG_CONTENT_VERSION = a238b1dfcd825d47d834af3c5223417c8411d90d
GIT_WRONG_CONTENT_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_WRONG_CONTENT_LICENSE_FILES = file

$(eval $(generic-package))

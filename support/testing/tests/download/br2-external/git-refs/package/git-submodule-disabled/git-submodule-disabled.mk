################################################################################
#
# git-submodule-disabled
#
################################################################################

GIT_SUBMODULE_DISABLED_VERSION = a9dbc1e23c45e8e1b88c0448763f54d714eb6f8f
GIT_SUBMODULE_DISABLED_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_SUBMODULE_DISABLED_LICENSE_FILES = file

$(eval $(generic-package))

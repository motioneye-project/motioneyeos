################################################################################
#
# git-special-ref
#
################################################################################

GIT_SPECIAL_REF_VERSION = b72ff6078f62522a87f5cae5e9f34dedf5ec3885
GIT_SPECIAL_REF_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git
GIT_SPECIAL_REF_LICENSE_FILES = file

$(eval $(generic-package))

################################################################################
#
# pseudo
#
################################################################################

PSEUDO_VERSION = 7abc9396731149df5eaf43c84fed4f3053b64de6
PSEUDO_SITE = https://git.yoctoproject.org/git/pseudo
PSEUDO_SITE_METHOD = git

# No "or later" clause.
PSEUDO_LICENSE = LGPLv2.1
PSEUDO_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))

################################################################################
#
# pamtester
#
################################################################################

PAMTESTER_VERSION = 0.1.2
PAMTESTER_SITE = https://download.sourceforge.net/project/pamtester/pamtester/$(PAMTESTER_VERSION)
PAMTESTER_DEPENDENCIES = linux-pam
PAMTESTER_LICENSE = BSD-3-Clause
PAMTESTER_LICENSE_FILES = LICENSE

$(eval $(autotools-package))

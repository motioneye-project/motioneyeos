################################################################################
#
# kobs-ng
#
################################################################################

# kobs-ng versions have never made much sense :(
KOBS_NG_VERSION = 3.0.35-4.0.0
KOBS_NG_SITE = http://repository.timesys.com/buildsources/k/kobs-ng/kobs-ng-$(KOBS_NG_VERSION)/
KOBS_NG_LICENSE = GPLv2+
KOBS_NG_LICENSE_FILES = COPYING

$(eval $(autotools-package))

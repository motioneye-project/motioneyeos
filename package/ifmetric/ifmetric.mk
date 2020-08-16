################################################################################
#
# ifmetric
#
################################################################################

IFMETRIC_VERSION = 0.3
IFMETRIC_SITE = http://0pointer.de/lennart/projects/ifmetric
IFMETRIC_LICENSE = GPL-2.0+
IFMETRIC_LICENSE_FILES = LICENSE README
# do not generate documentation
IFMETRIC_CONF_OPTS = --disable-lynx --disable-xmltoman

$(eval $(autotools-package))

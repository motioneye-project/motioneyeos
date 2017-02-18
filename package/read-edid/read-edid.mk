################################################################################
#
# read-edid
#
################################################################################

READ_EDID_VERSION = 3.0.2
READ_EDID_SITE = http://www.polypux.org/projects/read-edid
READ_EDID_LICENSE = BSD-like
READ_EDID_LICENSE_FILES = LICENSE

# disable classic get-edid support (needs libx86)
READ_EDID_CONF_OPTS += -DCLASSICBUILD=OFF

$(eval $(cmake-package))

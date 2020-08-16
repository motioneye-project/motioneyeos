################################################################################
#
# freescale-imx
#
################################################################################

FREESCALE_IMX_SITE = http://www.nxp.com/lgfiles/NMG/MAD/YOCTO

# Helper for self-extracting binaries distributed by Freescale.
#
# The --force option makes sure it doesn't fail if the source
# directory already exists. The --auto-accept skips the license check,
# as it is not needed in Buildroot because we have legal-info. Since
# there's a EULA in the binary file, we extract it in this macro, and
# it should therefore be added to the LICENSE_FILES variable of
# packages using this macro. Also, remember to set REDISTRIBUTE to
# "NO". Indeed, this is a legal minefield: the EULA specifies that the
# Board Support Package includes software and hardware (sic!) for
# which a separate license is needed...
#
# $(1): full path to the archive file
#
define FREESCALE_IMX_EXTRACT_HELPER
	awk 'BEGIN      { start = 0; } \
	     /^EOEULA/  { start = 0; } \
	                { if (start) print; } \
	     /<<EOEULA/ { start = 1; }' \
	    $(1) > $(@D)/EULA
	cd $(@D) && sh $(1) --force --auto-accept
	find $(@D)/$(basename $(notdir $(1))) -mindepth 1 -maxdepth 1 -exec mv {} $(@D) \;
	rmdir $(@D)/$(basename $(notdir $(1)))
endef

include $(sort $(wildcard package/freescale-imx/*/*.mk))

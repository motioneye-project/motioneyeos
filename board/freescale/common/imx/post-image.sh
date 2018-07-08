#!/usr/bin/env bash

#
# dtb_list extracts the list of DTB files from BR2_LINUX_KERNEL_INTREE_DTS_NAME
# in ${BR_CONFIG}, then prints the corresponding list of file names for the
# genimage configuration file
#
dtb_list()
{
	local DTB_LIST="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\([\/a-z0-9 \-]*\)"$/\1/p' ${BR2_CONFIG})"

	for dt in $DTB_LIST; do
		echo -n "\"`basename $dt`.dtb\", "
	done
}

#
# linux_image extracts the Linux image format from BR2_LINUX_KERNEL_UIMAGE in
# ${BR_CONFIG}, then prints the corresponding file name for the genimage
# configuration file
#
linux_image()
{
	if grep -Eq "^BR2_LINUX_KERNEL_UIMAGE=y$" ${BR2_CONFIG}; then
		echo "\"uImage\""
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGE=y$" ${BR2_CONFIG}; then
		echo "\"Image\""
	else
		echo "\"zImage\""
	fi
}

genimage_type()
{
	if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8M=y$" ${BR2_CONFIG}; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_TARGET_UBOOT_SPL=y$" ${BR2_CONFIG}; then
		echo "genimage.cfg.template_spl"
	else
		echo "genimage.cfg.template"
	fi
}

uboot_image()
{
	if grep -Eq "^BR2_TARGET_UBOOT_FORMAT_DTB_IMX=y$" ${BR2_CONFIG}; then
		echo "u-boot-dtb.imx"
	elif grep -Eq "^BR2_TARGET_UBOOT_FORMAT_IMX=y$" ${BR2_CONFIG}; then
		echo "u-boot.imx"
	fi
}

main()
{
	local FILES="$(dtb_list) $(linux_image)"
	local UBOOTBIN="$(uboot_image)"
	local GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

	sed -e "s/%FILES%/${FILES}/" \
		-e "s/%UBOOTBIN%/${UBOOTBIN}/" \
		board/freescale/common/imx/$(genimage_type) > ${GENIMAGE_CFG}

	rm -rf "${GENIMAGE_TMP}"

	genimage \
		--rootpath "${TARGET_DIR}" \
		--tmppath "${GENIMAGE_TMP}" \
		--inputpath "${BINARIES_DIR}" \
		--outputpath "${BINARIES_DIR}" \
		--config "${GENIMAGE_CFG}"

	rm -f ${GENIMAGE_CFG}

	exit $?
}

main $@

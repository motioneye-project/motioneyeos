############################################################
#
# nasm
#
# This is special case: nasm is used to build syslinux and
# pxelinux. As these are for the target, we should cross-compile
# nasm. However, as nasm is x86-only, there's no point in
# cross-compiling it. So we just build it for the host. The target
# variant is only provided because of a bug in the package
# infrastructure that prevents having only a host variant.
############################################################

NASM_VERSION=2.08.01
NASM_SOURCE=nasm-$(NASM_VERSION).tar.bz2
NASM_SITE=http://www.nasm.us/pub/nasm/releasebuilds/2.08.01/

$(eval $(call AUTOTARGETS,package,nasm))
$(eval $(call AUTOTARGETS,package,nasm,host))

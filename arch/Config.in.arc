choice
	prompt "Target CPU"
	default BR2_arc770d
	depends on BR2_arc
	help
	    Specific CPU to use

config BR2_arc750d
	bool "ARC 750D"

config BR2_arc770d
	bool "ARC 770D"

config BR2_archs38
	bool "ARC HS38"
	help
	  Generic ARC HS capable of running Linux, i.e. with MMU,
	  caches and 32-bit multiplier. Also it corresponds to the
	  default configuration in older GNU toolchain versions.

config BR2_archs38_64mpy
	bool "ARC HS38 with 64-bit mpy"
	help
	  Fully featured ARC HS capable of running Linux, i.e. with
	  MMU, caches and 64-bit multiplier.

	  If you're not sure which version of ARC HS core you build
	  for use this one.

config BR2_archs38_full
	bool "ARC HS38 with Quad MAC & FPU"
	help
	  Fully featured ARC HS with additional support for
	   - Dual- and quad multiply and MC oprations
	   - Double-precision FPU

	  It corresponds to "hs38_slc_full" ARC HS template in
	  ARChitect.

config BR2_archs4x_rel31
	bool "ARC HS48 rel 31"
	help
	   Latest release of HS48 processor
	   - Dual- and quad multiply and MC oprations
	   - Double-precision FPU

endchoice

# Choice of atomic instructions presence
config BR2_ARC_ATOMIC_EXT
	bool "Atomic extension (LLOCK/SCOND instructions)"
	default y if BR2_arc770d || BR2_archs38 || BR2_archs38_64mpy || BR2_archs38_full || BR2_archs4x_rel31

config BR2_ARCH
	default "arc"	if BR2_arcle
	default "arceb"	if BR2_arceb

config BR2_arc
	bool
	default y if BR2_arcle || BR2_arceb

config BR2_ENDIAN
	default "LITTLE" if BR2_arcle
	default "BIG"	 if BR2_arceb

config BR2_GCC_TARGET_CPU
	default "arc700" if BR2_arc750d
	default "arc700" if BR2_arc770d
	default "archs"	 if BR2_archs38
	default "hs38"	 if BR2_archs38_64mpy
	default "hs38_linux"	 if BR2_archs38_full
	default "hs4x_rel31"	 if BR2_archs4x_rel31

config BR2_READELF_ARCH_NAME
	default "ARCompact"	if BR2_arc750d || BR2_arc770d
	default "ARCv2"		if BR2_archs38 || BR2_archs38_64mpy || BR2_archs38_full || BR2_archs4x_rel31

choice
	prompt "MMU Page Size"
	default BR2_ARC_PAGE_SIZE_8K
	help
	  MMU starting from version 3 (found in ARC 770) and now
	  version 4 (found in ARC HS38) allows the selection of the
	  page size during ASIC design creation.

	  The following options are available for MMU v3 and v4: 4kB,
	  8kB and 16 kB.

	  The default is 8 kB (that really matches the only page size
	  in MMU v2).  It is important to build a toolchain with page
	  size matching the hardware configuration. Otherwise
	  user-space applications will fail at runtime.

config BR2_ARC_PAGE_SIZE_4K
	bool "4KB"
	depends on BR2_arc770d || BR2_archs38 || BR2_archs38_64mpy || BR2_archs38_full || BR2_archs4x_rel31

config BR2_ARC_PAGE_SIZE_8K
	bool "8KB"
	help
	  This is the one and only option available for MMUv2 and
	  default value for MMU v3 and v4.

config BR2_ARC_PAGE_SIZE_16K
	bool "16KB"
	depends on BR2_arc770d || BR2_archs38 || BR2_archs38_64mpy || BR2_archs38_full || BR2_archs4x_rel31

endchoice

config BR2_ARC_PAGE_SIZE
	string
	default "4K" if BR2_ARC_PAGE_SIZE_4K
	default "8K" if BR2_ARC_PAGE_SIZE_8K
	default "16K" if BR2_ARC_PAGE_SIZE_16K

# vim: ft=kconfig
# -*- mode:kconfig; -*-

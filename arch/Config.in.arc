# Choise of atomic instructions presence
config BR2_ARC_ATOMIC_EXT
	bool "Atomic extension (LLOCK/SCOND instructions)"
	select BR2_ARCH_HAS_ATOMICS

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
	default "arc700"

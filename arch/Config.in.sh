choice
	prompt "Target Architecture Variant"
	depends on BR2_sh
	default BR2_sh4
	help
	  Specific CPU variant to use

config BR2_sh2a
	bool "sh2a (SH2A big endian)"
config BR2_sh4
	bool "sh4 (SH4 little endian)"
config BR2_sh4eb
	bool "sh4eb (SH4 big endian)"
config BR2_sh4a
	bool "sh4a (SH4A little endian)"
config BR2_sh4aeb
	bool "sh4aeb (SH4A big endian)"
endchoice

config BR2_ARCH
	default "sh2a"		if BR2_sh2a
	default "sh4"		if BR2_sh4
	default "sh4eb"		if BR2_sh4eb
	default "sh4a"		if BR2_sh4a
	default "sh4aeb"	if BR2_sh4aeb

config BR2_ENDIAN
	default "LITTLE"	if BR2_sh4 || BR2_sh4a
	default "BIG"		if BR2_sh2a || BR2_sh4eb || BR2_sh4aeb

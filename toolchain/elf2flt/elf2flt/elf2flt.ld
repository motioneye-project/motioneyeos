
ENTRY (_start)

MEMORY {
	flatmem : ORIGIN = 0x0, LENGTH = 0xfffffff
}

SECTIONS {

	.text 0x0 : {
		. = . + 4;
		. = ALIGN(0x4) ;
		_stext = . ;
		*(.text)
		*(.text.*)
		*(.gnu.warning)
		*(.stub)
		*(.gnu.linkonce.t*)
		*(.glue_7t)
		*(.glue_7)
		*(.jcr)
		*(.init)
		*(.fini)

W_RODAT		*(.rodata)
W_RODAT		*(.rodata1)
W_RODAT		*(.rodata.*)
W_RODAT		*(.gnu.linkonce.r*)

		/* This is special code area at the end of the normal
		   text section.  It contains a small lookup table at
		   the start followed by the code pointed to by entries
		   in the lookup table.  */
		. = ALIGN (4) ;
		PROVIDE(__ctbp = .);
		*(.call_table_data)
		*(.call_table_text)

		. = ALIGN(0x20) ;
		_etext = . ;
	} > flatmem

	.data : {
		. = ALIGN(0x4) ;
		_sdata = . ;
		__data_start = . ;
		data_start = . ;
		*(.got.plt)
		*(.got)
		FILL(0) ;
		. = ALIGN(0x20) ; 
		LONG(-1)
		. = ALIGN(0x20) ; 
R_RODAT		*(.rodata)
R_RODAT		*(.rodata1)
R_RODAT		*(.rodata.*)
R_RODAT		*(.gnu.linkonce.r*)
		*(.data)
		*(.data1)
		*(.data.*)
		*(.gnu.linkonce.d*)
		*(.data1)
		*(.eh_frame)
		*(.gcc_except_table)

		/* Microblaze has .sdata and .sbss (small bss).  They must
		   be contiguous, so please don't move any of this. JW */
		_ssrw = . ;			
		*(.sdata) 
		*(.sdata.*)
		*(.sbss)			/* Don't move this! */
		_essrw = . ;

		_ssrw_size = _essrw - _ssrw;
		PROVIDE(_SDA_BASE_ = _ssrw + (_ssrw_size / 2));

		*(.gnu.linkonce.s.*)
		*(__libc_atexit)
		*(__libc_subinit)
		*(__libc_subfreeres)
		*(.note.ABI-tag)

		/* microblaze-specific read-only small data area
		   and associated locating symbols */
		_ssro = . ;
		*(.sdata2)
		_essro = . ;
		_ssro_size = _essro - _ssro;
		PROVIDE(_SDA2_BASE_ = _ssro + (_ssro_size / 2));

		. = ALIGN(4) ;
		__CTOR_LIST__ = .;
		LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
SINGLE_LINK:	/* gcc uses crtbegin.o to find the start of
SINGLE_LINK:	   the constructors, so we make sure it is
SINGLE_LINK:	   first.  Because this is a wildcard, it
SINGLE_LINK:	   doesn't matter if the user does not
SINGLE_LINK:	   actually link against crtbegin.o; the
SINGLE_LINK:	   linker won't look for a file to match a
SINGLE_LINK:	   wildcard.  The wildcard also means that it
SINGLE_LINK:	   doesn't matter which directory crtbegin.o
SINGLE_LINK:	   is in.  */
SINGLE_LINK:	KEEP (*crtbegin*.o(.ctors))
SINGLE_LINK:	/* We don't want to include the .ctor section from
SINGLE_LINK:	   from the crtend.o file until after the sorted ctors.
SINGLE_LINK:	   The .ctor section from the crtend file contains the
SINGLE_LINK:	   end of ctors marker and it must be last */
SINGLE_LINK:	KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))
SINGLE_LINK:	KEEP (*(SORT(.ctors.*)))
		KEEP (*(.ctors))
		LONG(0)
		__CTOR_END__ = .;
		__DTOR_LIST__ = .;
		LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
SINGLE_LINK:	KEEP (*crtbegin*.o(.dtors))
SINGLE_LINK:	KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))
SINGLE_LINK:	KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
		LONG(0)
		__DTOR_END__ = .;

		PROVIDE (__preinit_array_start = .);
		KEEP (*(.preinit_array))
		PROVIDE (__preinit_array_end = .);

		PROVIDE (__init_array_start = .);
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array))
		PROVIDE (__init_array_end = .);

		PROVIDE (__fini_array_start = .);
		KEEP (*(.fini_array))
		KEEP (*(SORT(.fini_array.*)))
		PROVIDE (__fini_array_end = .);

		. = ALIGN(0x10) ; 
		_edata = . ;
	} > flatmem

	.bss : {
		. = ALIGN(0x4) ;
		_sbss = ALIGN(0x4) ;
		__bss_start = . ;
		*(.dynsbss)
		*(.sbss)
		*(.sbss.*)
		*(.scommon)
		*(.dynbss)
		*(.bss)
		*(.bss.*)
		*(.bss*)
		*(.gnu.linkonce.b*)
		*(COMMON)
		. = ALIGN(0x10) ;
		_ebss = . ;
		_end = . ;
		end = . ;
	} > flatmem

	.stack : {
		. = ALIGN(0x4);
		__stack_start = .;
	}

	.junk 0 : { *(.rel*) *(.rela*) }
	/* Stabs debugging sections.    */
	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
	.stab.excl 0 : { *(.stab.excl) }
	.stab.exclstr 0 : { *(.stab.exclstr) }
	.stab.index 0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment 0 : { *(.comment) }
	.debug_abbrev 0 : { *(.debug_abbrev) }
	.debug_info 0 : { *(.debug_info) }
	.debug_line 0 : { *(.debug_line) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	.debug_aranges 0 : { *(.debug_aranges) }
}

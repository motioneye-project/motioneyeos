/*
 * Ulf Samuelsson<ulf@atmel.com>
 * Configuation settings for the AT91RM9200DF board.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#define	CONFIG_HOSTNAME			at91rm9200df
/* ARM asynchronous clock */
#define AT91C_MAIN_CLOCK		179712000	/* from 18.432 MHz crystal (18432000 / 4 * 39) */
#define AT91C_MASTER_CLOCK		59904000	/* peripheral clock (AT91C_MASTER_CLOCK / 3) */
/* #define AT91C_MASTER_CLOCK		44928000 */	/* peripheral clock (AT91C_MASTER_CLOCK / 4) */

#define AT91_SLOW_CLOCK			32768	/* slow clock */

#define CFG_HZ				1000


#define CONFIG_AT91			1

#define CONFIG_ARM920T			1	/* This is an ARM920T Core	*/
#define CONFIG_AT91RM9200		1	/* It's an Atmel AT91RM9200 SoC	*/
#define CONFIG_AT91RM9200DF		1	/* on an AT91RM9200DK Board	*/
#define CONFIG_MACHID_IN_ENV		1	/* allow dynamic Machine Id */
#define USE_920T_MMU			1

#define CONFIG_CMDLINE_TAG		1	/* enable passing of ATAGs	*/
#define CONFIG_SETUP_MEMORY_TAGS	1
#define CONFIG_INITRD_TAG		1

#define CONFIG_USE_IRQ			1

/* define this to include the functionality of boot.bin in u-boot */
#define CONFIG_SKIP_LOWLEVEL_INIT
#define CONFIG_SKIP_RELOCATE_UBOOT	/* Is this really wise on the AT91RM9200DF */
#define BOARD_LATE_INIT			1	/* Don't know what this means for now */

/*
 * Size of malloc() pool
 */
#define CFG_MALLOC_LEN			(CFG_ENV_SIZE + 128*1024)
#define CFG_GBL_DATA_SIZE		128	/* size in bytes reserved for initial data */


/*
 * Hardware drivers
 */

#define CONFIG_BOOTDELAY		3

#undef CONFIG_ENV_OVERWRITE

#define CONFIG_COMMANDS					\
			((CONFIG_CMD_DFL		| \
			  CFG_CMD_NET			| \
			  CFG_CMD_PING			| \
			  CFG_CMD_ENV			| \
			  CFG_CMD_USB			| \
			  CFG_CMD_FLASH			| \
			  CFG_CMD_MII			| \
			  CFG_CMD_MUX			| \
			  CFG_CMD_MMC			| \
			  CFG_CMD_AUTOSCRIPT		| \
			  CFG_CMD_DHCP			| \
			  CFG_CMD_FAT )			& \
			~(CFG_CMD_BDI			| \
			  CFG_CMD_IMLS			| \
			  CFG_CMD_IMI			| \
			  CFG_CMD_FPGA			| \
			  CFG_CMD_MISC			| \
			  CFG_CMD_LOADS))
/* this must be included AFTER the definition of CONFIG_COMMANDS (if any) */
#include <cmd_confdefs.h>

/* UART Configuration */
#define CONFIG_BAUDRATE			115200
#define CFG_BAUDRATE_TABLE		{115200 , 19200, 38400, 57600, 9600 }
#define CFG_AT91C_BRGR_DIVISOR		33	/* hardcode so no __divsi3 : AT91C_MASTER_CLOCK / baudrate / 16 */
#undef CONFIG_HWFLOW			/* don't include RTS/CTS flow control support	*/
#undef CONFIG_MODEM_SUPPORT		/* disable modem initialization stuff */

/* Console Configuration */
#define CFG_CONSOLE_IS_SERIAL
#undef  CFG_CONSOLE_IS_LCD
#define CONFIG_AUTO_COMPLETE
#define CFG_LONGHELP

/* define one of these to choose the DBGU, USART0  or USART1 as console */
#define CONFIG_DBGU			1
#undef CONFIG_USART0
#undef CONFIG_USART1
#undef CONFIG_USART2

#define CFG_PROMPT			"U-Boot> "	/* Monitor Command Prompt */
#define CFG_CBSIZE			256		/* Console I/O Buffer Size */
#define CFG_MAXARGS			16		/* max number of command args */
#define CFG_PBSIZE			(CFG_CBSIZE+sizeof(CFG_PROMPT)+16) /* Print Buffer Size */

/* Ethernet Configuration */
#define CONFIG_DRIVER_ETHER		1
#define CONFIG_NET_RETRY_COUNT		5000
#define CONFIG_TFTP_TIMEOUT		2500	/*250*/
#define CONFIG_ETHINIT			1
#define CONFIG_OVERWRITE_ETHADDR_ONCE

#define CONFIG_AT91C_USE_RMII		1
#define AT91C_PHY_ADDR			0
#define AT91C_ETH_TIMEOUT		30000

/* USB Configuration */
#define CONFIG_USB_OHCI			1
#define CONFIG_USB_STORAGE		1
#define CONFIG_DOS_PARTITION		1
#define LITTLEENDIAN			1

/* MMC/SD Card Configuration */
#define CONFIG_DOS_PARTITION		1
#define CONFIG_MMC			1
#define CONFIG_SUPPORT_VFAT		1
#define CFG_MMC_BASE			0xFFFB4000	/* From AT91RM9200.h*/
#define CFG_MMC_BLOCKSIZE		512

/* Memory Configuration */
#define CFG_ENV_OVERWRITE		1
#define CONFIG_HAS_DATAFLASH		1
#undef  CFG_NO_PARALLEL_FLASH
#undef  CFG_NO_FLASH

#undef  CFG_ENV_IS_IN_FLASH
#define CFG_ENV_IS_IN_DATAFLASH		1
#undef  CFG_ENV_IS_IN_NAND

#define	UBOOT_NPCS0
#undef  UBOOT_NPCS1
#undef  UBOOT_NPCS3

#define	SPI_MODE			3

/* SDRAMC */
#define CONFIG_NR_DRAM_BANKS		1
#define PHYS_SDRAM			0x20000000
#define PHYS_SDRAM_SIZE			0x2000000  /* 32 megs */

#define CFG_MEMTEST_START		PHYS_SDRAM
#define CFG_MEMTEST_END			CFG_MEMTEST_START + PHYS_SDRAM_SIZE - 262144

/* DataFlash */
#define CFG_SPI_WRITE_TOUT		(5*CFG_HZ)

/* AC Characteristics */
/* DLYBS = tCSS = 250ns min and DLYBCT = tCSH = 250ns */
#define DATAFLASH_TCSS			(0xC << 16)
#define DATAFLASH_TCHS			(0x1 << 24)

#define CFG_MAX_DATAFLASH_BANKS		2
#define CFG_MAX_DATAFLASH_PAGES		16384
#define CFG_DATAFLASH_LOGIC_ADDR_CS0	0xC0000000	/* Logical adress for CS0 */
#undef  CFG_DATAFLASH_LOGIC_ADDR_CS1	/* 0xC0000000 */	/* Logical adress for CS1 */
#define CFG_DATAFLASH_LOGIC_ADDR_CS3	0xD0000000	/* Logical adress for CS3 */

#define CFG_SUPPORT_BLOCK_ERASE		1
#define CONFIG_NEW_PARTITION		1

#define DATAFLASH_MMC_SELECT		AT91C_PIO_PB22

/* Parallel Flash Configuration */
#define PHYS_FLASH_1			0x10000000
#define PHYS_FLASH_SIZE			0x800000  	/* 8 megs main flash */
#define CFG_FLASH_BASE			PHYS_FLASH_1
#define CFG_MAX_FLASH_BANKS		1
#define CFG_MAX_FLASH_SECT		256
#define CFG_FLASH_ERASE_TOUT		(2*CFG_HZ) /* Timeout for Flash Erase */
#define CFG_FLASH_WRITE_TOUT		(2*CFG_HZ) /* Timeout for Flash Write */

/* NAND Flash Configuration */
#define NAND_MAX_CHIPS			1	/* Max number of NAND devices	*/
#define CFG_MAX_NAND_DEVICE		1	/* Max number of NAND devices	*/
#define SECTORSIZE			512
#define CFG_NAND_BASE			0x40000000
#define CONFIG_NEW_NAND_CODE

#define ADDR_COLUMN			1
#define ADDR_PAGE			2
#define ADDR_COLUMN_PAGE		3

#define NAND_ChipID_UNKNOWN		0x00
#define NAND_MAX_FLOORS			1
#undef  CFG_NAND_WP

/* Old NAND commands */
#define AT91_SMART_MEDIA_ALE		(1 << 22)	/* our ALE is AD22 */
#define AT91_SMART_MEDIA_CLE		(1 << 21)	/* our CLE is AD21 */

#define NAND_DISABLE_CE(nand)		do { *AT91C_PIOC_SODR = AT91C_PIO_PC0;} while(0)
#define NAND_ENABLE_CE(nand)		do { *AT91C_PIOC_CODR = AT91C_PIO_PC0;} while(0)

#define NAND_WAIT_READY(nand)		while (!(*AT91C_PIOC_PDSR & AT91C_PIO_PC2))

#define WRITE_NAND_COMMAND(d, adr)	do{ *(volatile __u8 *)((unsigned long)adr | AT91_SMART_MEDIA_CLE) = (__u8)(d); } while(0)
#define WRITE_NAND_ADDRESS(d, adr)	do{ *(volatile __u8 *)((unsigned long)adr | AT91_SMART_MEDIA_ALE) = (__u8)(d); } while(0)
#define WRITE_NAND(d, adr)			do{ *(volatile __u8 *)((unsigned long)adr) = (__u8)d; } while(0)
#define READ_NAND(adr)				((volatile unsigned char)(*(volatile __u8 *)(unsigned long)adr))
/* the following are NOP's in our implementation */
#define NAND_CTL_CLRALE(nandptr)
#define NAND_CTL_SETALE(nandptr)
#define NAND_CTL_CLRCLE(nandptr)
#define NAND_CTL_SETCLE(nandptr)

/* New NAND commands */
#define AT91C_SM_NWE_SETUP		(0 << 0)
#define AT91C_SM_NCS_WR_SETUP		(0 << 8)
#define AT91C_SM_NRD_SETUP		(0 << 16)
#define AT91C_SM_NCS_RD_SETUP		(0 << 24)
  
#define AT91C_SM_NWE_PULSE		(4 << 0)
#define AT91C_SM_NCS_WR_PULSE		(6 << 8)
#define AT91C_SM_NRD_PULSE		(3 << 16)
#define AT91C_SM_NCS_RD_PULSE		(5 << 24)
  
#define AT91C_SM_NWE_CYCLE		(6 << 0)
#define AT91C_SM_NRD_CYCLE		(5 << 16)

#define AT91C_SM_TDF			(1 << 16)		

/*#define CONFIG_MTD_DEBUG		1
#define CONFIG_MTD_DEBUG_VERBOSE	MTD_DEBUG_LEVEL3
*/

/* Environment */
#ifdef CFG_ENV_IS_IN_NAND
#define CFG_ENV_OFFSET			0x60000		/* environment starts here  */
#define CFG_ENV_SIZE			0x20000 	/* 1 sector = 128kB */
#endif

#ifdef CFG_ENV_IS_IN_DATAFLASH
#	if	defined(UBOOT_NPCS0)
#		define UBOOT_NPCS	CFG_DATAFLASH_LOGIC_ADDR_CS0
#	elif	defined(UBOOT_NPCS1)
#		define UBOOT_NPCS	CFG_DATAFLASH_LOGIC_ADDR_CS1
#	elif	defined(UBOOT_NPCS3)
#		define UBOOT_NPCS	CFG_DATAFLASH_LOGIC_ADDR_CS3
#	endif

#	define CFG_ENV_OFFSET		0x4200
#	define CFG_ENV_ADDR		(UBOOT_NPCS + CFG_ENV_OFFSET)
#	define CFG_ENV_SIZE		0x2000  /* 0x8000 */
#endif


#ifdef CFG_ENV_IS_IN_FLASH
#	ifdef CONFIG_SKIP_LOWLEVEL_INIT
#		define CFG_ENV_ADDR	(PHYS_FLASH_1 + 0x60000)  /* after u-boot.bin */
#		define CFG_ENV_SIZE	0x10000 /* sectors are 64K here */
#	else
#		define CFG_ENV_ADDR	(PHYS_FLASH_1 + 0xe000)  /* between boot.bin and u-boot.bin.gz */
#		define CFG_ENV_SIZE	0x2000  /* 0x8000 */
#	endif	/* CONFIG_SKIP_LOWLEVEL_INIT */
#endif	/* CFG_ENV_IS_IN_DATAFLASH */


#if	CFG_ENV_IS_IN_DATAFLASH | CFG_ENV_IS_IN_FLASH | CFG_ENV_IS_IN_NAND
#else
#error	"No Environment Defined"
#endif

#define KERNEL_1_5_MB
#define CFG_LOAD_ADDR			0x21000000  /* default load address */

#ifdef CONFIG_SKIP_LOWLEVEL_INIT
#define CFG_BOOT_SIZE			0x00 /* 0 KBytes */
#define CFG_U_BOOT_BASE			PHYS_FLASH_1
#define CFG_U_BOOT_SIZE			0x60000 /* 384 KBytes */

#else
#define CFG_BOOT_SIZE			0x6000 /* 24 KBytes */
#define CFG_U_BOOT_BASE			(PHYS_FLASH_1 + 0x10000)
#define CFG_U_BOOT_SIZE			0x10000 /* 64 KBytes */

#define CFG_USE_MAIN_OSCILLATOR		1
/* flash */
#define MC_PUIA_VAL			0x00000000
#define MC_PUP_VAL			0x00000000
#define MC_PUER_VAL			0x00000000
#define MC_ASR_VAL			0x00000000
#define MC_AASR_VAL			0x00000000
#define EBI_CFGR_VAL			0x00000000
#define SMC2_CSR_VAL			0x00003284 /* 16bit, 2 TDF, 4 WS */

/* clocks */
#define PLLAR_VAL			0x20263E04 /* 179.712000 MHz for PCK */
#define PLLBR_VAL			0x10483E0E /* 48.054857 MHz (divider by 2 for USB) */
#define MCKR_VAL			0x00000202 /* PCK/3 = MCK Master Clock = 59.904000MHz from PLLA */

/* sdram */
#define PIOC_ASR_VAL			0xFFFF0000 /* Configure PIOC as peripheral (D16/D31) */
#define PIOC_BSR_VAL			0x00000000
#define PIOC_PDR_VAL			0xFFFF0000
#define EBI_CSA_VAL			0x00000002 /* CS1=SDRAM */
#define SDRC_CR_VAL			0x2188c155 /* set up the SDRAM */
#define SDRAM				0x20000000 /* address of the SDRAM */
#define SDRAM1				0x20000080 /* address of the SDRAM */
#define SDRAM_VAL			0x00000000 /* value written to SDRAM */
#define SDRC_MR_VAL			0x00000002 /* Precharge All */
#define SDRC_MR_VAL1			0x00000004 /* refresh */
#define SDRC_MR_VAL2			0x00000003 /* Load Mode Register */
#define SDRC_MR_VAL3			0x00000000 /* Normal Mode */
#define SDRC_TR_VAL			0x000002E0 /* Write refresh rate */

#endif	/* CONFIG_SKIP_LOWLEVEL_INIT */

#ifndef __ASSEMBLY__
/*-----------------------------------------------------------------------
 * Board specific extension for bd_info
 *
 * This structure is embedded in the global bd_info (bd_t) structure
 * and can be used by the board specific code (eg board/...)
 */

struct bd_info_ext {
	/* helper variable for board environment handling
	 *
	 * env_crc_valid == 0    =>   uninitialised
	 * env_crc_valid  > 0    =>   environment crc in flash is valid
	 * env_crc_valid  < 0    =>   environment crc in flash is invalid
	 */
	int env_crc_valid;
};
#endif

#define CFG_HZ_CLOCK			AT91C_MASTER_CLOCK/2	/* AT91C_TC0_CMR is implicitly set to */
					/* AT91C_TC_TIMER_DIV1_CLOCK */

#define CONFIG_STACKSIZE		(32*1024)	/* regular stack */
#define CONFIG_STACKSIZE_IRQ  		(4*1024)        /* IRQ stack */
#define CONFIG_STACKSIZE_FIQ  		(4*1024) 
/*
#ifdef CONFIG_USE_IRQ
#error CONFIG_USE_IRQ not supported
#endif
*/
#endif

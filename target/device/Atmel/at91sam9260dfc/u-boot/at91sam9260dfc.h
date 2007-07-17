/*
 * (C) Copyright 2006
 * M. Amine SAYA ATMEL Rousset, France.
 *
 * Rick Bronson <rick@efn.org>
 *
 * Configuration settings for the AT91SAM9260EK board.
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

#define	CONFIG_HOSTNAME			at91sam9260dfc
/*
 * If we are developing, we might want to start armboot from ram
 * so we MUST NOT initialize critical regs like mem-timing ...
 */

/* ARM asynchronous clock */
/* #define AT91C_MAIN_CLOCK		179712000 */	/* from 18.432 MHz crystal (18432000 / 4 * 39) */
#define AT91C_MASTER_CLOCK		99300000 	/* peripheral clock (AT91C_MASTER_CLOCK / 3) */
/* #define AT91C_MASTER_CLOCK		45174500 */
/* #define AT91C_MASTER_CLOCK		44928000 */	/* peripheral clock (AT91C_MASTER_CLOCK / 4) */

#define AT91_SLOW_CLOCK			32768	/* slow clock */

#define CFG_HZ				1000


#define CONFIG_AT91			1

#define CONFIG_ARM926EJS		1
#define CONFIG_AT91SAM9260		1
#define CONFIG_AT91SAM9260EK		1	/* on an AT91SAM9260EK Board	 */

#define CONFIG_CMDLINE_TAG		1	/* enable passing of ATAGs	*/
#define CONFIG_SETUP_MEMORY_TAGS	1
#define CONFIG_INITRD_TAG		1

#undef  CONFIG_USE_IRQ				/* we don't need IRQ/FIQ stuff */

/* define this to include the functionality of boot.bin in u-boot */
#undef	CONFIG_SKIP_LOWLEVEL_INIT
#define CONFIG_SKIP_RELOCATE_UBOOT
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
			  CFG_CMD_AUTOSCRIPT		| \
			  CFG_CMD_DHCP			| \
			  CFG_CMD_NAND			| \
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

/* LED Configuration */
#define	PIO_ID				AT91C_ID_PIOA
#define	PIO_LEDS			AT91C_BASE_PIOA
#define	GREEN_LED			AT91C_PIO_PA6
#define	GREEN_LED_ON			PIO_CODR
#define	GREEN_LED_OFF			PIO_SODR
#define	YELLOW_LED			AT91C_PIO_PA9
#define	YELLOW_LED_ON			PIO_SODR
#define	YELLOW_LED_OFF			PIO_CODR
#define	RED_LED				0
#define	RED_LED_ON			PIO_CODR
#define	RED_LED_OFF			PIO_SODR
#define	ALL_LEDS			(GREEN_LED | YELLOW_LED | RED_LED)
#define	TIME_SLICE			500000

/* Memory Configuration */
#define CFG_ENV_OVERWRITE		1
#define CONFIG_HAS_DATAFLASH		1
#define CFG_NO_PARALLEL_FLASH		1
#define CFG_NO_FLASH			1

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
#define PHYS_SDRAM_SIZE			0x4000000  /* 64 megs */

#define CFG_MEMTEST_START		PHYS_SDRAM
#define CFG_MEMTEST_END			CFG_MEMTEST_START + PHYS_SDRAM_SIZE - 262144

/* DataFlash */
#define CFG_SPI_WRITE_TOUT		(50*CFG_HZ)

/* AC Characteristics */
/* DLYBS = tCSS = 250ns min and DLYBCT = tCSH = 250ns */
#define DATAFLASH_TCSS			(0x1a << 16)
#define DATAFLASH_TCHS			(0x1 << 24)

#define CFG_MAX_DATAFLASH_BANKS		2
#define CFG_MAX_DATAFLASH_PAGES		16384
#define CFG_DATAFLASH_LOGIC_ADDR_CS0	0xC0000000	/* Logical adress for CS0 */
#define CFG_DATAFLASH_LOGIC_ADDR_CS1	0xD0000000	/* Logical adress for CS1 */
#undef  CFG_DATAFLASH_LOGIC_ADDR_CS3	/* 0xD0000000	*/ /* Logical adress for CS1 */

#define CFG_SUPPORT_BLOCK_ERASE		1
#define CONFIG_NEW_PARTITION		1
#define	NB_DATAFLASH_AREA		6

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

/*#define AT91_SMART_MEDIA_ALE		(1 << 21)*/	/* our ALE is AD21 */
/*#define AT91_SMART_MEDIA_CLE		(1 << 22)*/	/* our CLE is AD22 */

/* SMC Chip Select 3 Timings for NandFlash K9F1216U0A (samsung)
 * for MASTER_CLOCK = 48000000. They were generated according to 
 * K9F1216U0A timings and for MASTER_CLOCK = 48000000.
 * Please refer to SMC section in AT91SAM9261 datasheet to learn how 
 * to generate these values.
 */
 
/*
#define AT91C_SM_NWE_SETUP		(0 << 0)		
#define AT91C_SM_NCS_WR_SETUP		(0 << 8)		
#define AT91C_SM_NRD_SETUP		(0 << 16)		
#define AT91C_SM_NCS_RD_SETUP		(0 << 24)		
  
#define AT91C_SM_NWE_PULSE 		(2 << 0)		
#define AT91C_SM_NCS_WR_PULSE		(3 << 8)		
#define AT91C_SM_NRD_PULSE		(2 << 16)		
#define AT91C_SM_NCS_RD_PULSE		(4 << 24)		
  
#define AT91C_SM_NWE_CYCLE 		(3 << 0)		
#define AT91C_SM_NRD_CYCLE		(5 << 16)		
  
#define AT91C_SM_TDF	        	(1 << 16)		
*/

/* SMC Chip Select 3 Timings for NandFlash K9F1216U0A (samsung)
 * for MASTER_CLOCK = 100000000. They were generated according to 
 * K9F1216U0A timings and for MASTER_CLOCK = 100000000.
 * Please refer to SMC section in AT91SAM9261 datasheet to learn how 
 * to generate these values.
 */

/* These timings are specific to K9F1216U0A (samsung) */
/*
#define AT91C_SM_NWE_SETUP		(0 << 0)		
#define AT91C_SM_NCS_WR_SETUP		(0 << 8)		
#define AT91C_SM_NRD_SETUP		(0 << 16)		
#define AT91C_SM_NCS_RD_SETUP		(0 << 24)		
  
#define AT91C_SM_NWE_PULSE 		(3 << 0)		
#define AT91C_SM_NCS_WR_PULSE		(3 << 8)		
#define AT91C_SM_NRD_PULSE		(4 << 16)		
#define AT91C_SM_NCS_RD_PULSE		(4 << 24)		
  
#define AT91C_SM_NWE_CYCLE 		(5 << 0)		
#define AT91C_SM_NRD_CYCLE		(5 << 16)		
*/

/* These timings are specific to MT29F2G16AAB 256Mb (Micron) 
 * at MCK = 100 MHZ
 */

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
#	ifdef CONFIG_BOOTBINFUNC
#		define CFG_ENV_ADDR	(PHYS_FLASH_1 + 0x60000)  /* after u-boot.bin */
#		define CFG_ENV_SIZE	0x10000 /* sectors are 64K here */
#	else
#		define CFG_ENV_ADDR	(PHYS_FLASH_1 + 0xe000)  /* between boot.bin and u-boot.bin.gz */
#		define CFG_ENV_SIZE	0x2000  /* 0x8000 */
#	endif
#endif

#if	CFG_ENV_IS_IN_DATAFLASH | CFG_ENV_IS_IN_FLASH | CFG_ENV_IS_IN_NAND
#else
#error	"No Environment Defined"
#endif

#define KERNEL_1_5_MB
#define CFG_LOAD_ADDR			0x23f00000  /* default load address */

#ifdef CONFIG_BOOTBINFUNC
#	define CFG_BOOT_SIZE		0x00 /* 0 KBytes */
#	define CFG_U_BOOT_BASE		PHYS_FLASH_1
#	define CFG_U_BOOT_SIZE		0x60000 /* 384 KBytes */
#else
#	define CFG_BOOT_SIZE		0x6000 /* 24 KBytes */
#	define CFG_U_BOOT_BASE		(PHYS_FLASH_1 + 0x10000)
#	define CFG_U_BOOT_SIZE		0x10000 /* 64 KBytes */
#endif

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


#define CONFIG_STACKSIZE		(32*1024)	/* regular stack */

#ifdef CONFIG_USE_IRQ
#error CONFIG_USE_IRQ not supported
#endif

#endif

/* vi: set sw=4 ts=4: */
// This file defines the feature set to be compiled into busybox.
// When you turn things off here, they won't be compiled in at all.
//
//// This file is parsed by sed.  You MUST use single line comments.
//   i.e.,  //#define BB_BLAH
//
//
// BusyBox Applications
//#define BB_ADJTIMEX
#define BB_AR
#define BB_ASH
#define BB_BASENAME
#define BB_CAT
#define BB_CHGRP
#define BB_CHMOD
#define BB_CHOWN
#define BB_CHROOT
#define BB_CHVT
#define BB_CLEAR
#define BB_CMP
#define BB_CP
#define BB_CPIO
#define BB_CUT
#define BB_DATE
#define BB_DC
#define BB_DD
#define BB_DEALLOCVT
#define BB_DF
#define BB_DIRNAME
#define BB_DMESG
//#define BB_DOS2UNIX
//#define BB_DPKG
//#define BB_DPKG_DEB
//#define BB_DUTMP
#define BB_DU
//#define BB_DUMPKMAP
#define BB_ECHO
#define BB_ENV
#define BB_EXPR
#define BB_FBSET
//#define BB_FDFLUSH
#define BB_FIND
#define BB_FREE
#define BB_FREERAMDISK
//#define BB_FSCK_MINIX
//#define BB_GETOPT
#define BB_GREP
#define BB_GUNZIP
#define BB_GZIP
#define BB_HALT
#define BB_HEAD
#define BB_HOSTID
#define BB_HOSTNAME
//#define BB_HUSH
#define BB_ID
#define BB_IFCONFIG
#define BB_INIT
#define BB_INSMOD
#define BB_KILL
#define BB_KILLALL
#define BB_KLOGD
//#define BB_LASH
//#define BB_LENGTH
#define BB_LN
//#define BB_LOADACM
//#define BB_LOADFONT
//#define BB_LOADKMAP
#define BB_LOGGER
#define BB_LOGNAME
#define BB_LOSETUP
#define BB_LS
#define BB_LSMOD
//#define BB_MAKEDEVS
#define BB_MD5SUM
#define BB_MKDIR
//#define BB_MKFIFO
//#define BB_MKFS_MINIX
#define BB_MKNOD
#define BB_MKSWAP
#define BB_MKTEMP
#define BB_MODPROBE
#define BB_MORE
#define BB_MOUNT
//#define BB_MSH
//#define BB_MT
#define BB_MV
#define BB_NC
#define BB_NSLOOKUP
#define BB_PIDOF
#define BB_PING
#define BB_PIVOT_ROOT
#define BB_POWEROFF
#define BB_PRINTF
#define BB_PS
#define BB_PWD
#define BB_RDATE
#define BB_READLINK
#define BB_REBOOT
//#define BB_RENICE
#define BB_RESET
#define BB_RM
#define BB_RMDIR
#define BB_RMMOD
#define BB_ROUTE
//#define BB_RPM2CPIO
#define BB_SED
//#define BB_SETKEYCODES
#define BB_SLEEP
#define BB_SORT
#define BB_STRINGS
#define BB_STTY
#define BB_SWAPONOFF
#define BB_SYNC
#define BB_SYSLOGD
#define BB_TAIL
#define BB_TAR
#define BB_TEE
#define BB_TEST
#define BB_TELNET
#define BB_TFTP
#define BB_TIME
#define BB_TOP
#define BB_TOUCH
#define BB_TR
#define BB_TRACEROUTE
#define BB_TRUE_FALSE
#define BB_TTY
//#define BB_UNIX2DOS
#define BB_UUENCODE
#define BB_UUDECODE
#define BB_UMOUNT
#define BB_UNIQ
#define BB_UNAME
//#define BB_UPDATE
#define BB_UPTIME
#define BB_USLEEP
#define BB_VI
//#define BB_WATCHDOG
#define BB_WC
#define BB_WGET
#define BB_WHICH
#define BB_WHOAMI
#define BB_XARGS
#define BB_YES
// End of Applications List
//
//
//
// ---------------------------------------------------------
// This is where feature definitions go.  Generally speaking,
// turning this stuff off makes things a bit smaller (and less 
// pretty/useful).
//
//
// If you enabled one or more of the shells, you may select which one
// should be run when sh is invoked:
#define BB_FEATURE_SH_IS_ASH
//#define BB_FEATURE_SH_IS_HUSH
//#define BB_FEATURE_SH_IS_LASH
//#define BB_FEATURE_SH_IS_MSH
//
// BusyBox will, by default, malloc space for its buffers.  This costs code
// size for the call to xmalloc.  You can use the following feature to have
// them put on the stack.  For some very small machines with limited stack
// space, this can be deadly.  For most folks, this works just fine...
//#define BB_FEATURE_BUFFERS_GO_ON_STACK
// The third alternative for buffer allocation is to use BSS.  This works
// beautifully for computers with a real MMU (and OS support), but wastes
// runtime RAM for uCLinux.  This behavior was the only one available for
// BusyBox versions 0.48 and earlier.
//#define BB_FEATURE_BUFFERS_GO_IN_BSS
//
// Turn this on to use Erik's very cool devps, and devmtab kernel drivers,
// thereby eliminating the need for the /proc filesystem and thereby saving
// lots and lots memory for more important things.  NOTE:  If you enable this
// feature, you _must_ have patched the kernel to include the devps patch that
// is included in the busybox/kernel-patches directory.  You will also need to
// create some device special files in /dev on your embedded system:
//        mknod /dev/mtab c 10 22
//        mknod /dev/ps c 10 21
// I emailed Linus and this patch will not be going into the stock kernel.
//#define BB_FEATURE_USE_DEVPS_PATCH
//
// show verbose usage messages
#define BB_FEATURE_VERBOSE_USAGE
//
// Use termios to manipulate the screen ('more' is prettier with this on)
#define BB_FEATURE_USE_TERMIOS
//
// calculate terminal & column widths (for more, ls, and telnet)
#define BB_FEATURE_AUTOWIDTH
//
// show username/groupnames for ls
#define BB_FEATURE_LS_USERNAME
//
// show file timestamps in ls
#define BB_FEATURE_LS_TIMESTAMPS
//
// enable ls -p and -F
#define BB_FEATURE_LS_FILETYPES
//
// sort the file names
#define BB_FEATURE_LS_SORTFILES
//
// enable ls -R
#define BB_FEATURE_LS_RECURSIVE
//
// enable ls -L
#define BB_FEATURE_LS_FOLLOWLINKS
//
// Use color to identify different file types
#define BB_FEATURE_LS_COLOR
//
// Disable for a smaller (but less functional) ping
#define BB_FEATURE_FANCY_PING
//
// Make init use a simplified /etc/inittab file (recommended).
#define BB_FEATURE_USE_INITTAB
//
//Enable init being called as /linuxrc
#define BB_FEATURE_LINUXRC
//
//Have init enable core dumping for child processes (for debugging only) 
//#define BB_FEATURE_INIT_COREDUMPS
//
//Make sure nothing is printed to the console on boot
#define BB_FEATURE_EXTRA_QUIET
//
// enable syslogd -R remotehost
//#define BB_FEATURE_REMOTE_LOG
//
// enable syslogd -C
//#define BB_FEATURE_IPC_SYSLOG
//
//Disable for a simple tail implementation (2.34k vs 3k for the full one).
//Both provide 'tail -f', but this cuts out -c, -q, -s, and -v. 
#define BB_FEATURE_FANCY_TAIL
//
// Enable support for loop devices in mount
#define BB_FEATURE_MOUNT_LOOP
//
// Enable support for a real /etc/mtab file instead of /proc/mounts
//#define BB_FEATURE_MTAB_SUPPORT
//
// Enable support for mounting remote NFS volumes. 
// You may need to mount with "-o nolock" if you are
// not running a local portmapper daemon...
//
// If you are using uClibc, be sure that you've already compiled
// uClibc with INCLUDE_RPC=true (contained in the Config file)
//#define BB_FEATURE_NFSMOUNT
//
// Enable support forced filesystem unmounting 
// (i.e., in case of an unreachable NFS system).
#define BB_FEATURE_MOUNT_FORCE
//
// Enable support for creation of tar files.
#define BB_FEATURE_TAR_CREATE
//
// Enable support for "--exclude" and "-X" for excluding files
#define BB_FEATURE_TAR_EXCLUDE
//
// Enable support for tar -z option (currently only works for inflating)
#define BB_FEATURE_TAR_GZIP 
//
// Enable reverse sort
#define BB_FEATURE_SORT_REVERSE
//
// Enable uniqe sort
#define BB_FEATURE_SORT_UNIQUE
//
// Enable command line editing in the shell.  
// Only relevant if a shell is enabled. On by default.
#define BB_FEATURE_COMMAND_EDITING
//
// Enable tab completion in the shell.  This is now working quite nicely.
// This feature adds a bit over 4k. Only relevant if a shell is enabled.
#define BB_FEATURE_COMMAND_TAB_COMPLETION
//
// Attempts to match usernames in a ~-prefixed path
#define BB_FEATURE_COMMAND_USERNAME_COMPLETION
//
//Allow the shell to invoke all the compiled in BusyBox applets as if they
//were shell builtins.  Nice for staticly linking an emergency rescue shell,
//among other things. Off by default.
// Only relevant if a shell is enabled.
//#define BB_FEATURE_SH_STANDALONE_SHELL
//
//When this is enabled, busybox shell applets can be called using full path
//names.  This causes applets (i.e., most busybox commands) to override
//real commands on the filesystem.  For example, if you run run /bin/cat, it
//will use BusyBox cat even if /bin/cat exists on the filesystem and is _not_
//busybox.  Some systems want this, others do not.  Choose wisely.  :-) This
//only has meaning when BB_FEATURE_SH_STANDALONE_SHELL is enabled.
// Only relevant if a shell is enabled. Off by default.
//#define BB_FEATURE_SH_APPLETS_ALWAYS_WIN
//
// Uncomment this option for a fancy shell prompt that includes the
// current username and hostname.  On systems that don't have usernames
// or hostnames, this can look hideous.
// Only relevant if a shell is enabled.
#define BB_FEATURE_SH_FANCY_PROMPT
//
// Uncomment this option to disable job control.  Job control lets you 
// run jobs in the background (which completely useless for is all you 
// are doing is running scripts).  Disabing this is bad for interactive
// use, since when you hit ^C in an application, it will also kill the 
// shell.  This adds about 2.5k on an x86 system.
#define BB_FEATURE_ASH_JOB_CONTROL
//
//Turn on extra fbset options
//#define BB_FEATURE_FBSET_FANCY
//
//Turn on fbset readmode support
//#define BB_FEATURE_FBSET_READMODE
//
// Support insmod/lsmod/rmmod for post 2.1 kernels
#define BB_FEATURE_NEW_MODULE_INTERFACE
//
// Support insmod/lsmod/rmmod for pre 2.1 kernels
//#define BB_FEATURE_OLD_MODULE_INTERFACE
//
// Support module version checking
//#define BB_FEATURE_INSMOD_VERSION_CHECKING
//
// Support for uClinux memory usage optimization, which will load the image
// directly into the kernel memory.  This divides memory requrements by three.
// If you are not running uClinux (i.e., your CPU has an MMU) leave this
// disabled...
//#define BB_FEATURE_INSMOD_LOADINKMEM
//
// Support for Minix filesystem, version 2
//#define BB_FEATURE_MINIX2
//
// Enable ifconfig status reporting output -- this feature adds 7k.
#define BB_FEATURE_IFCONFIG_STATUS
//
// Enable ifconfig slip-specific options "keepalive" and "outfill"
//#define BB_FEATURE_IFCONFIG_SLIP
//
// Enable ifconfig options "mem_start", "io_addr", and "irq".
#define BB_FEATURE_IFCONFIG_MEMSTART_IOADDR_IRQ
//
// Enable ifconfig option "hw".  Currently works for only with "ether".
#define BB_FEATURE_IFCONFIG_HW
//
// Allows "broadcast +" to set broadcast automatically based on hostaddr
// and netmask, at a cost of about 100 bytes of code (i386).
//#define BB_FEATURE_IFCONFIG_BROADCAST_PLUS
//
// Enable busybox --install [-s]
// to create links (or symlinks) for all the commands that are 
// compiled into the binary.  (needs /proc filesystem)
//#define BB_FEATURE_INSTALLER
//
// Enable a nifty progress meter in wget (adds just under 2k)
#define BB_FEATURE_WGET_STATUSBAR
//
// Enable HTTP authentication in wget
#define BB_FEATURE_WGET_AUTHENTICATION
//
// Clean up all memory before exiting -- usually not needed
// as the OS can clean up...  Don't enable this unless you
// have a really good reason for cleaning things up manually.
//#define BB_FEATURE_CLEAN_UP
//
// Support for human readable output by ls, du, etc.(example 13k, 23M, 235G)
#define BB_FEATURE_HUMAN_READABLE
//
// Support for the find -type option.
#define BB_FEATURE_FIND_TYPE
//
// Support for the find -perm option.
#define BB_FEATURE_FIND_PERM
//
// Support for the find -mtime option.
#define BB_FEATURE_FIND_MTIME
//
//// Support for the find -newer option.
#define BB_FEATURE_FIND_NEWER
//
// Support for the -A -B and -C context flags in grep
#define BB_FEATURE_GREP_CONTEXT
//
// Support for the EGREP applet (alias to the grep applet)
//#define BB_FEATURE_GREP_EGREP_ALIAS
//
// Tell tftp what commands that should be supported.
#define BB_FEATURE_TFTP_PUT
#define BB_FEATURE_TFTP_GET
//
// features for vi
#define BB_FEATURE_VI_COLON		// ":" colon commands, no "ex" mode
#define BB_FEATURE_VI_YANKMARK		// Yank/Put commands and Mark cmds
#define BB_FEATURE_VI_SEARCH		// search and replace cmds
#define BB_FEATURE_VI_USE_SIGNALS	// catch signals
#define BB_FEATURE_VI_DOT_CMD		// remember previous cmd and "." cmd
#define BB_FEATURE_VI_READONLY		// vi -R and "view" mode
#define BB_FEATURE_VI_SETOPTS		// set-able options,  ai ic showmatch
#define BB_FEATURE_VI_SET		// :set
#define BB_FEATURE_VI_WIN_RESIZE	// handle window resize
//
// Enable a if you system have setuped locale
//#define BB_LOCALE_SUPPORT
//
// Support for TELNET to pass TERM type to remote host.  Adds 384 bytes.
#define BB_FEATURE_TELNET_TTYPE
//
// Support for devfs.
//#define BB_FEATURE_DEVFS
//
// End of Features List
//
//
//
//
//
//
//---------------------------------------------------
// Nothing beyond this point should ever be touched by 
// mere mortals so leave this stuff alone.
//
#include <features.h>
#if defined(__uClinux__)
	#undef BB_ASH			/* Not even a chance it will work */
	#undef BB_RPM2CPIO		/* Uses gz_open(), which uses fork() */
	#undef BB_DPKG_DEB		/* Uses gz_open(), which uses fork() */
	#undef BB_FEATURE_TAR_GZIP	/* Uses fork() */
	#undef BB_UPDATE		/* Uses daemon() */
#endif
#if defined BB_ASH || defined BB_HUSH || defined BB_LASH || defined BB_MSH
	#if defined BB_FEATURE_COMMAND_EDITING
		#define BB_CMDEDIT
	#else
		#undef BB_FEATURE_COMMAND_EDITING
		#undef BB_FEATURE_COMMAND_TAB_COMPLETION
		#undef BB_FEATURE_COMMAND_USERNAME_COMPLETION
		#undef BB_FEATURE_SH_FANCY_PROMPT
	#endif
#else
	#undef BB_FEATURE_SH_APPLETS_ALWAYS_WIN
	#undef BB_FEATURE_SH_STANDALONE_SHELL
	#undef BB_FEATURE_SH_FANCY_PROMPT
#endif
//
#if (defined BB_ASH || defined BB_HUSH || defined BB_MSH) && ! defined BB_TEST
	#define BB_TEST
#endif
//
#ifdef BB_KILLALL
	#ifndef BB_KILL
		#define BB_KILL
	#endif
#endif
//
#ifndef BB_INIT
	#undef BB_FEATURE_LINUXRC
#endif
//
#if defined BB_MOUNT && defined BB_FEATURE_NFSMOUNT
	#define BB_NFSMOUNT
#endif
//
#if defined BB_FEATURE_AUTOWIDTH
	#ifndef BB_FEATURE_USE_TERMIOS
		#define BB_FEATURE_USE_TERMIOS
	#endif
#endif
//
#if defined BB_INSMOD || defined BB_LSMOD
	#if ! defined BB_FEATURE_NEW_MODULE_INTERFACE && ! defined BB_FEATURE_OLD_MODULE_INTERFACE
		#define BB_FEATURE_NEW_MODULE_INTERFACE
	#endif
#endif
//
#ifdef BB_UNIX2DOS
	#define BB_DOS2UNIX
#endif	
//
#ifdef BB_SYSLOGD
	#if defined BB_FEATURE_IPC_SYSLOG
		#define BB_LOGREAD
	#endif
#endif
//
#if defined BB_ASH && defined BB_FEATURE_SH_IS_ASH
# define shell_main ash_main
#elif defined BB_HUSH && defined BB_FEATURE_SH_IS_HUSH
# define shell_main hush_main
#elif defined BB_LASH && defined BB_FEATURE_SH_IS_LASH
# define shell_main lash_main
#elif defined BB_MSH && defined BB_FEATURE_SH_IS_MSH
# define shell_main msh_main
#endif

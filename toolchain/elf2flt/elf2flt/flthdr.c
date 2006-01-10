/****************************************************************************/
/*
 *	A simple program to manipulate flat files
 *
 *	Copyright (C) 2001-2003 SnapGear Inc, davidm@snapgear.com
 *	Copyright (C) 2001 Lineo, davidm@lineo.com
 *
 * This is Free Software, under the GNU Public Licence v2 or greater.
 *
 */
/****************************************************************************/

#include <stdio.h>    /* Userland pieces of the ANSI C standard I/O package  */
#include <unistd.h>   /* Userland prototypes of the Unix std system calls    */
#include <time.h>
#include <stdlib.h>   /* exit() */
#include <string.h>   /* strcat(), strcpy() */

/* macros for conversion between host and (internet) network byte order */
#ifndef WIN32
#include <netinet/in.h> /* Consts and structs defined by the internet system */
#else
#include <winsock2.h>
#endif

/* from uClinux-x.x.x/include/linux */
#include "flat.h"     /* Binary flat header description                      */

#if defined(__MINGW32__)
#include <getopt.h>

#define mkstemp(p) mktemp(p)

#endif

/****************************************************************************/

char *program_name;

static char cmd[1024];
static int print = 0, compress = 0, ramload = 0, stacksize = 0, ktrace = 0;
static int short_format = 0;

/****************************************************************************/

void
transferr(FILE *ifp, FILE *ofp, int count)
{
	int n, num;

	while (count == -1 || count > 0) {
		if (count == -1 || count > sizeof(cmd))
			num = sizeof(cmd);
		else
			num = count;
		n = fread(cmd, 1, num, ifp);
		if (n == 0)
			break;
		if (fwrite(cmd, n, 1, ofp) != 1) {
			fprintf(stderr, "Write failed :-(\n");
			exit(1);
		}
		if (count != -1)
			count -= n;
	}
	if (count > 0) {
		fprintf(stderr, "Failed to transferr %d bytes\n", count);
		exit(1);
	}
}
	
/****************************************************************************/

void
process_file(char *ifile, char *ofile)
{
	int old_flags, old_stack, new_flags, new_stack;
	FILE *ifp, *ofp;
	int ofp_is_pipe = 0;
	struct flat_hdr old_hdr, new_hdr;
	char tfile[256];
	char tfile2[256];

	*tfile = *tfile2 = '\0';

	if ((ifp = fopen(ifile, "rb")) == NULL) {
		fprintf(stderr, "Cannot open %s\n", ifile);
		return;
	}

	if (fread(&old_hdr, sizeof(old_hdr), 1, ifp) != 1) {
		fprintf(stderr, "Cannot read header of %s\n", ifile);
		return;
	}

	if (strncmp(old_hdr.magic, "bFLT", 4) != 0) {
		fprintf(stderr, "Cannot read header of %s\n", ifile);
		return;
	}

	new_flags = old_flags = ntohl(old_hdr.flags);
	new_stack = old_stack = ntohl(old_hdr.stack_size);
	new_hdr = old_hdr;

	if (compress == 1) {
		new_flags |= FLAT_FLAG_GZIP;
		new_flags &= ~FLAT_FLAG_GZDATA;
	} else if (compress == 2) {
		new_flags |= FLAT_FLAG_GZDATA;
		new_flags &= ~FLAT_FLAG_GZIP;
	} else if (compress < 0)
		new_flags &= ~(FLAT_FLAG_GZIP|FLAT_FLAG_GZDATA);
	
	if (ramload > 0)
		new_flags |= FLAT_FLAG_RAM;
	else if (ramload < 0)
		new_flags &= ~FLAT_FLAG_RAM;
	
	if (ktrace > 0)
		new_flags |= FLAT_FLAG_KTRACE;
	else if (ktrace < 0)
		new_flags &= ~FLAT_FLAG_KTRACE;
	
	if (stacksize)
		new_stack = stacksize;

	if (print == 1) {
		time_t t;

		printf("%s\n", ifile);
		printf("    Magic:        %4.4s\n", old_hdr.magic);
		printf("    Rev:          %d\n",    ntohl(old_hdr.rev));
		t = (time_t) htonl(old_hdr.build_date);
		printf("    Build Date:   %s",      t?ctime(&t):"not specified\n");
		printf("    Entry:        0x%x\n",  ntohl(old_hdr.entry));
		printf("    Data Start:   0x%x\n",  ntohl(old_hdr.data_start));
		printf("    Data End:     0x%x\n",  ntohl(old_hdr.data_end));
		printf("    BSS End:      0x%x\n",  ntohl(old_hdr.bss_end));
		printf("    Stack Size:   0x%x\n",  ntohl(old_hdr.stack_size));
		printf("    Reloc Start:  0x%x\n",  ntohl(old_hdr.reloc_start));
		printf("    Reloc Count:  0x%x\n",  ntohl(old_hdr.reloc_count));
		printf("    Flags:        0x%x ( ",  ntohl(old_hdr.flags));
		if (old_flags) {
			if (old_flags & FLAT_FLAG_RAM)
				printf("Load-to-Ram ");
			if (old_flags & FLAT_FLAG_GOTPIC)
				printf("Has-PIC-GOT ");
			if (old_flags & FLAT_FLAG_GZIP)
				printf("Gzip-Compressed ");
			if (old_flags & FLAT_FLAG_GZDATA)
				printf("Gzip-Data-Compressed ");
			if (old_flags & FLAT_FLAG_KTRACE)
				printf("Kernel-Traced-Load ");
			printf(")\n");
		}
	} else if (print > 1) {
		static int first = 1;
		unsigned int text, data, bss, stk, rel, tot;

		if (first) {
			printf("Flag Rev   Text   Data    BSS  Stack Relocs    RAM Filename\n");
			printf("-----------------------------------------------------------\n");
			first = 0;
		}
		*tfile = '\0';
		strcat(tfile, (old_flags & FLAT_FLAG_KTRACE) ? "k" : "");
		strcat(tfile, (old_flags & FLAT_FLAG_RAM) ? "r" : "");
		strcat(tfile, (old_flags & FLAT_FLAG_GOTPIC) ? "p" : "");
		strcat(tfile, (old_flags & FLAT_FLAG_GZIP) ? "z" :
					((old_flags & FLAT_FLAG_GZDATA) ? "d" : ""));
		printf("-%-3.3s ", tfile);
		printf("%3d ", ntohl(old_hdr.rev));
		printf("%6d ", text=ntohl(old_hdr.data_start)-sizeof(struct flat_hdr));
		printf("%6d ", data=ntohl(old_hdr.data_end)-ntohl(old_hdr.data_start));
		printf("%6d ", bss=ntohl(old_hdr.bss_end)-ntohl(old_hdr.data_end));
		printf("%6d ", stk=ntohl(old_hdr.stack_size));
		printf("%6d ", rel=ntohl(old_hdr.reloc_count) * 4);
		/*
		 * work out how much RAM is needed per invocation, this
		 * calculation is dependent on the binfmt_flat implementation
		 */
		tot = data; /* always need data */

		if (old_flags & (FLAT_FLAG_RAM|FLAT_FLAG_GZIP))
			tot += text + sizeof(struct flat_hdr);
		
		if (bss + stk > rel) /* which is bigger ? */
			tot += bss + stk;
		else
			tot += rel;

		printf("%6d ", tot);
		/*
		 * the total depends on whether the relocs are smaller/bigger than
		 * the BSS
		 */
		printf("%s\n", ifile);
	}

	/* if there is nothing else to do, leave */
	if (new_flags == old_flags && new_stack == old_stack)
		return;
	
	new_hdr.flags = htonl(new_flags);
	new_hdr.stack_size = htonl(new_stack);

	strcpy(tfile, "/tmp/flatXXXXXX");
	mkstemp(tfile);
	if ((ofp = fopen(tfile, "wb")) == NULL) {
		fprintf(stderr, "Failed to open %s for writing\n", tfile);
		unlink(tfile);
		unlink(tfile2);
		exit(1);
	}

	if (fwrite(&new_hdr, sizeof(new_hdr), 1, ofp) != 1) {
		fprintf(stderr, "Failed to write to  %s\n", tfile);
		unlink(tfile);
		unlink(tfile2);
		exit(1);
	}

	/*
	 * get ourselves a fully uncompressed copy of the text/data/relocs
	 * so that we can manipulate it more easily
	 */
	if (old_flags & (FLAT_FLAG_GZIP|FLAT_FLAG_GZDATA)) {
		FILE *tfp;

		strcpy(tfile2, "/tmp/flat2XXXXXX");
		mkstemp(tfile2);
		
		if (old_flags & FLAT_FLAG_GZDATA) {
			tfp = fopen(tfile2, "wb");
			if (!tfp) {
				fprintf(stderr, "Failed to open %s for writing\n", tfile2);
				exit(1);
			}
			transferr(ifp, tfp, ntohl(old_hdr.data_start) -
					sizeof(struct flat_hdr));
			fclose(tfp);
		}

		sprintf(cmd, "gunzip >> %s", tfile2);
		tfp = popen(cmd, "wb");
		if(!tfp) {
			perror("popen");
			exit(1);
		}
		transferr(ifp, tfp, -1);
		pclose(tfp);

		fclose(ifp);
		ifp = fopen(tfile2, "rb");
		if (!ifp) {
			fprintf(stderr, "Failed to open %s for reading\n", tfile2);
			unlink(tfile);
			unlink(tfile2);
			exit(1);
		}
	}

	if (new_flags & FLAT_FLAG_GZIP) {
		printf("zflat %s --> %s\n", ifile, ofile);
		fclose(ofp);
		sprintf(cmd, "gzip -9 -f >> %s", tfile);
		ofp = popen(cmd, "wb");
		ofp_is_pipe = 1;
	} else if (new_flags & FLAT_FLAG_GZDATA) {
		printf("zflat-data %s --> %s\n", ifile, ofile);
		transferr(ifp, ofp, ntohl(new_hdr.data_start) -
				sizeof(struct flat_hdr));
		fclose(ofp);
		sprintf(cmd, "gzip -9 -f >> %s", tfile);
		ofp = popen(cmd, "wb");
		ofp_is_pipe = 1;
	}

	if (!ofp) { /* can only happen if using gzip/gunzip */
		fprintf(stderr, "Can't run cmd %s\n", cmd);
		unlink(tfile);
		unlink(tfile2);
		exit(1);
	}

	transferr(ifp, ofp, -1);
	
	if (ferror(ifp) || ferror(ofp)) {
		fprintf(stderr, "Error on file pointer%s%s\n",
				ferror(ifp) ? " input" : "", ferror(ofp) ? " output" : "");
		unlink(tfile);
		unlink(tfile2);
		exit(1);
	}

	fclose(ifp);
	if (ofp_is_pipe)
		pclose(ofp);
	else
		fclose(ofp);

	/* cheat a little here to preserve file permissions */
	sprintf(cmd, "cp %s %s", tfile, ofile);
	system(cmd);
	unlink(tfile);
	unlink(tfile2);
}

/****************************************************************************/

void
usage(char *s)
{
	if (s)
		fprintf(stderr, "%s\n", s);
	fprintf(stderr, "usage: %s [options] flat-file\n", program_name);
	fprintf(stderr, "       Allows you to change an existing flat file\n\n");
	fprintf(stderr, "       -p      : print current settings\n");
	fprintf(stderr, "       -z      : compressed flat file\n");
	fprintf(stderr, "       -d      : compressed data-only flat file\n");
	fprintf(stderr, "       -Z      : un-compressed flat file\n");
	fprintf(stderr, "       -r      : ram load\n");
	fprintf(stderr, "       -R      : do not RAM load\n");
	fprintf(stderr, "       -k      : kernel traced load (for debug)\n");
	fprintf(stderr, "       -K      : normal non-kernel traced load\n");
	fprintf(stderr, "       -s size : stack size\n");
	fprintf(stderr, "       -o file : output-file\n"
	                "                 (default is to modify input file)\n");
	exit(1);
}

/****************************************************************************/

int
main(int argc, char *argv[])
{
	int c;
	char *ofile = NULL, *ifile;

	program_name = argv[0];

	while ((c = getopt(argc, argv, "pdzZrRkKs:o:")) != EOF) {
		switch (c) {
		case 'p': print = 1;                break;
		case 'z': compress = 1;             break;
		case 'd': compress = 2;             break;
		case 'Z': compress = -1;            break;
		case 'r': ramload = 1;              break;
		case 'R': ramload = -1;             break;
		case 'k': ktrace = 1;               break;
		case 'K': ktrace = -1;              break;
		case 's': stacksize = atoi(optarg); break;
		case 'o': ofile = optarg;           break;
		default:
			usage("invalid option");
			break;
		}
	}

	if (optind >= argc)
		usage("No input files provided");

	if (ofile && argc - optind > 1)
		usage("-o can only be used with a single file");
	
	if (!print && !compress && !ramload && !stacksize) /* no args == print */
		print = argc - optind; /* greater than 1 is short format */
	
	for (c = optind; c < argc; c++) {
		ifile = argv[c];
		if (!ofile)
			ofile = ifile;
		process_file(ifile, ofile);
		ofile = NULL;
	}
	
	exit(0);
}

/****************************************************************************/

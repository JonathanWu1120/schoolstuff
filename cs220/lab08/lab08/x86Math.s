   1              		.file	"x86Math.c"
   2              	# GNU C11 (Debian 6.3.0-18+deb9u1) version 6.3.0 20170516 (x86_64-linux-gnu)
   3              	#	compiled by GNU C version 6.3.0 20170516, GMP version 6.1.2, MPFR version 3.1.5, MPC version 1.0.
   4              	# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
   5              	# options passed:  -imultiarch x86_64-linux-gnu x86Math.c -mtune=generic
   6              	# -march=x86-64 -g -O1 -Wall -fverbose-asm
   7              	# options enabled:  -fPIC -fPIE -faggressive-loop-optimizations
   8              	# -fasynchronous-unwind-tables -fauto-inc-dec -fbranch-count-reg
   9              	# -fchkp-check-incomplete-type -fchkp-check-read -fchkp-check-write
  10              	# -fchkp-instrument-calls -fchkp-narrow-bounds -fchkp-optimize
  11              	# -fchkp-store-bounds -fchkp-use-static-bounds
  12              	# -fchkp-use-static-const-bounds -fchkp-use-wrappers
  13              	# -fcombine-stack-adjustments -fcommon -fcompare-elim -fcprop-registers
  14              	# -fdefer-pop -fdelete-null-pointer-checks -fdwarf2-cfi-asm
  15              	# -fearly-inlining -feliminate-unused-debug-types -fforward-propagate
  16              	# -ffunction-cse -fgcse-lm -fgnu-runtime -fgnu-unique
  17              	# -fguess-branch-probability -fident -fif-conversion -fif-conversion2
  18              	# -finline -finline-atomics -finline-functions-called-once -fipa-profile
  19              	# -fipa-pure-const -fipa-reference -fira-hoist-pressure
  20              	# -fira-share-save-slots -fira-share-spill-slots -fivopts
  21              	# -fkeep-static-consts -fleading-underscore -flifetime-dse
  22              	# -flto-odr-type-merging -fmath-errno -fmerge-constants
  23              	# -fmerge-debug-strings -fmove-loop-invariants -fomit-frame-pointer
  24              	# -fpeephole -fplt -fprefetch-loop-arrays -freg-struct-return
  25              	# -freorder-blocks -fsched-critical-path-heuristic
  26              	# -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock
  27              	# -fsched-last-insn-heuristic -fsched-rank-heuristic -fsched-spec
  28              	# -fsched-spec-insn-heuristic -fsched-stalled-insns-dep -fschedule-fusion
  29              	# -fsemantic-interposition -fshow-column -fshrink-wrap -fsigned-zeros
  30              	# -fsplit-ivs-in-unroller -fsplit-wide-types -fssa-backprop -fssa-phiopt
  31              	# -fstdarg-opt -fstrict-volatile-bitfields -fsync-libcalls
  32              	# -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp -ftree-builtin-call-dce
  33              	# -ftree-ccp -ftree-ch -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim
  34              	# -ftree-dce -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
  35              	# -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
  36              	# -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop -ftree-pta
  37              	# -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slsr -ftree-sra
  38              	# -ftree-ter -funit-at-a-time -funwind-tables -fvar-tracking
  39              	# -fvar-tracking-assignments -fverbose-asm -fzero-initialized-in-bss
  40              	# -m128bit-long-double -m64 -m80387 -malign-stringops
  41              	# -mavx256-split-unaligned-load -mavx256-split-unaligned-store
  42              	# -mfancy-math-387 -mfp-ret-in-387 -mfxsr -mglibc -mieee-fp
  43              	# -mlong-double-80 -mmmx -mno-sse4 -mpush-args -mred-zone -msse -msse2
  44              	# -mstv -mtls-direct-seg-refs -mvzeroupper
  45              	
  46              		.text
  47              	.Ltext0:
  48              		.section	.rodata.str1.1,"aMS",@progbits,1
  49              	.LC0:
  50 0000 496E766F 		.string	"Invoke as %s <number>\n"
  50      6B652061 
  50      73202573 
  50      203C6E75 
  50      6D626572 
  51              		.section	.rodata.str1.8,"aMS",@progbits,1
  52              		.align 8
  53              	.LC1:
  54 0000 783D2564 		.string	"x=%d, x squared - 4x + 4 =%d divided by x-2=%d\n"
  54      2C207820 
  54      73717561 
  54      72656420 
  54      2D203478 
  55              		.text
  56              		.globl	main
  58              	main:
  59              	.LFB21:
  60              		.file 1 "x86Math.c"
   1:x86Math.c     **** #include <stdio.h>
   2:x86Math.c     **** #include <stdlib.h>
   3:x86Math.c     **** 
   4:x86Math.c     **** int add(int x, int y);
   5:x86Math.c     **** int mult(int x, int y);
   6:x86Math.c     **** int subtract(int x, int y);
   7:x86Math.c     **** int divide(int x, int y);
   8:x86Math.c     **** 
   9:x86Math.c     **** int main(int argc, char **argv) {
  61              		.loc 1 9 0
  62              		.cfi_startproc
  63              	.LVL0:
  64 0000 4883EC08 		subq	$8, %rsp	#,
  65              		.cfi_def_cfa_offset 16
  10:x86Math.c     **** 	if (argc < 2) {
  66              		.loc 1 10 0
  67 0004 83FF01   		cmpl	$1, %edi	#, argc
  68 0007 7E4E     		jle	.L5	#,
  69              	.LVL1:
  70              	.LBB18:
  71              	.LBB19:
  72              		.file 2 "/usr/include/stdlib.h"
   1:/usr/include/stdlib.h **** /* Copyright (C) 1991-2016 Free Software Foundation, Inc.
   2:/usr/include/stdlib.h ****    This file is part of the GNU C Library.
   3:/usr/include/stdlib.h **** 
   4:/usr/include/stdlib.h ****    The GNU C Library is free software; you can redistribute it and/or
   5:/usr/include/stdlib.h ****    modify it under the terms of the GNU Lesser General Public
   6:/usr/include/stdlib.h ****    License as published by the Free Software Foundation; either
   7:/usr/include/stdlib.h ****    version 2.1 of the License, or (at your option) any later version.
   8:/usr/include/stdlib.h **** 
   9:/usr/include/stdlib.h ****    The GNU C Library is distributed in the hope that it will be useful,
  10:/usr/include/stdlib.h ****    but WITHOUT ANY WARRANTY; without even the implied warranty of
  11:/usr/include/stdlib.h ****    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  12:/usr/include/stdlib.h ****    Lesser General Public License for more details.
  13:/usr/include/stdlib.h **** 
  14:/usr/include/stdlib.h ****    You should have received a copy of the GNU Lesser General Public
  15:/usr/include/stdlib.h ****    License along with the GNU C Library; if not, see
  16:/usr/include/stdlib.h ****    <http://www.gnu.org/licenses/>.  */
  17:/usr/include/stdlib.h **** 
  18:/usr/include/stdlib.h **** /*
  19:/usr/include/stdlib.h ****  *	ISO C99 Standard: 7.20 General utilities	<stdlib.h>
  20:/usr/include/stdlib.h ****  */
  21:/usr/include/stdlib.h **** 
  22:/usr/include/stdlib.h **** #ifndef	_STDLIB_H
  23:/usr/include/stdlib.h **** 
  24:/usr/include/stdlib.h **** #include <features.h>
  25:/usr/include/stdlib.h **** 
  26:/usr/include/stdlib.h **** /* Get size_t, wchar_t and NULL from <stddef.h>.  */
  27:/usr/include/stdlib.h **** #define		__need_size_t
  28:/usr/include/stdlib.h **** #ifndef __need_malloc_and_calloc
  29:/usr/include/stdlib.h **** # define	__need_wchar_t
  30:/usr/include/stdlib.h **** # define	__need_NULL
  31:/usr/include/stdlib.h **** #endif
  32:/usr/include/stdlib.h **** #include <stddef.h>
  33:/usr/include/stdlib.h **** 
  34:/usr/include/stdlib.h **** __BEGIN_DECLS
  35:/usr/include/stdlib.h **** 
  36:/usr/include/stdlib.h **** #ifndef __need_malloc_and_calloc
  37:/usr/include/stdlib.h **** #define	_STDLIB_H	1
  38:/usr/include/stdlib.h **** 
  39:/usr/include/stdlib.h **** #if (defined __USE_XOPEN || defined __USE_XOPEN2K8) && !defined _SYS_WAIT_H
  40:/usr/include/stdlib.h **** /* XPG requires a few symbols from <sys/wait.h> being defined.  */
  41:/usr/include/stdlib.h **** # include <bits/waitflags.h>
  42:/usr/include/stdlib.h **** # include <bits/waitstatus.h>
  43:/usr/include/stdlib.h **** 
  44:/usr/include/stdlib.h **** /* Define the macros <sys/wait.h> also would define this way.  */
  45:/usr/include/stdlib.h **** # define WEXITSTATUS(status)	__WEXITSTATUS (status)
  46:/usr/include/stdlib.h **** # define WTERMSIG(status)	__WTERMSIG (status)
  47:/usr/include/stdlib.h **** # define WSTOPSIG(status)	__WSTOPSIG (status)
  48:/usr/include/stdlib.h **** # define WIFEXITED(status)	__WIFEXITED (status)
  49:/usr/include/stdlib.h **** # define WIFSIGNALED(status)	__WIFSIGNALED (status)
  50:/usr/include/stdlib.h **** # define WIFSTOPPED(status)	__WIFSTOPPED (status)
  51:/usr/include/stdlib.h **** # ifdef __WIFCONTINUED
  52:/usr/include/stdlib.h **** #  define WIFCONTINUED(status)	__WIFCONTINUED (status)
  53:/usr/include/stdlib.h **** # endif
  54:/usr/include/stdlib.h **** #endif	/* X/Open or XPG7 and <sys/wait.h> not included.  */
  55:/usr/include/stdlib.h **** 
  56:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_STD
  57:/usr/include/stdlib.h **** /* Returned by `div'.  */
  58:/usr/include/stdlib.h **** typedef struct
  59:/usr/include/stdlib.h ****   {
  60:/usr/include/stdlib.h ****     int quot;			/* Quotient.  */
  61:/usr/include/stdlib.h ****     int rem;			/* Remainder.  */
  62:/usr/include/stdlib.h ****   } div_t;
  63:/usr/include/stdlib.h **** 
  64:/usr/include/stdlib.h **** /* Returned by `ldiv'.  */
  65:/usr/include/stdlib.h **** #ifndef __ldiv_t_defined
  66:/usr/include/stdlib.h **** typedef struct
  67:/usr/include/stdlib.h ****   {
  68:/usr/include/stdlib.h ****     long int quot;		/* Quotient.  */
  69:/usr/include/stdlib.h ****     long int rem;		/* Remainder.  */
  70:/usr/include/stdlib.h ****   } ldiv_t;
  71:/usr/include/stdlib.h **** # define __ldiv_t_defined	1
  72:/usr/include/stdlib.h **** #endif
  73:/usr/include/stdlib.h **** __END_NAMESPACE_STD
  74:/usr/include/stdlib.h **** 
  75:/usr/include/stdlib.h **** #if defined __USE_ISOC99 && !defined __lldiv_t_defined
  76:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_C99
  77:/usr/include/stdlib.h **** /* Returned by `lldiv'.  */
  78:/usr/include/stdlib.h **** __extension__ typedef struct
  79:/usr/include/stdlib.h ****   {
  80:/usr/include/stdlib.h ****     long long int quot;		/* Quotient.  */
  81:/usr/include/stdlib.h ****     long long int rem;		/* Remainder.  */
  82:/usr/include/stdlib.h ****   } lldiv_t;
  83:/usr/include/stdlib.h **** # define __lldiv_t_defined	1
  84:/usr/include/stdlib.h **** __END_NAMESPACE_C99
  85:/usr/include/stdlib.h **** #endif
  86:/usr/include/stdlib.h **** 
  87:/usr/include/stdlib.h **** 
  88:/usr/include/stdlib.h **** /* The largest number rand will return (same as INT_MAX).  */
  89:/usr/include/stdlib.h **** #define	RAND_MAX	2147483647
  90:/usr/include/stdlib.h **** 
  91:/usr/include/stdlib.h **** 
  92:/usr/include/stdlib.h **** /* We define these the same for all machines.
  93:/usr/include/stdlib.h ****    Changes from this to the outside world should be done in `_exit'.  */
  94:/usr/include/stdlib.h **** #define	EXIT_FAILURE	1	/* Failing exit status.  */
  95:/usr/include/stdlib.h **** #define	EXIT_SUCCESS	0	/* Successful exit status.  */
  96:/usr/include/stdlib.h **** 
  97:/usr/include/stdlib.h **** 
  98:/usr/include/stdlib.h **** /* Maximum length of a multibyte character in the current locale.  */
  99:/usr/include/stdlib.h **** #define	MB_CUR_MAX	(__ctype_get_mb_cur_max ())
 100:/usr/include/stdlib.h **** extern size_t __ctype_get_mb_cur_max (void) __THROW __wur;
 101:/usr/include/stdlib.h **** 
 102:/usr/include/stdlib.h **** 
 103:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_STD
 104:/usr/include/stdlib.h **** /* Convert a string to a floating-point number.  */
 105:/usr/include/stdlib.h **** extern double atof (const char *__nptr)
 106:/usr/include/stdlib.h ****      __THROW __attribute_pure__ __nonnull ((1)) __wur;
 107:/usr/include/stdlib.h **** /* Convert a string to an integer.  */
 108:/usr/include/stdlib.h **** extern int atoi (const char *__nptr)
 109:/usr/include/stdlib.h ****      __THROW __attribute_pure__ __nonnull ((1)) __wur;
 110:/usr/include/stdlib.h **** /* Convert a string to a long integer.  */
 111:/usr/include/stdlib.h **** extern long int atol (const char *__nptr)
 112:/usr/include/stdlib.h ****      __THROW __attribute_pure__ __nonnull ((1)) __wur;
 113:/usr/include/stdlib.h **** __END_NAMESPACE_STD
 114:/usr/include/stdlib.h **** 
 115:/usr/include/stdlib.h **** #ifdef __USE_ISOC99
 116:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_C99
 117:/usr/include/stdlib.h **** /* Convert a string to a long long integer.  */
 118:/usr/include/stdlib.h **** __extension__ extern long long int atoll (const char *__nptr)
 119:/usr/include/stdlib.h ****      __THROW __attribute_pure__ __nonnull ((1)) __wur;
 120:/usr/include/stdlib.h **** __END_NAMESPACE_C99
 121:/usr/include/stdlib.h **** #endif
 122:/usr/include/stdlib.h **** 
 123:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_STD
 124:/usr/include/stdlib.h **** /* Convert a string to a floating-point number.  */
 125:/usr/include/stdlib.h **** extern double strtod (const char *__restrict __nptr,
 126:/usr/include/stdlib.h **** 		      char **__restrict __endptr)
 127:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 128:/usr/include/stdlib.h **** __END_NAMESPACE_STD
 129:/usr/include/stdlib.h **** 
 130:/usr/include/stdlib.h **** #ifdef	__USE_ISOC99
 131:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_C99
 132:/usr/include/stdlib.h **** /* Likewise for `float' and `long double' sizes of floating-point numbers.  */
 133:/usr/include/stdlib.h **** extern float strtof (const char *__restrict __nptr,
 134:/usr/include/stdlib.h **** 		     char **__restrict __endptr) __THROW __nonnull ((1));
 135:/usr/include/stdlib.h **** 
 136:/usr/include/stdlib.h **** extern long double strtold (const char *__restrict __nptr,
 137:/usr/include/stdlib.h **** 			    char **__restrict __endptr)
 138:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 139:/usr/include/stdlib.h **** __END_NAMESPACE_C99
 140:/usr/include/stdlib.h **** #endif
 141:/usr/include/stdlib.h **** 
 142:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_STD
 143:/usr/include/stdlib.h **** /* Convert a string to a long integer.  */
 144:/usr/include/stdlib.h **** extern long int strtol (const char *__restrict __nptr,
 145:/usr/include/stdlib.h **** 			char **__restrict __endptr, int __base)
 146:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 147:/usr/include/stdlib.h **** /* Convert a string to an unsigned long integer.  */
 148:/usr/include/stdlib.h **** extern unsigned long int strtoul (const char *__restrict __nptr,
 149:/usr/include/stdlib.h **** 				  char **__restrict __endptr, int __base)
 150:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 151:/usr/include/stdlib.h **** __END_NAMESPACE_STD
 152:/usr/include/stdlib.h **** 
 153:/usr/include/stdlib.h **** #ifdef __USE_MISC
 154:/usr/include/stdlib.h **** /* Convert a string to a quadword integer.  */
 155:/usr/include/stdlib.h **** __extension__
 156:/usr/include/stdlib.h **** extern long long int strtoq (const char *__restrict __nptr,
 157:/usr/include/stdlib.h **** 			     char **__restrict __endptr, int __base)
 158:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 159:/usr/include/stdlib.h **** /* Convert a string to an unsigned quadword integer.  */
 160:/usr/include/stdlib.h **** __extension__
 161:/usr/include/stdlib.h **** extern unsigned long long int strtouq (const char *__restrict __nptr,
 162:/usr/include/stdlib.h **** 				       char **__restrict __endptr, int __base)
 163:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 164:/usr/include/stdlib.h **** #endif /* Use misc.  */
 165:/usr/include/stdlib.h **** 
 166:/usr/include/stdlib.h **** #ifdef __USE_ISOC99
 167:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_C99
 168:/usr/include/stdlib.h **** /* Convert a string to a quadword integer.  */
 169:/usr/include/stdlib.h **** __extension__
 170:/usr/include/stdlib.h **** extern long long int strtoll (const char *__restrict __nptr,
 171:/usr/include/stdlib.h **** 			      char **__restrict __endptr, int __base)
 172:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 173:/usr/include/stdlib.h **** /* Convert a string to an unsigned quadword integer.  */
 174:/usr/include/stdlib.h **** __extension__
 175:/usr/include/stdlib.h **** extern unsigned long long int strtoull (const char *__restrict __nptr,
 176:/usr/include/stdlib.h **** 					char **__restrict __endptr, int __base)
 177:/usr/include/stdlib.h ****      __THROW __nonnull ((1));
 178:/usr/include/stdlib.h **** __END_NAMESPACE_C99
 179:/usr/include/stdlib.h **** #endif /* ISO C99 or use MISC.  */
 180:/usr/include/stdlib.h **** 
 181:/usr/include/stdlib.h **** 
 182:/usr/include/stdlib.h **** #ifdef __USE_GNU
 183:/usr/include/stdlib.h **** /* The concept of one static locale per category is not very well
 184:/usr/include/stdlib.h ****    thought out.  Many applications will need to process its data using
 185:/usr/include/stdlib.h ****    information from several different locales.  Another problem is
 186:/usr/include/stdlib.h ****    the implementation of the internationalization handling in the
 187:/usr/include/stdlib.h ****    ISO C++ standard library.  To support this another set of
 188:/usr/include/stdlib.h ****    the functions using locale data exist which take an additional
 189:/usr/include/stdlib.h ****    argument.
 190:/usr/include/stdlib.h **** 
 191:/usr/include/stdlib.h ****    Attention: even though several *_l interfaces are part of POSIX:2008,
 192:/usr/include/stdlib.h ****    these are not.  */
 193:/usr/include/stdlib.h **** 
 194:/usr/include/stdlib.h **** /* Structure for reentrant locale using functions.  This is an
 195:/usr/include/stdlib.h ****    (almost) opaque type for the user level programs.  */
 196:/usr/include/stdlib.h **** # include <xlocale.h>
 197:/usr/include/stdlib.h **** 
 198:/usr/include/stdlib.h **** /* Special versions of the functions above which take the locale to
 199:/usr/include/stdlib.h ****    use as an additional parameter.  */
 200:/usr/include/stdlib.h **** extern long int strtol_l (const char *__restrict __nptr,
 201:/usr/include/stdlib.h **** 			  char **__restrict __endptr, int __base,
 202:/usr/include/stdlib.h **** 			  __locale_t __loc) __THROW __nonnull ((1, 4));
 203:/usr/include/stdlib.h **** 
 204:/usr/include/stdlib.h **** extern unsigned long int strtoul_l (const char *__restrict __nptr,
 205:/usr/include/stdlib.h **** 				    char **__restrict __endptr,
 206:/usr/include/stdlib.h **** 				    int __base, __locale_t __loc)
 207:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 4));
 208:/usr/include/stdlib.h **** 
 209:/usr/include/stdlib.h **** __extension__
 210:/usr/include/stdlib.h **** extern long long int strtoll_l (const char *__restrict __nptr,
 211:/usr/include/stdlib.h **** 				char **__restrict __endptr, int __base,
 212:/usr/include/stdlib.h **** 				__locale_t __loc)
 213:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 4));
 214:/usr/include/stdlib.h **** 
 215:/usr/include/stdlib.h **** __extension__
 216:/usr/include/stdlib.h **** extern unsigned long long int strtoull_l (const char *__restrict __nptr,
 217:/usr/include/stdlib.h **** 					  char **__restrict __endptr,
 218:/usr/include/stdlib.h **** 					  int __base, __locale_t __loc)
 219:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 4));
 220:/usr/include/stdlib.h **** 
 221:/usr/include/stdlib.h **** extern double strtod_l (const char *__restrict __nptr,
 222:/usr/include/stdlib.h **** 			char **__restrict __endptr, __locale_t __loc)
 223:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 3));
 224:/usr/include/stdlib.h **** 
 225:/usr/include/stdlib.h **** extern float strtof_l (const char *__restrict __nptr,
 226:/usr/include/stdlib.h **** 		       char **__restrict __endptr, __locale_t __loc)
 227:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 3));
 228:/usr/include/stdlib.h **** 
 229:/usr/include/stdlib.h **** extern long double strtold_l (const char *__restrict __nptr,
 230:/usr/include/stdlib.h **** 			      char **__restrict __endptr,
 231:/usr/include/stdlib.h **** 			      __locale_t __loc)
 232:/usr/include/stdlib.h ****      __THROW __nonnull ((1, 3));
 233:/usr/include/stdlib.h **** #endif /* GNU */
 234:/usr/include/stdlib.h **** 
 235:/usr/include/stdlib.h **** 
 236:/usr/include/stdlib.h **** #ifdef __USE_EXTERN_INLINES
 237:/usr/include/stdlib.h **** __BEGIN_NAMESPACE_STD
 238:/usr/include/stdlib.h **** __extern_inline int
 239:/usr/include/stdlib.h **** __NTH (atoi (const char *__nptr))
 240:/usr/include/stdlib.h **** {
 241:/usr/include/stdlib.h ****   return (int) strtol (__nptr, (char **) NULL, 10);
  73              		.loc 2 241 0
  74 0009 488B7E08 		movq	8(%rsi), %rdi	# MEM[(char * *)argv_5(D) + 8B], MEM[(char * *)argv_5(D) + 8B]
  75              	.LVL2:
  76 000d BA0A0000 		movl	$10, %edx	#,
  76      00
  77 0012 BE000000 		movl	$0, %esi	#,
  77      00
  78              	.LVL3:
  79 0017 E8000000 		call	strtol@PLT	#
  79      00
  80              	.LVL4:
  81 001c 4889C6   		movq	%rax, %rsi	#, _16
  82              	.LVL5:
  83              	.LBE19:
  84              	.LBE18:
  85              	.LBB20:
  86              	.LBB21:
  11:x86Math.c     **** 		printf("Invoke as %s <number>\n",argv[0]);
  12:x86Math.c     **** 		return 1;
  13:x86Math.c     **** 	}
  14:x86Math.c     **** 	int x=atoi(argv[1]);
  15:x86Math.c     **** 	int ans=mult(x,x);
  16:x86Math.c     **** 	int term=mult(4,x);
  17:x86Math.c     **** 	ans=subtract(ans,term);
  18:x86Math.c     **** 	ans=add(ans,4);
  19:x86Math.c     **** 	term=subtract(x,2);
  20:x86Math.c     **** 	int check=divide(ans,term);
  21:x86Math.c     **** 	printf("x=%d, x squared - 4x + 4 =%d divided by x-2=%d\n",x,ans,check);
  22:x86Math.c     **** 	return 0;
  23:x86Math.c     **** }
  24:x86Math.c     **** 
  25:x86Math.c     **** #ifdef SIMPLE
  26:x86Math.c     **** 	int add(int x, int y) { return x+y; }
  27:x86Math.c     **** 	int subtract(int x, int y) { return x-y; }
  28:x86Math.c     **** 	int mult(int x, int y) { return x*y; }
  29:x86Math.c     **** 	int divide(int x, int y) { return x/y; }
  30:x86Math.c     **** #else
  31:x86Math.c     **** 
  32:x86Math.c     **** 	int add(int x, int y) {
  33:x86Math.c     **** 		int op1=x;
  34:x86Math.c     **** 		int op2=y;
  35:x86Math.c     **** 		int res=op1+op2;
  36:x86Math.c     **** 		return res;
  37:x86Math.c     **** 	}
  38:x86Math.c     **** 
  39:x86Math.c     **** 	int subtract(int x, int y) {
  40:x86Math.c     **** 		int op1=x;
  41:x86Math.c     **** 		int op2=y;
  42:x86Math.c     **** 		int res=op1-op2;
  43:x86Math.c     **** 		return res;
  44:x86Math.c     **** 	}
  45:x86Math.c     **** 
  46:x86Math.c     **** 	int mult(int x, int y) {
  47:x86Math.c     **** 		int op1=x;
  48:x86Math.c     **** 		int op2=y;
  49:x86Math.c     **** 		int res=op1*op2;
  87              		.loc 1 49 0
  88 001f 89C7     		movl	%eax, %edi	# _16, res
  89 0021 0FAFF8   		imull	%eax, %edi	# _16, res
  90              	.LBE21:
  91              	.LBE20:
  92              	.LBB22:
  93              	.LBB23:
  94 0024 8D048500 		leal	0(,%rax,4), %eax	#, res
  94      000000
  95              	.LVL6:
  96              	.LBE23:
  97              	.LBE22:
  98              	.LBB24:
  99              	.LBB25:
  42:x86Math.c     **** 		return res;
 100              		.loc 1 42 0
 101 002b 29C7     		subl	%eax, %edi	# res, res
 102              	.LBE25:
 103              	.LBE24:
 104              	.LBB26:
 105              	.LBB27:
  35:x86Math.c     **** 		return res;
 106              		.loc 1 35 0
 107 002d 83C704   		addl	$4, %edi	#, res
 108              	.LVL7:
 109              	.LBE27:
 110              	.LBE26:
 111              	.LBB28:
 112              	.LBB29:
  42:x86Math.c     **** 		return res;
 113              		.loc 1 42 0
 114 0030 8D4EFE   		leal	-2(%rsi), %ecx	#, res
 115              	.LBE29:
 116              	.LBE28:
 117              	.LBB30:
 118              	.LBB31:
  50:x86Math.c     **** 		return res;
  51:x86Math.c     **** 	}
  52:x86Math.c     **** 
  53:x86Math.c     **** 	int divide(int x, int y) {
  54:x86Math.c     **** 		int op1=x;
  55:x86Math.c     **** 		int op2=y;
  56:x86Math.c     **** 		int res=op1/op2;
 119              		.loc 1 56 0
 120 0033 89F8     		movl	%edi, %eax	# res, res
 121 0035 99       		cltd
 122 0036 F7F9     		idivl	%ecx	# res
 123 0038 89C1     		movl	%eax, %ecx	# res, res
 124              	.LBE31:
 125              	.LBE30:
  21:x86Math.c     **** 	return 0;
 126              		.loc 1 21 0
 127 003a 89FA     		movl	%edi, %edx	# res,
 128 003c 488D3D00 		leaq	.LC1(%rip), %rdi	#,
 128      000000
 129 0043 B8000000 		movl	$0, %eax	#,
 129      00
 130 0048 E8000000 		call	printf@PLT	#
 130      00
 131              	.LVL8:
  22:x86Math.c     **** }
 132              		.loc 1 22 0
 133 004d B8000000 		movl	$0, %eax	#, <retval>
 133      00
 134              	.LVL9:
 135              	.L1:
  23:x86Math.c     **** 
 136              		.loc 1 23 0
 137 0052 4883C408 		addq	$8, %rsp	#,
 138              		.cfi_remember_state
 139              		.cfi_def_cfa_offset 8
 140 0056 C3       		ret
 141              	.LVL10:
 142              	.L5:
 143              		.cfi_restore_state
  11:x86Math.c     **** 		return 1;
 144              		.loc 1 11 0
 145 0057 488B36   		movq	(%rsi), %rsi	# *argv_5(D),
 146              	.LVL11:
 147 005a 488D3D00 		leaq	.LC0(%rip), %rdi	#,
 147      000000
 148              	.LVL12:
 149 0061 B8000000 		movl	$0, %eax	#,
 149      00
 150 0066 E8000000 		call	printf@PLT	#
 150      00
 151              	.LVL13:
  12:x86Math.c     **** 	}
 152              		.loc 1 12 0
 153 006b B8010000 		movl	$1, %eax	#, <retval>
 153      00
 154 0070 EBE0     		jmp	.L1	#
 155              		.cfi_endproc
 156              	.LFE21:
 158              		.globl	add
 160              	add:
 161              	.LFB22:
  32:x86Math.c     **** 		int op1=x;
 162              		.loc 1 32 0
 163              		.cfi_startproc
 164              	.LVL14:
  35:x86Math.c     **** 		return res;
 165              		.loc 1 35 0
 166 0072 8D0437   		leal	(%rdi,%rsi), %eax	#, res
 167              	.LVL15:
  37:x86Math.c     **** 
 168              		.loc 1 37 0
 169 0075 C3       		ret
 170              		.cfi_endproc
 171              	.LFE22:
 173              		.globl	subtract
 175              	subtract:
 176              	.LFB23:
  39:x86Math.c     **** 		int op1=x;
 177              		.loc 1 39 0
 178              		.cfi_startproc
 179              	.LVL16:
  42:x86Math.c     **** 		return res;
 180              		.loc 1 42 0
 181 0076 89F8     		movl	%edi, %eax	# x, x
 182 0078 29F0     		subl	%esi, %eax	# y, x
 183              	.LVL17:
  44:x86Math.c     **** 
 184              		.loc 1 44 0
 185 007a C3       		ret
 186              		.cfi_endproc
 187              	.LFE23:
 189              		.globl	mult
 191              	mult:
 192              	.LFB24:
  46:x86Math.c     **** 		int op1=x;
 193              		.loc 1 46 0
 194              		.cfi_startproc
 195              	.LVL18:
  49:x86Math.c     **** 		return res;
 196              		.loc 1 49 0
 197 007b 89F8     		movl	%edi, %eax	# x, x
 198 007d 0FAFC6   		imull	%esi, %eax	# y, x
 199              	.LVL19:
  51:x86Math.c     **** 
 200              		.loc 1 51 0
 201 0080 C3       		ret
 202              		.cfi_endproc
 203              	.LFE24:
 205              		.globl	divide
 207              	divide:
 208              	.LFB25:
  53:x86Math.c     **** 		int op1=x;
 209              		.loc 1 53 0
 210              		.cfi_startproc
 211              	.LVL20:
 212 0081 89F8     		movl	%edi, %eax	# x, x
 213              	.LVL21:
 214              		.loc 1 56 0
 215 0083 99       		cltd
 216 0084 F7FE     		idivl	%esi	# y
 217              	.LVL22:
  57:x86Math.c     **** 		return res;
  58:x86Math.c     **** 	}
 218              		.loc 1 58 0
 219 0086 C3       		ret
 220              		.cfi_endproc
 221              	.LFE25:
 223              	.Letext0:
 224              		.file 3 "/usr/lib/gcc/x86_64-linux-gnu/6/include/stddef.h"
 225              		.file 4 "/usr/include/x86_64-linux-gnu/bits/types.h"
 226              		.file 5 "/usr/include/libio.h"
 227              		.file 6 "/usr/include/stdio.h"
 228              		.file 7 "/usr/include/x86_64-linux-gnu/bits/sys_errlist.h"

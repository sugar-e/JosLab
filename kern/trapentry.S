/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(divide, T_DIVIDE)				# divide error
	TRAPHANDLER_NOEC(debug, T_DEBUG)						# debug exception
	TRAPHANDLER_NOEC(nmi, T_NMI)							# non-maskable interrupt
    TRAPHANDLER_NOEC(brkpt, T_BRKPT)					# breakpoint
	TRAPHANDLER_NOEC(oflow, T_OFLOW)						# overflow
	TRAPHANDLER_NOEC(bound, T_BOUND)						# bounds check
	TRAPHANDLER_NOEC(illop, T_ILLOP)					# illegal opcode
	TRAPHANDLER_NOEC(device, T_DEVICE)		# device not available
	TRAPHANDLER(dblflt, T_DBLFLT)						# double fault
	TRAPHANDLER_NOEC(coproc,T_COPROC)
	TRAPHANDLER(tss, T_TSS)							# invalid task switch segment
	TRAPHANDLER(segnp, T_SEGNP)				# segment not present
	TRAPHANDLER(stack, T_STACK)						# stack exception
	TRAPHANDLER(gpflt, T_GPFLT)				# general protection fault
	TRAPHANDLER(pgflt, T_PGFLT)						# page fault
	
	TRAPHANDLER_NOEC(res,T_RES)
	TRAPHANDLER_NOEC(fperr, T_FPERR)			# floating point error
	TRAPHANDLER(align, T_ALIGN)					# alignment check
	TRAPHANDLER_NOEC(mchk, T_MCHK)					# machine check
	TRAPHANDLER_NOEC(simderr, T_SIMDERR)		# SIMD floating point error
	TRAPHANDLER_NOEC(trap_handler_placeholder20,20)
	TRAPHANDLER_NOEC(trap_handler_placeholder21,21)
	TRAPHANDLER_NOEC(trap_handler_placeholder22,22)
	TRAPHANDLER_NOEC(trap_handler_placeholder23,23)
	TRAPHANDLER_NOEC(trap_handler_placeholder24,24)
	TRAPHANDLER_NOEC(trap_handler_placeholder25,25)
	TRAPHANDLER_NOEC(trap_handler_placeholder26,26)
	TRAPHANDLER_NOEC(trap_handler_placeholder27,27)
	TRAPHANDLER_NOEC(trap_handler_placeholder28,28)
	TRAPHANDLER_NOEC(trap_handler_placeholder29,29)
	TRAPHANDLER_NOEC(trap_handler_placeholder30,30)
	TRAPHANDLER_NOEC(trap_handler_placeholder31,31)
	TRAPHANDLER_NOEC(trap_handler_placeholder32,32)
	TRAPHANDLER_NOEC(trap_handler_placeholder33,33)
	TRAPHANDLER_NOEC(trap_handler_placeholder34,34)
	TRAPHANDLER_NOEC(trap_handler_placeholder35,35)
	TRAPHANDLER_NOEC(trap_handler_placeholder36,36)
	TRAPHANDLER_NOEC(trap_handler_placeholder37,37)
	TRAPHANDLER_NOEC(trap_handler_placeholder38,38)
	TRAPHANDLER_NOEC(trap_handler_placeholder39,39)
	TRAPHANDLER_NOEC(trap_handler_placeholder40,40)
	TRAPHANDLER_NOEC(trap_handler_placeholder41,41)
	TRAPHANDLER_NOEC(trap_handler_placeholder42,42)
	TRAPHANDLER_NOEC(trap_handler_placeholder43,43)
	TRAPHANDLER_NOEC(trap_handler_placeholder44,44)
	TRAPHANDLER_NOEC(trap_handler_placeholder45,45)
	TRAPHANDLER_NOEC(trap_handler_placeholder46,46)
	TRAPHANDLER_NOEC(trap_handler_placeholder47,47)
	TRAPHANDLER_NOEC(sys_call, T_SYSCALL)

.data
.globl idt_entries
idt_entries:
  .long divide
  .long debug
  .long nmi
  .long brkpt
  .long oflow
  .long bound
  .long illop
  .long device
  .long dblflt
  .long coproc
  .long tss
  .long segnp
  .long stack
  .long gpflt
  .long pgflt
  .long res
  .long fperr
  .long align
  .long mchk
  .long simderr
  .long trap_handler_placeholder20
  .long trap_handler_placeholder21
  .long trap_handler_placeholder22
  .long trap_handler_placeholder23
  .long trap_handler_placeholder24
  .long trap_handler_placeholder25
  .long trap_handler_placeholder26
  .long trap_handler_placeholder27
  .long trap_handler_placeholder28
  .long trap_handler_placeholder29
  .long trap_handler_placeholder30
  .long trap_handler_placeholder31
  .long trap_handler_placeholder32
  .long trap_handler_placeholder33
  .long trap_handler_placeholder34
  .long trap_handler_placeholder35
  .long trap_handler_placeholder36
  .long trap_handler_placeholder37
  .long trap_handler_placeholder38
  .long trap_handler_placeholder39
  .long trap_handler_placeholder40
  .long trap_handler_placeholder41
  .long trap_handler_placeholder42
  .long trap_handler_placeholder43
  .long trap_handler_placeholder44
  .long trap_handler_placeholder45
  .long trap_handler_placeholder46
  .long trap_handler_placeholder47
  .long sys_call

/*
 * Lab 3: Your code here for _alltraps
 */
 _alltraps:
	/*push values to make the stack look like a struct Trapframe*/
	pushl %ds
  	pushl %es
  	pushal
	/*load GD_KD into %ds and %es*/
	movl $GD_KD, %eax
	movw %ax, %ds
	movw %ax, %es
	/*pushl %esp to pass a pointer to the Trapframe as an argument to trap()*/
	pushl %esp

	call trap 
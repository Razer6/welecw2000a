
#define STARTADDR      0x00000000
#define ROM_SIZE       0x00800000
#define RAMSTART       0x40000000
#define RAMSIZE        0x00200000
#define AHB_APB_BRIDE_BASE_ADDR  0x80000000
#define STACKPOINTER  (0x40200000-(640*480))

#define MCFG1 0x10380233
#define MCFG2 0xe6B84e60
#define MCFG3 0x000ff000

#define ASDCFG 0xfff00100
#define DSDCFG 0xe6A06e60
#define L2MCTRLIO 0x80000000

!	.seg    "data"
!	.proc   RAMSTART
!	.align  8
!	.seg    "bss"
!	.proc  STACKPOINTER
!	.align  8
	.seg	"text"
	.proc	STARTADDR
	.align	4
	.global start

start:

	flush
	set 0x10e0, %g1		! init IU
	mov %g1, %psr
	mov %g0, %wim
	mov %g0, %tbr
	mov %g0, %y
	mov %g0, %asr16
	nop
	set  0x81000f, %g1
	sta %g1, [%g0] 2
	mov %g0, %g2
	nop
	nop
	nop
	nop
	nop
	or %g2, %g2, %g0
	nop
	nop
	nop
	nop
	nop
#ifdef DSUADDR
	set	DSUADDR, %g2
	st	%g0, [%g2]
	st	%g0, [%g2+0x08]
	st	%g0, [%g2+0x20]
	st	%g0, [%g2+0x24]
	st	%g0, [%g2+0x40]
	st	%g0, [%g2+0x44]
	st	%g0, [%g2+0x50]
	st	%g0, [%g2+0x54]
	st	%g0, [%g2+0x58]
	st	%g0, [%g2+0x5C]
	st	%g0, [%g2+0x54]
#endif

2:
	mov %asr17, %g3
	and %g3, 0x1f, %g3
	mov %g0, %g4
	mov %g0, %g5
	mov %g0, %g6
	mov %g0, %g7
1:
	mov %g0, %l0
	mov %g0, %l1
	mov %g0, %l2
	mov %g0, %l3
	mov %g0, %l4
	mov %g0, %l5
	mov %g0, %l6
	mov %g0, %l7
	mov %g0, %o0
	mov %g0, %o1
	mov %g0, %o2
	mov %g0, %o3
	mov %g0, %o4
	mov %g0, %o5
	mov %g0, %o6
	mov %g0, %o7
	subcc %g3, 1, %g3
	bge 1b
	save

	mov	2, %g1
	mov	%g1, %wim
!	set 0x10e0, %g1		! enable traps
	set 0x40e0, %g1
	mov %g1, %psr
	nop; nop; nop;

	mov %psr, %g1
	srl %g1, 12, %g1
	andcc %g1, 1, %g0
	be 1f
	nop


	
	
.align	8
_fsrxx:
	.word 0
	.word 0

1:
	mov %asr17, %g3
	srl %g3, 28, %g3
	andcc %g3, 0x0f, %g3
	bne 1f

	set L2MCTRLIO, %g1
	set MCFG1, %g2
	st  %g2, [%g1]
	set MCFG2, %g2
	st  %g2, [%g1+4]
	set MCFG3, %g2
	st  %g2, [%g1+8]
!	set IRQCTRL, %g1
!	set 0x0ffff, %g2
!	st  %g2, [%g1+0x10]

	set 0xFFFFF860, %g1
	ld  [%g1], %g2
	srl %g2, 12, %g2
	set 0x01009, %g1
	subcc %g1, %g2, %g0
	bne 1f

	set ASDCFG, %g1
	set DSDCFG, %g2
	st  %g2, [%g1]

	! %g3 = cpu index
1:	set STACKPOINTER, %g2
        mov %g0, %g1
2:	subcc %g3, 0, %g0
	be 3f
	nop
	add %g1, %g2, %g1
	ba 2b
	sub %g3, 1, %g3

!	Write DWORD test

3:	set RAMSTART+100004, %g2
	set 0x11111111, %l1
	set 0x22222222, %l2
	set 0x33333333, %l3
	set 0x44444444, %l4
	set 0x55555555, %l5
	set 0x66666666, %l6
	set 0x77777777, %l7

	st %l0, [%g2]
	inc 4,%g2
	st %l1, [%g2]
	inc 4,%g2
	st %l2, [%g2]
	inc 4,%g2
	st %l3, [%g2]
	inc 4,%g2
	st %l4, [%g2]
	inc 4,%g2
	st %l5, [%g2]
	inc 4,%g2
	st %l6, [%g2]
	inc 4,%g2
	st %l7, [%g2]
	nop

	ld [%g2], %l7
	dec 4,%g2
	ld [%g2], %l6
	dec 4,%g2
	ld [%g2], %l5
	dec 4,%g2
	ld [%g2], %l4
	dec 4,%g2
	ld [%g2], %l3
	dec 4,%g2
	ld [%g2], %l2
	dec 4,%g2
	ld [%g2], %l1
	nop
		
	sth %l0, [%g2]
	inc 2,%g2
	sth %l0, [%g2]
	inc 2,%g2
	stb %l1, [%g2]
	inc 1,%g2
	stb %l1, [%g2]
	inc 1,%g2
	stb %l1, [%g2]
	inc 1,%g2
	stb %l1, [%g2]
	nop

	ldub [%g2], %l2
	dec 1,%g2
	ldub [%g2], %l2
	dec 1,%g2
	ldub [%g2], %l2
	dec 1,%g2
	ldub [%g2], %l2
	dec 2,%g2
	lduh [%g2], %l3
	dec 2,%g2
	lduh [%g2], %l3
	nop

	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2
	ld [%g2], %l0
        inc 4,%g2

	set RAMSTART+ RAMSIZE-32, %fp
	sub %fp, %g1, %fp
	sub %fp, 96, %sp

	set RAMSTART, %g1
	jmp %g1
	nop

.align	32

	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 1
	.globl	_write_pc                       ; -- Begin function write_pc
	.p2align	2
_write_pc:                              ; @write_pc
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	and	w8, w8, #0x3
	cbz	w8, LBB0_2
; %bb.1:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB0_2:
	ldur	w8, [x29, #-4]
	adrp	x9, _pc@PAGE
	str	w8, [x9, _pc@PAGEOFF]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_panic                          ; -- Begin function panic
	.p2align	2
_panic:                                 ; @panic
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	sub	sp, sp, #2080                   ; =2080
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	stur	x0, [x29, #-24]
	add	x9, sp, #16                     ; =16
	add	x8, x29, #16                    ; =16
	str	x8, [x9]
	ldur	x4, [x29, #-24]
	ldr	x5, [sp, #16]
	add	x0, sp, #24                     ; =24
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	mov	x3, #2048
	mov	x1, x3
	mov	w2, #0
	bl	___vsnprintf_chk
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	adrp	x9, ___stderrp@GOTPAGE
	ldr	x9, [x9, ___stderrp@GOTPAGEOFF]
	ldr	x0, [x9]
	adrp	x1, l_.str.31@PAGE
	add	x1, x1, l_.str.31@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
	bl	_dump_regs
	mov	w0, #-1
	bl	_exit
	.cfi_endproc
                                        ; -- End function
	.globl	_read_reg                       ; -- Begin function read_reg
	.p2align	2
_read_reg:                              ; @read_reg
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #8]
	ldr	w8, [sp, #8]
	cbnz	w8, LBB2_2
; %bb.1:
	str	wzr, [sp, #12]
	b	LBB2_3
LBB2_2:
	ldrsw	x9, [sp, #8]
	adrp	x8, __regfile@PAGE
	add	x8, x8, __regfile@PAGEOFF
	ldr	w8, [x8, x9, lsl #2]
	str	w8, [sp, #12]
LBB2_3:
	ldr	w0, [sp, #12]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_write_reg                      ; -- Begin function write_reg
	.p2align	2
_write_reg:                             ; @write_reg
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32                    ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	stur	w1, [x29, #-8]
	ldur	w8, [x29, #-4]
	cbnz	w8, LBB3_2
; %bb.1:
	b	LBB3_5
LBB3_2:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #31                     ; =31
	b.le	LBB3_4
; %bb.3:
	ldur	w8, [x29, #-8]
                                        ; implicit-def: $x10
	mov	x10, x8
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	bl	_panic
LBB3_4:
	ldur	w8, [x29, #-8]
	ldursw	x10, [x29, #-4]
	adrp	x9, __regfile@PAGE
	add	x9, x9, __regfile@PAGEOFF
	str	w8, [x9, x10, lsl #2]
LBB3_5:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_store_int8_t               ; -- Begin function mem_store_int8_t
	.p2align	2
_mem_store_int8_t:                      ; @mem_store_int8_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	sturb	w1, [x29, #-5]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	subs	x8, x8, #16, lsl #12            ; =65536
	b.hs	LBB4_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB4_3
LBB4_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB4_3:
	ldurb	w8, [x29, #-5]
	adrp	x9, _mem@PAGE
	ldr	x9, [x9, _mem@PAGEOFF]
	ldur	w10, [x29, #-4]
                                        ; kill: def $x10 killed $w10
	add	x9, x9, x10
	strb	w8, [x9]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_store_int16_t              ; -- Begin function mem_store_int16_t
	.p2align	2
_mem_store_int16_t:                     ; @mem_store_int16_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	sturh	w1, [x29, #-6]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	mov	x9, #65534
	subs	x8, x8, x9
	b.hi	LBB5_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB5_3
LBB5_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB5_3:
	ldurh	w8, [x29, #-6]
	adrp	x9, _mem@PAGE
	ldr	x9, [x9, _mem@PAGEOFF]
	ldur	w10, [x29, #-4]
                                        ; kill: def $x10 killed $w10
	add	x9, x9, x10
	strh	w8, [x9]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_store_int32_t              ; -- Begin function mem_store_int32_t
	.p2align	2
_mem_store_int32_t:                     ; @mem_store_int32_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	str	w1, [sp, #8]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	mov	x9, #65532
	subs	x8, x8, x9
	b.hi	LBB6_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB6_3
LBB6_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.4@PAGE
	add	x0, x0, l_.str.4@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB6_3:
	ldr	w8, [sp, #8]
	adrp	x9, _mem@PAGE
	ldr	x9, [x9, _mem@PAGEOFF]
	ldur	w10, [x29, #-4]
                                        ; kill: def $x10 killed $w10
	str	w8, [x9, x10]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_load_int32_t               ; -- Begin function mem_load_int32_t
	.p2align	2
_mem_load_int32_t:                      ; @mem_load_int32_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	mov	x9, #65532
	subs	x8, x8, x9
	b.hi	LBB7_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB7_3
LBB7_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.4@PAGE
	add	x0, x0, l_.str.4@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB7_3:
	adrp	x8, _mem@PAGE
	ldr	x8, [x8, _mem@PAGEOFF]
	ldur	w9, [x29, #-4]
                                        ; kill: def $x9 killed $w9
	ldr	w0, [x8, x9]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_load_int16_t               ; -- Begin function mem_load_int16_t
	.p2align	2
_mem_load_int16_t:                      ; @mem_load_int16_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	mov	x9, #65534
	subs	x8, x8, x9
	b.hi	LBB8_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB8_3
LBB8_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB8_3:
	adrp	x8, _mem@PAGE
	ldr	x8, [x8, _mem@PAGEOFF]
	ldur	w9, [x29, #-4]
                                        ; kill: def $x9 killed $w9
	ldrsh	w0, [x8, x9]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem_load_int8_t                ; -- Begin function mem_load_int8_t
	.p2align	2
_mem_load_int8_t:                       ; @mem_load_int8_t
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-4]
	ldur	w8, [x29, #-4]
	mov	w9, #-2147483648
	subs	w8, w8, w9
	stur	w8, [x29, #-4]
	ldur	w8, [x29, #-4]
                                        ; kill: def $x8 killed $w8
	subs	x8, x8, #16, lsl #12            ; =65536
	b.hs	LBB9_2
; %bb.1:
	ldur	w8, [x29, #-4]
	subs	w8, w8, #0                      ; =0
	b.hs	LBB9_3
LBB9_2:
	ldur	w9, [x29, #-4]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
LBB9_3:
	adrp	x8, _mem@PAGE
	ldr	x8, [x8, _mem@PAGEOFF]
	ldur	w9, [x29, #-4]
                                        ; kill: def $x9 killed $w9
	ldrsb	w0, [x8, x9]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_branch                         ; -- Begin function branch
	.p2align	2
_branch:                                ; @branch
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32                     ; =32
	.cfi_def_cfa_offset 32
	str	w0, [sp, #24]
	str	w1, [sp, #20]
	str	w2, [sp, #16]
	ldr	w8, [sp, #16]
                                        ; kill: def $x8 killed $w8
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	subs	x8, x8, #7                      ; =7
	b.hi	LBB10_8
; %bb.1:
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	adrp	x10, lJTI10_0@PAGE
	add	x10, x10, lJTI10_0@PAGEOFF
Ltmp2:
	adr	x8, Ltmp2
	ldrsw	x9, [x10, x11, lsl #2]
	add	x8, x8, x9
	br	x8
LBB10_2:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, eq
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_3:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, ne
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_4:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, lt
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_5:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, lo
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_6:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, ge
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_7:
	ldr	w8, [sp, #24]
	ldr	w9, [sp, #20]
	subs	w8, w8, w9
	cset	w8, hs
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
	b	LBB10_9
LBB10_8:
	mov	w8, #0
	and	w8, w8, #0x1
	strb	w8, [sp, #31]
LBB10_9:
	ldrb	w8, [sp, #31]
	and	w0, w8, #0x1
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
	.p2align	2
lJTI10_0:
	.long	LBB10_2-Ltmp2
	.long	LBB10_3-Ltmp2
	.long	LBB10_8-Ltmp2
	.long	LBB10_8-Ltmp2
	.long	LBB10_4-Ltmp2
	.long	LBB10_6-Ltmp2
	.long	LBB10_5-Ltmp2
	.long	LBB10_7-Ltmp2
                                        ; -- End function
	.globl	_alu                            ; -- Begin function alu
	.p2align	2
_alu:                                   ; @alu
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64                     ; =64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48                    ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	w0, [x29, #-8]
	stur	w1, [x29, #-12]
	stur	w2, [x29, #-16]
	mov	w8, #1
	and	w8, w3, w8
	sturb	w8, [x29, #-17]
	ldur	w8, [x29, #-16]
                                        ; kill: def $x8 killed $w8
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	subs	x8, x8, #7                      ; =7
	b.hi	LBB11_16
; %bb.1:
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	adrp	x10, lJTI11_0@PAGE
	add	x10, x10, lJTI11_0@PAGEOFF
Ltmp3:
	adr	x8, Ltmp3
	ldrsw	x9, [x10, x11, lsl #2]
	add	x8, x8, x9
	br	x8
LBB11_2:
	ldurb	w8, [x29, #-17]
	tbz	w8, #0, LBB11_4
; %bb.3:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	subs	w8, w8, w9
	str	w8, [sp, #12]                   ; 4-byte Folded Spill
	b	LBB11_5
LBB11_4:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	add	w8, w8, w9
	str	w8, [sp, #12]                   ; 4-byte Folded Spill
LBB11_5:
	ldr	w8, [sp, #12]                   ; 4-byte Folded Reload
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_6:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	and	w9, w9, #0x1f
	lsl	w8, w8, w9
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_7:
	ldur	w9, [x29, #-8]
	ldur	w10, [x29, #-12]
	mov	w8, #0
	subs	w9, w9, w10
	csinc	w8, w8, wzr, ge
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_8:
	ldur	w9, [x29, #-8]
	ldur	w10, [x29, #-12]
	mov	w8, #0
	subs	w9, w9, w10
	csinc	w8, w8, wzr, hs
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_9:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	eor	w8, w8, w9
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_10:
	ldurb	w8, [x29, #-17]
	tbz	w8, #0, LBB11_12
; %bb.11:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	and	w9, w9, #0x1f
	asr	w8, w8, w9
	str	w8, [sp, #8]                    ; 4-byte Folded Spill
	b	LBB11_13
LBB11_12:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	and	w9, w9, #0x1f
	lsr	w8, w8, w9
	str	w8, [sp, #8]                    ; 4-byte Folded Spill
LBB11_13:
	ldr	w8, [sp, #8]                    ; 4-byte Folded Reload
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_14:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	orr	w8, w8, w9
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_15:
	ldur	w8, [x29, #-8]
	ldur	w9, [x29, #-12]
	and	w8, w8, w9
	stur	w8, [x29, #-4]
	b	LBB11_17
LBB11_16:
	ldur	w9, [x29, #-16]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.5@PAGE
	add	x0, x0, l_.str.5@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_panic
	stur	wzr, [x29, #-4]
LBB11_17:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64                     ; =64
	ret
	.cfi_endproc
	.p2align	2
lJTI11_0:
	.long	LBB11_2-Ltmp3
	.long	LBB11_6-Ltmp3
	.long	LBB11_7-Ltmp3
	.long	LBB11_8-Ltmp3
	.long	LBB11_9-Ltmp3
	.long	LBB11_10-Ltmp3
	.long	LBB11_14-Ltmp3
	.long	LBB11_15-Ltmp3
                                        ; -- End function
	.globl	_step                           ; -- Begin function step
	.p2align	2
_step:                                  ; @step
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #224                    ; =224
	stp	x29, x30, [sp, #208]            ; 16-byte Folded Spill
	add	x29, sp, #208                   ; =208
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, _pc@PAGE
	ldr	w8, [x8, _pc@PAGEOFF]
	cbnz	w8, LBB12_2
; %bb.1:
	mov	w8, #0
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
	b	LBB12_76
LBB12_2:
	adrp	x8, _pc@PAGE
	ldr	w0, [x8, _pc@PAGEOFF]
	bl	_mem_load_int32_t
	stur	w0, [x29, #-8]
	adrp	x8, _flag_dump_regs_each_step@PAGE
	ldrb	w8, [x8, _flag_dump_regs_each_step@PAGEOFF]
	tbz	w8, #0, LBB12_4
; %bb.3:
	bl	_dump_regs
LBB12_4:
	adrp	x8, _pc@PAGE
	ldr	w9, [x8, _pc@PAGEOFF]
                                        ; implicit-def: $x8
	mov	x8, x9
	str	x8, [sp, #96]                   ; 8-byte Folded Spill
	ldur	w9, [x29, #-8]
                                        ; implicit-def: $x8
	mov	x8, x9
	str	x8, [sp, #104]                  ; 8-byte Folded Spill
	ldur	w0, [x29, #-8]
	mov	w1, #32
	bl	_as_binary_str
	ldr	x11, [sp, #96]                  ; 8-byte Folded Reload
	ldr	x10, [sp, #104]                 ; 8-byte Folded Reload
	mov	x8, x0
	adrp	x0, l_.str.6@PAGE
	add	x0, x0, l_.str.6@PAGEOFF
	mov	x9, sp
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	bl	_printf
	ldur	w8, [x29, #-8]
	and	w8, w8, #0x7f
	sturb	w8, [x29, #-9]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #12
	and	w8, w8, #0x7
	sturb	w8, [x29, #-10]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #7
	and	w8, w8, #0x1f
	sturb	w8, [x29, #-11]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #15
	and	w8, w8, #0x1f
	sturb	w8, [x29, #-12]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #20
	and	w8, w8, #0x1f
	sturb	w8, [x29, #-13]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #25
	sturb	w8, [x29, #-14]
	ldur	w8, [x29, #-8]
	lsr	w0, w8, #20
	mov	w1, #12
	stur	w1, [x29, #-92]                 ; 4-byte Folded Spill
	bl	_sign_extend
	ldur	w1, [x29, #-92]                 ; 4-byte Folded Reload
	stur	w0, [x29, #-20]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #7
	and	w8, w8, #0x1f
	ldur	w9, [x29, #-8]
	lsr	w9, w9, #25
	orr	w0, w8, w9, lsl #5
	bl	_sign_extend
	stur	w0, [x29, #-24]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #12
	lsl	w8, w8, #12
	stur	w8, [x29, #-28]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #8
	and	w9, w8, #0xf
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #25
	and	w8, w8, #0x3f
	lsl	w8, w8, #5
	orr	w8, w8, w9, lsl #1
	ldur	w9, [x29, #-8]
	lsr	w9, w9, #7
	and	w9, w9, #0x1
	orr	w8, w8, w9, lsl #11
	ldur	w9, [x29, #-8]
	lsr	w9, w9, #31
	orr	w0, w8, w9, lsl #12
	mov	w1, #13
	bl	_sign_extend
	stur	w0, [x29, #-32]
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #21
	and	w9, w8, #0x3ff
	ldur	w8, [x29, #-8]
	lsr	w8, w8, #20
	and	w8, w8, #0x1
	lsl	w8, w8, #11
	orr	w8, w8, w9, lsl #1
	ldur	w9, [x29, #-8]
	lsr	w9, w9, #12
	and	w9, w9, #0xff
	orr	w8, w8, w9, lsl #19
	ldur	w9, [x29, #-8]
	lsr	w9, w9, #31
	orr	w0, w8, w9, lsl #20
	mov	w1, #21
	bl	_sign_extend
	stur	w0, [x29, #-36]
	ldurb	w9, [x29, #-14]
	mov	w8, #0
	subs	w9, w9, #32                     ; =32
	stur	w8, [x29, #-88]                 ; 4-byte Folded Spill
	b.ne	LBB12_13
; %bb.5:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #51                     ; =51
	b.ne	LBB12_7
; %bb.6:
	ldurb	w8, [x29, #-10]
	mov	w9, #1
	str	w9, [sp, #92]                   ; 4-byte Folded Spill
	cbz	w8, LBB12_12
LBB12_7:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #51                     ; =51
	b.ne	LBB12_9
; %bb.8:
	ldurb	w9, [x29, #-10]
	mov	w8, #1
	subs	w9, w9, #5                      ; =5
	str	w8, [sp, #92]                   ; 4-byte Folded Spill
	b.eq	LBB12_12
LBB12_9:
	ldurb	w9, [x29, #-9]
	mov	w8, #0
	subs	w9, w9, #19                     ; =19
	str	w8, [sp, #88]                   ; 4-byte Folded Spill
	b.ne	LBB12_11
; %bb.10:
	ldurb	w8, [x29, #-10]
	subs	w8, w8, #5                      ; =5
	cset	w8, eq
	str	w8, [sp, #88]                   ; 4-byte Folded Spill
LBB12_11:
	ldr	w8, [sp, #88]                   ; 4-byte Folded Reload
	str	w8, [sp, #92]                   ; 4-byte Folded Spill
LBB12_12:
	ldr	w8, [sp, #92]                   ; 4-byte Folded Reload
	stur	w8, [x29, #-88]                 ; 4-byte Folded Spill
LBB12_13:
	ldur	w8, [x29, #-88]                 ; 4-byte Folded Reload
	and	w8, w8, #0x1
	sturb	w8, [x29, #-37]
	ldurb	w0, [x29, #-12]
	bl	_read_reg
	stur	w0, [x29, #-44]
	ldurb	w0, [x29, #-13]
	bl	_read_reg
	stur	w0, [x29, #-48]
	adrp	x8, _pc@PAGE
	ldr	w9, [x8, _pc@PAGEOFF]
	stur	w9, [x29, #-52]
	ldr	w8, [x8, _pc@PAGEOFF]
	add	w8, w8, #4                      ; =4
	stur	w8, [x29, #-56]
	mov	w8, #48879
	movk	w8, #57005, lsl #16
	stur	w8, [x29, #-60]
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #111                    ; =111
	str	w8, [sp, #84]                   ; 4-byte Folded Spill
	b.eq	LBB12_16
; %bb.14:
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #103                    ; =103
	str	w8, [sp, #84]                   ; 4-byte Folded Spill
	b.eq	LBB12_16
; %bb.15:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #3                      ; =3
	cset	w8, eq
	str	w8, [sp, #84]                   ; 4-byte Folded Spill
LBB12_16:
	ldr	w8, [sp, #84]                   ; 4-byte Folded Reload
	and	w8, w8, #0x1
	sturb	w8, [x29, #-61]
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #51                     ; =51
	str	w8, [sp, #80]                   ; 4-byte Folded Spill
	b.eq	LBB12_20
; %bb.17:
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #19                     ; =19
	str	w8, [sp, #80]                   ; 4-byte Folded Spill
	b.eq	LBB12_20
; %bb.18:
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #55                     ; =55
	str	w8, [sp, #80]                   ; 4-byte Folded Spill
	b.eq	LBB12_20
; %bb.19:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #23                     ; =23
	cset	w8, eq
	str	w8, [sp, #80]                   ; 4-byte Folded Spill
LBB12_20:
	ldr	w8, [sp, #80]                   ; 4-byte Folded Reload
	and	w8, w8, #0x1
	sturb	w8, [x29, #-62]
	ldurb	w9, [x29, #-9]
	mov	w8, #1
	subs	w9, w9, #111                    ; =111
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
	b.eq	LBB12_22
; %bb.21:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #103                    ; =103
	cset	w8, eq
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
LBB12_22:
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	and	w8, w8, #0x1
	sturb	w8, [x29, #-63]
	ldur	w8, [x29, #-44]
	stur	w8, [x29, #-68]
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #51                     ; =51
	b.ne	LBB12_24
; %bb.23:
	ldur	w8, [x29, #-48]
	str	w8, [sp, #72]                   ; 4-byte Folded Spill
	b	LBB12_25
LBB12_24:
	ldur	w8, [x29, #-20]
	str	w8, [sp, #72]                   ; 4-byte Folded Spill
LBB12_25:
	ldr	w8, [sp, #72]                   ; 4-byte Folded Reload
	stur	w8, [x29, #-72]
	ldurb	w8, [x29, #-10]
	stur	w8, [x29, #-76]
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #55                     ; =55
	b.ne	LBB12_27
; %bb.26:
	ldur	w8, [x29, #-28]
	stur	w8, [x29, #-72]
	stur	wzr, [x29, #-68]
	stur	wzr, [x29, #-76]
LBB12_27:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #23                     ; =23
	b.ne	LBB12_29
; %bb.28:
	ldur	w8, [x29, #-52]
	stur	w8, [x29, #-68]
	ldur	w8, [x29, #-28]
	stur	w8, [x29, #-72]
	stur	wzr, [x29, #-76]
LBB12_29:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #103                    ; =103
	b.ne	LBB12_31
; %bb.30:
	ldur	w8, [x29, #-56]
	stur	w8, [x29, #-60]
	ldur	w8, [x29, #-44]
	stur	w8, [x29, #-68]
	ldur	w8, [x29, #-20]
	stur	w8, [x29, #-72]
	ldur	w8, [x29, #-44]
                                        ; implicit-def: $x11
	mov	x11, x8
	ldur	w9, [x29, #-20]
                                        ; implicit-def: $x8
	mov	x8, x9
	ldur	w9, [x29, #-44]
	ldur	w10, [x29, #-20]
	add	w10, w9, w10
	adrp	x0, l_.str.7@PAGE
	add	x0, x0, l_.str.7@PAGEOFF
	mov	x9, sp
	str	x11, [x9]
	str	x8, [x9, #8]
                                        ; implicit-def: $x8
	mov	x8, x10
	str	x8, [x9, #16]
	bl	_printf
	stur	wzr, [x29, #-76]
LBB12_31:
	ldurb	w8, [x29, #-9]
	subs	w8, w8, #111                    ; =111
	b.ne	LBB12_33
; %bb.32:
	ldur	w8, [x29, #-56]
	stur	w8, [x29, #-60]
	ldur	w8, [x29, #-52]
	stur	w8, [x29, #-68]
	ldur	w8, [x29, #-36]
	stur	w8, [x29, #-72]
	stur	wzr, [x29, #-76]
LBB12_33:
	ldur	w0, [x29, #-44]
	ldur	w1, [x29, #-48]
	ldurb	w2, [x29, #-10]
	bl	_branch
	mov	w8, #1
	and	w8, w0, w8
	sturb	w8, [x29, #-77]
	ldur	w0, [x29, #-68]
	ldur	w1, [x29, #-72]
	ldur	w2, [x29, #-76]
	ldurb	w8, [x29, #-37]
	and	w3, w8, #0x1
	bl	_alu
	stur	w0, [x29, #-84]
	ldurb	w8, [x29, #-9]
	str	w8, [sp, #68]                   ; 4-byte Folded Spill
	subs	w8, w8, #3                      ; =3
	b.eq	LBB12_35
; %bb.34:
	ldr	w8, [sp, #68]                   ; 4-byte Folded Reload
	subs	w8, w8, #35                     ; =35
	b.eq	LBB12_43
	b	LBB12_50
LBB12_35:
	ldurb	w8, [x29, #-10]
                                        ; kill: def $x8 killed $w8
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	subs	x8, x8, #5                      ; =5
	b.hi	LBB12_42
; %bb.36:
	ldr	x11, [sp, #56]                  ; 8-byte Folded Reload
	adrp	x10, lJTI12_0@PAGE
	add	x10, x10, lJTI12_0@PAGEOFF
Ltmp4:
	adr	x8, Ltmp4
	ldrsw	x9, [x10, x11, lsl #2]
	add	x8, x8, x9
	br	x8
LBB12_37:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-20]
	add	w0, w8, w9
	bl	_mem_load_int32_t
	stur	w0, [x29, #-60]
	b	LBB12_42
LBB12_38:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-20]
	add	w0, w8, w9
	bl	_mem_load_int16_t
	sxth	w8, w0
	stur	w8, [x29, #-60]
	b	LBB12_42
LBB12_39:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-20]
	add	w0, w8, w9
	bl	_mem_load_int8_t
	sxtb	w8, w0
	stur	w8, [x29, #-60]
	b	LBB12_42
LBB12_40:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-20]
	add	w0, w8, w9
	bl	_mem_load_int16_t
	and	w8, w0, #0xffff
	stur	w8, [x29, #-60]
	b	LBB12_42
LBB12_41:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-20]
	add	w0, w8, w9
	bl	_mem_load_int8_t
	and	w8, w0, #0xff
	stur	w8, [x29, #-60]
LBB12_42:
	b	LBB12_50
LBB12_43:
	ldurb	w8, [x29, #-10]
	str	w8, [sp, #52]                   ; 4-byte Folded Spill
	cbz	w8, LBB12_46
; %bb.44:
	ldr	w8, [sp, #52]                   ; 4-byte Folded Reload
	subs	w8, w8, #1                      ; =1
	b.eq	LBB12_47
; %bb.45:
	ldr	w8, [sp, #52]                   ; 4-byte Folded Reload
	subs	w8, w8, #2                      ; =2
	b.eq	LBB12_48
	b	LBB12_49
LBB12_46:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-24]
	add	w0, w8, w9
	ldur	w8, [x29, #-48]
	sxtb	w1, w8
	bl	_mem_store_int8_t
	b	LBB12_49
LBB12_47:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-24]
	add	w0, w8, w9
	ldur	w8, [x29, #-48]
	sxth	w1, w8
	bl	_mem_store_int16_t
	b	LBB12_49
LBB12_48:
	ldur	w8, [x29, #-44]
	ldur	w9, [x29, #-24]
	add	w0, w8, w9
	ldur	w1, [x29, #-48]
	bl	_mem_store_int32_t
LBB12_49:
LBB12_50:
	ldurb	w8, [x29, #-9]
	str	w8, [sp, #48]                   ; 4-byte Folded Spill
	subs	w8, w8, #15                     ; =15
	b.eq	LBB12_61
; %bb.51:
	ldr	w8, [sp, #48]                   ; 4-byte Folded Reload
	subs	w8, w8, #99                     ; =99
	b.eq	LBB12_62
; %bb.52:
	ldr	w8, [sp, #48]                   ; 4-byte Folded Reload
	subs	w8, w8, #115                    ; =115
	b.ne	LBB12_65
; %bb.53:
	ldurb	w8, [x29, #-10]
	cbnz	w8, LBB12_59
; %bb.54:
	adrp	x8, ___stdoutp@GOTPAGE
	ldr	x8, [x8, ___stdoutp@GOTPAGEOFF]
	ldr	x0, [x8]
	ldur	w9, [x29, #-20]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x1, l_.str.8@PAGE
	add	x1, x1, l_.str.8@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
	ldur	w8, [x29, #-20]
	str	w8, [sp, #44]                   ; 4-byte Folded Spill
	cbz	w8, LBB12_57
; %bb.55:
	ldr	w8, [sp, #44]                   ; 4-byte Folded Reload
	subs	w8, w8, #1                      ; =1
	b.ne	LBB12_58
; %bb.56:
	adrp	x0, l_.str.9@PAGE
	add	x0, x0, l_.str.9@PAGEOFF
	bl	_panic
LBB12_57:
	mov	w8, #0
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
	b	LBB12_76
LBB12_58:
	b	LBB12_60
LBB12_59:
	adrp	x8, ___stdoutp@GOTPAGE
	ldr	x8, [x8, ___stdoutp@GOTPAGEOFF]
	ldr	x8, [x8]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	ldurb	w0, [x29, #-10]
	mov	w1, #3
	bl	_as_binary_str
	mov	x8, x0
	ldr	x0, [sp, #32]                   ; 8-byte Folded Reload
	adrp	x1, l_.str.10@PAGE
	add	x1, x1, l_.str.10@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
LBB12_60:
	b	LBB12_65
LBB12_61:
	b	LBB12_65
LBB12_62:
	ldurb	w8, [x29, #-77]
	tbz	w8, #0, LBB12_64
; %bb.63:
	ldur	w8, [x29, #-52]
	ldur	w9, [x29, #-32]
	add	w8, w8, w9
	stur	w8, [x29, #-56]
LBB12_64:
LBB12_65:
	ldurb	w8, [x29, #-63]
	tbz	w8, #0, LBB12_67
; %bb.66:
	ldur	w0, [x29, #-84]
	bl	_write_pc
	b	LBB12_68
LBB12_67:
	ldur	w0, [x29, #-56]
	bl	_write_pc
LBB12_68:
	ldurb	w8, [x29, #-61]
	tbnz	w8, #0, LBB12_70
; %bb.69:
	ldurb	w8, [x29, #-62]
	tbz	w8, #0, LBB12_75
LBB12_70:
	ldurb	w8, [x29, #-11]
	cbz	w8, LBB12_75
; %bb.71:
	ldurb	w8, [x29, #-62]
	tbz	w8, #0, LBB12_73
; %bb.72:
	ldurb	w0, [x29, #-11]
	ldur	w1, [x29, #-84]
	bl	_write_reg
	b	LBB12_74
LBB12_73:
	ldurb	w0, [x29, #-11]
	ldur	w1, [x29, #-60]
	bl	_write_reg
LBB12_74:
LBB12_75:
	mov	w8, #1
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
LBB12_76:
	ldurb	w8, [x29, #-1]
	and	w0, w8, #0x1
	ldp	x29, x30, [sp, #208]            ; 16-byte Folded Reload
	add	sp, sp, #224                    ; =224
	ret
	.cfi_endproc
	.p2align	2
lJTI12_0:
	.long	LBB12_39-Ltmp4
	.long	LBB12_38-Ltmp4
	.long	LBB12_37-Ltmp4
	.long	LBB12_42-Ltmp4
	.long	LBB12_41-Ltmp4
	.long	LBB12_40-Ltmp4
                                        ; -- End function
	.p2align	2                               ; -- Begin function sign_extend
_sign_extend:                           ; @sign_extend
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #8]
	str	w1, [sp, #4]
	ldr	w8, [sp, #8]
	ldr	w10, [sp, #4]
	mov	w9, #1
	subs	w10, w10, #1                    ; =1
	lsl	w9, w9, w10
	and	w8, w8, w9
	cbz	w8, LBB13_2
; %bb.1:
	ldr	w8, [sp, #8]
	ldr	w10, [sp, #4]
	mov	w9, #32
	subs	w10, w9, w10
	mov	w9, #-2147483648
	asr	w9, w9, w10
	orr	w8, w8, w9
	str	w8, [sp, #12]
	b	LBB13_3
LBB13_2:
	ldr	w8, [sp, #8]
	str	w8, [sp, #12]
LBB13_3:
	ldr	w0, [sp, #12]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16                    ; =16
	sub	sp, sp, #560                    ; =560
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	str	wzr, [sp, #292]
	str	w0, [sp, #288]
	str	x1, [sp, #280]
	ldr	x8, [sp, #280]
	ldr	x8, [x8, #8]
	str	x8, [sp, #104]
	ldr	x0, [sp, #104]
	adrp	x1, l_.str.11@PAGE
	add	x1, x1, l_.str.11@PAGEOFF
	bl	_fopen
	str	x0, [sp, #96]
	mov	x8, #-1
	str	x8, [sp, #88]
	adrp	x8, ___stdoutp@GOTPAGE
	ldr	x8, [x8, ___stdoutp@GOTPAGEOFF]
	ldr	x0, [x8]
	mov	x1, #0
	str	x1, [sp, #40]                   ; 8-byte Folded Spill
	bl	_setbuf
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x1, [sp, #40]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	bl	_setbuf
	mov	x0, #65536
	bl	_malloc
	adrp	x8, _mem@PAGE
	str	x0, [x8, _mem@PAGEOFF]
	ldr	x8, [sp, #96]
	cbnz	x8, LBB14_3
; %bb.1:
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	ldr	x8, [sp, #104]
	adrp	x1, l_.str.12@PAGE
	add	x1, x1, l_.str.12@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-24]
	subs	x8, x8, x9
	b.ne	LBB14_25
; %bb.2:
	mov	w0, #-1
	add	sp, sp, #560                    ; =560
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #32             ; 16-byte Folded Reload
	ret
LBB14_3:
	ldr	x8, [sp, #104]
	adrp	x0, l_.str.13@PAGE
	add	x0, x0, l_.str.13@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	x0, [sp, #96]
	add	x1, sp, #112                    ; =112
	bl	_readelf
	ldr	x8, [sp, #192]
	adrp	x0, l_.str.14@PAGE
	add	x0, x0, l_.str.14@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	x8, [sp, #192]
	mov	x0, x8
	bl	_write_pc
	str	xzr, [sp, #80]
	str	wzr, [sp, #76]
LBB14_4:                                ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #76]
	ldrh	w9, [sp, #224]
	subs	w8, w8, w9
	b.ge	LBB14_11
; %bb.5:                                ;   in Loop: Header=BB14_4 Depth=1
	ldr	x0, [sp, #96]
	ldr	w1, [sp, #76]
	add	x2, sp, #80                     ; =80
	add	x3, sp, #88                     ; =88
	add	x4, sp, #112                    ; =112
	bl	_readelfsectioni
	str	x0, [sp, #64]
	ldr	x8, [sp, #64]
	cbnz	x8, LBB14_7
; %bb.6:                                ;   in Loop: Header=BB14_4 Depth=1
	b	LBB14_10
LBB14_7:                                ;   in Loop: Header=BB14_4 Depth=1
	ldr	x8, [sp, #80]
	adrp	x0, l_.str.15@PAGE
	add	x0, x0, l_.str.15@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	x8, [sp, #256]
                                        ; kill: def $w8 killed $w8 killed $x8
	tbz	w8, #1, LBB14_9
; %bb.8:                                ;   in Loop: Header=BB14_4 Depth=1
	ldr	x11, [sp, #80]
	ldr	x10, [sp, #88]
	ldr	x8, [sp, #248]
	adrp	x0, l_.str.16@PAGE
	add	x0, x0, l_.str.16@PAGEOFF
	mov	x9, sp
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	bl	_printf
	adrp	x8, _mem@PAGE
	ldr	x8, [x8, _mem@PAGEOFF]
	ldr	x9, [sp, #248]
	mov	x10, #2147483648
	subs	x9, x9, x10
	add	x0, x8, x9
	ldr	x1, [sp, #64]
	ldr	x2, [sp, #240]
	mov	x3, #-1
	bl	___memcpy_chk
LBB14_9:                                ;   in Loop: Header=BB14_4 Depth=1
	adrp	x0, l_.str.17@PAGE
	add	x0, x0, l_.str.17@PAGEOFF
	bl	_printf
LBB14_10:                               ;   in Loop: Header=BB14_4 Depth=1
	ldr	w8, [sp, #76]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #76]
	b	LBB14_4
LBB14_11:
	adrp	x0, l_.str.18@PAGE
	add	x0, x0, l_.str.18@PAGEOFF
	bl	_printf
	adrp	x8, _flag_dump_initial_mem@PAGE
	ldrb	w8, [x8, _flag_dump_initial_mem@PAGEOFF]
	tbz	w8, #0, LBB14_17
; %bb.12:
	ldr	x0, [sp, #104]
	bl	_basename
	mov	x8, x0
	add	x0, sp, #296                    ; =296
	str	x0, [sp, #24]                   ; 8-byte Folded Spill
	mov	w1, #0
	mov	x2, #256
	adrp	x3, l_.str.19@PAGE
	add	x3, x3, l_.str.19@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	___sprintf_chk
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	adrp	x0, l_.str.20@PAGE
	add	x0, x0, l_.str.20@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	x0, [sp, #24]                   ; 8-byte Folded Reload
	adrp	x1, l_.str.21@PAGE
	add	x1, x1, l_.str.21@PAGEOFF
	bl	_fopen
	str	x0, [sp, #56]
	str	wzr, [sp, #52]
LBB14_13:                               ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #52]
	subs	w8, w8, #4, lsl #12             ; =16384
	b.ge	LBB14_16
; %bb.14:                               ;   in Loop: Header=BB14_13 Depth=1
	ldr	x0, [sp, #56]
	adrp	x8, _mem@PAGE
	ldr	x8, [x8, _mem@PAGEOFF]
	ldrsw	x9, [sp, #52]
	ldr	w9, [x8, x9, lsl #2]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x1, l_.str.22@PAGE
	add	x1, x1, l_.str.22@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
; %bb.15:                               ;   in Loop: Header=BB14_13 Depth=1
	ldr	w8, [sp, #52]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #52]
	b	LBB14_13
LBB14_16:
	ldr	x0, [sp, #56]
	bl	_fclose
	adrp	x0, l_.str.23@PAGE
	add	x0, x0, l_.str.23@PAGEOFF
	bl	_printf
LBB14_17:
LBB14_18:                               ; =>This Inner Loop Header: Depth=1
	bl	_step
	tbnz	w0, #0, LBB14_24
; %bb.19:
	adrp	x8, _pc@PAGE
	ldr	w8, [x8, _pc@PAGEOFF]
	cbnz	w8, LBB14_21
; %bb.20:
	adrp	x0, l_.str.24@PAGE
	add	x0, x0, l_.str.24@PAGEOFF
	bl	_printf
	mov	w0, #0
	bl	_exit
LBB14_21:
	mov	w0, #10
	bl	_read_reg
	cbz	w0, LBB14_23
; %bb.22:
	mov	w0, #10
	bl	_read_reg
	asr	w8, w0, #1
	str	w8, [sp, #48]
	bl	_dump_regs
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	ldr	w9, [sp, #48]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x1, l_.str.25@PAGE
	add	x1, x1, l_.str.25@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
	mov	w0, #-1
	bl	_exit
LBB14_23:
	adrp	x0, l_.str.26@PAGE
	add	x0, x0, l_.str.26@PAGEOFF
	bl	_printf
	mov	w0, #0
	bl	_exit
LBB14_24:                               ;   in Loop: Header=BB14_18 Depth=1
	b	LBB14_18
LBB14_25:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
	.globl	_dump_regs                      ; -- Begin function dump_regs
	.p2align	2
_dump_regs:                             ; @dump_regs
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32                    ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
LBB15_1:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB15_3 Depth 2
	ldur	w8, [x29, #-4]
	subs	w8, w8, #8                      ; =8
	b.ge	LBB15_11
; %bb.2:                                ;   in Loop: Header=BB15_1 Depth=1
	stur	wzr, [x29, #-8]
LBB15_3:                                ;   Parent Loop BB15_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	w8, [x29, #-8]
	subs	w8, w8, #4                      ; =4
	b.ge	LBB15_9
; %bb.4:                                ;   in Loop: Header=BB15_3 Depth=2
	ldur	w9, [x29, #-4]
	mov	w8, #4
	mul	w8, w8, w9
	ldur	w9, [x29, #-8]
	add	w8, w8, w9
	stur	w8, [x29, #-12]
	ldur	w9, [x29, #-12]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.27@PAGE
	add	x0, x0, l_.str.27@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldur	w0, [x29, #-12]
	bl	_read_reg
	cbz	w0, LBB15_6
; %bb.5:                                ;   in Loop: Header=BB15_3 Depth=2
	ldur	w0, [x29, #-12]
	bl	_read_reg
	mov	x10, x0
	adrp	x0, l_.str.28@PAGE
	add	x0, x0, l_.str.28@PAGEOFF
	mov	x9, sp
                                        ; implicit-def: $x8
	mov	x8, x10
	str	x8, [x9]
	bl	_printf
	b	LBB15_7
LBB15_6:                                ;   in Loop: Header=BB15_3 Depth=2
	ldur	w0, [x29, #-12]
	bl	_read_reg
	mov	x10, x0
	adrp	x0, l_.str.29@PAGE
	add	x0, x0, l_.str.29@PAGEOFF
	mov	x9, sp
                                        ; implicit-def: $x8
	mov	x8, x10
	str	x8, [x9]
	bl	_printf
LBB15_7:                                ;   in Loop: Header=BB15_3 Depth=2
	ldur	w0, [x29, #-12]
	bl	_read_reg
	mov	x10, x0
	adrp	x0, l_.str.30@PAGE
	add	x0, x0, l_.str.30@PAGEOFF
	mov	x9, sp
                                        ; implicit-def: $x8
	mov	x8, x10
	str	x8, [x9]
	bl	_printf
; %bb.8:                                ;   in Loop: Header=BB15_3 Depth=2
	ldur	w8, [x29, #-8]
	add	w8, w8, #1                      ; =1
	stur	w8, [x29, #-8]
	b	LBB15_3
LBB15_9:                                ;   in Loop: Header=BB15_1 Depth=1
	adrp	x0, l_.str.17@PAGE
	add	x0, x0, l_.str.17@PAGEOFF
	bl	_printf
; %bb.10:                               ;   in Loop: Header=BB15_1 Depth=1
	ldur	w8, [x29, #-4]
	add	w8, w8, #1                      ; =1
	stur	w8, [x29, #-4]
	b	LBB15_1
LBB15_11:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_mem                            ; @mem
.zerofill __DATA,__common,_mem,8,3
	.globl	_pc                             ; @pc
.zerofill __DATA,__common,_pc,4,2
	.globl	__regfile                       ; @_regfile
.zerofill __DATA,__common,__regfile,128,2
	.globl	_flag_dump_regs_each_step       ; @flag_dump_regs_each_step
.zerofill __DATA,__common,_flag_dump_regs_each_step,1,0
	.section	__DATA,__data
	.globl	_flag_dump_initial_mem          ; @flag_dump_initial_mem
_flag_dump_initial_mem:
	.byte	1                               ; 0x1

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"new PC value is unaligned address 0x%08x"

l_.str.1:                               ; @.str.1
	.asciz	"tried to write %d to invalid register number %d"

l_.str.2:                               ; @.str.2
	.asciz	"memory address 0x%08x out of bounds for type int8_t"

l_.str.3:                               ; @.str.3
	.asciz	"memory address 0x%08x out of bounds for type int16_t"

l_.str.4:                               ; @.str.4
	.asciz	"memory address 0x%08x out of bounds for type int32_t"

l_.str.5:                               ; @.str.5
	.asciz	"unknown arith operator %d"

l_.str.6:                               ; @.str.6
	.asciz	"\033[32mPC: %08x\033[0m %08x %s \n"

l_.str.7:                               ; @.str.7
	.asciz	"JALR: rs1v is %d, imm is %d, jump target will be %d\n"

l_.str.8:                               ; @.str.8
	.asciz	"\033[31mECALL %d\n\033[0m"

l_.str.9:                               ; @.str.9
	.asciz	"EBREAK"

l_.str.10:                              ; @.str.10
	.asciz	"\033[31munknown SYSTEM func: %s\n\033[0m"

l_.str.11:                              ; @.str.11
	.asciz	"r"

l_.str.12:                              ; @.str.12
	.asciz	"Couldn't open file %s\n"

l_.str.13:                              ; @.str.13
	.asciz	"Loading ELF file %s...\n"

l_.str.14:                              ; @.str.14
	.asciz	"Entry address is %08x (setting PC)"

l_.str.15:                              ; @.str.15
	.asciz	"\tSection \"%s\"... "

l_.str.16:                              ; @.str.16
	.asciz	"loaded (%llu bytes to 0x%08x)"

l_.str.17:                              ; @.str.17
	.asciz	"\n"

l_.str.18:                              ; @.str.18
	.asciz	"ELF loading finished\n\n"

l_.str.19:                              ; @.str.19
	.asciz	"verilog/tests/%s.hex"

l_.str.20:                              ; @.str.20
	.asciz	"Dumping memory to %s\n"

l_.str.21:                              ; @.str.21
	.asciz	"w"

l_.str.22:                              ; @.str.22
	.asciz	"%08x\n"

l_.str.23:                              ; @.str.23
	.asciz	"Done\n"

l_.str.24:                              ; @.str.24
	.asciz	"\033[35mExecution stopped because PC is now zero.\n\033[0m"

l_.str.25:                              ; @.str.25
	.asciz	"\033[36m  Test %d failed\n\033[0m"

l_.str.26:                              ; @.str.26
	.asciz	"\033[32mSuccess!\n\033[0m"

l_.str.27:                              ; @.str.27
	.asciz	" x%02d:"

l_.str.28:                              ; @.str.28
	.asciz	"\033[1m\033[31m %08x \033[0m"

l_.str.29:                              ; @.str.29
	.asciz	"\033[31m %08x \033[0m"

l_.str.30:                              ; @.str.30
	.asciz	"\033[34m%-11d \033[0m"

l_.str.31:                              ; @.str.31
	.asciz	"\033[1m\033[31mpanic: %s\n\033[0m"

.subsections_via_symbols

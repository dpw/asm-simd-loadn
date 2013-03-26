.section .rodata
.balign 16
.table:
        # No entry for len = 0
        .int 0x80808000, 0x80808080, 0x80808080, 0x80808080 # len = 1
        .int 0x80800100, 0x80808080, 0x80808080, 0x80808080 # len = 2
        .int 0x80020100, 0x80808080, 0x80808080, 0x80808080 # len = 3
        .int 0x03020100, 0x80808080, 0x80808080, 0x80808080 # len = 4
        .int 0x03020100, 0x80808004, 0x80808080, 0x80808080 # len = 5
        .int 0x03020100, 0x80800504, 0x80808080, 0x80808080 # len = 6
        .int 0x03020100, 0x80060504, 0x80808080, 0x80808080 # len = 7

.text
.globl loadn
loadn:
        pushl %esi
        pushl %edi
        movl 12(%esp), %esi
        movl 16(%esp), %ecx

        # BEGIN INTERESTING CODE

        pxor %xmm6, %xmm6
        testl %ecx, %ecx
        jz 1f

        # Put the low 3 bits of esi into every byte of xmm5
        movl %esi, %edx
        andl $7, %edx
        movd %edx, %xmm5
        pshufb %xmm6, %xmm5

        movl %esi, %edi
        movl $0xfffffff8, %eax
        addl %ecx, %edi
        shll $4, %ecx
        decl %edi
        paddb (.table-16)(%ecx), %xmm5 # Add the right table entry into xmm5
        andl %eax, %edi # The address of the last byte, rounded down to 8 bytes
        andl %esi, %eax # esi rounded down to 8 bytes

        # Load the first aligned 8-byte chunk of the data into the bottom
        # half of xmm6
        movq (%eax), %xmm6

        # Load the last aligned 8-byte chunk of the data into the top
	# half of xmm6.
        movhpd (%edi), %xmm6

        # If the data crossed a 8-byte boundary, then we have now
	# simply loaded 16 bytes into xmm6.  If the data did not cross
	# an 8-byte boundary, then we have loaded the same 8 bytes into
	# the top and bottom halves of xmm6, avoiding the possibility of
	# a page fault, and we will not use the top half anyway.  Now we
        # use the adjusted table entry from xmm5 to move the bytes we want
        # to the start of xmm6.
        pshufb %xmm5, %xmm6
1:

        # END INTERESTING CODE

        movl 20(%esp), %edi
        movdqu %xmm6, (%edi)
        popl %edi
        popl %esi
        ret



section .text

global LineToAsm
extern SetPixel

;eax
;ebx - pimg
;ecx
;edx
;edi
;esi
;[ebp + 8] - pImg
;[ebp + 12] - x
;[ebp + 16] - y
;[ebp - 4] - ai
;[ebp - 8] - cy
;[ebp - 12] - xi

%macro pushRegisters 0
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx
	push 	edi
	push 	esi
	pushf
%endmacro

%macro popRegisters 0
	popf
	pop 	esi
	pop 	edi
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
%endmacro




LineToAsm:
	push	ebp
	mov		ebp, esp
	sub		esp, 12
	
	
	push	ebx
	
	mov		esi, [ebp + 8]					;esi = pImg
	
	xor		ebx, ebx
	inc		ebx								;ebx = xi = 1
	
	mov		eax, [ebp + 12]					;eax = x
	sub		eax, [esi + 12]					;eax = dx = x - cx

	jge		dx_greater_eq_zero
	
	neg		ebx								;ebx = xi = -1
	neg		eax								;eax = -dx
	
dx_greater_eq_zero:
	


	xor		ecx, ecx		
	inc		ecx								;ecx = yi = 1
	
	mov		edx, [ebp + 16]					;edx = y
	sub		edx, [esi + 16]					;edx = dy = y - cy
	jge		dy_greater_eq_zero
	

	neg		ecx								;ecx = yi = -1
	neg		edx								;edx = -dy
	
	
dy_greater_eq_zero:

;wywolanie SetPixel
	mov		[ebp - 12], ebx					;[ebp - 12] : xi	
	
	pushRegisters

	mov		edi, [esi + 16]					;set cy
	push	edi
	mov		[ebp - 8], edi					;[ebp - 8] = cy
	
	mov		edi, [esi + 12]					;set cx
	push	edi
	mov		[ebp - 4], edi
	
	push	esi								;set pImg
	call	SetPixel						;set function in C
	add		esp, 12
	popRegisters
	
	cmp		eax, edx
	jle		dx_less_eq_dy
	
;;;;;dx > dx
;horizontal drawing

;edi - free
;dx - eax
;dy - edx
	mov		edi, edx						;edi - dy
	shl		edi, 1							;edi = 2 * dy = bi
	
	sub		edx, eax
	shl		edx, 1							;ai = edx = (dy - dx) * 2
	mov		[ebp - 4], edx					;[ebp - 4] = ai
	
	sub		eax, edi
	neg		eax								;d = eax
	
	mov		edx, [esi + 12]					;edx = cx
	mov		ebx, [esi + 16]					;ebx = cy
	
compare_while_cx_neq_x:
	cmp		edx, [ebp + 12]					;cx != x
	je		end
	
	add		edx, [ebp - 12]					;cx += xi
	
	cmp		eax, 0
	jl		d_less_0_horizontal
	
;d_greater_eq_0:
	add		ebx, ecx						;cy += yi
	add		eax, [ebp - 4]					;d += ai
	
	pushRegisters
	
	push	ebx								;set cy
	push	edx								;set cx
	push	esi
	
	call	SetPixel
	add		esp, 12
	popRegisters
	
	jmp		compare_while_cx_neq_x
	
d_less_0_horizontal:	
	
	
	add		eax, edi
	
	pushRegisters
	push	ebx								;set cy
	push	edx								;set cx
	push	esi
	call	SetPixel
	add		esp, 12
	popRegisters
	
	jmp		compare_while_cx_neq_x




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dx_less_eq_dy:	
;vertical drawing
;dx - eax
;dy - edx
	mov		edi, eax
	shl		edi, 1;							;edi = 2 * dx = bi
	
	sub		eax, edx						;eax = dx - dy
	shl		eax, 1							;eax = (dx - dy ) * 2 = ai
	mov		[ebp - 4], eax					;[ebp - 4] = ai
	
	sub		edx, edi
	neg		edx								;edx = d = (bi - dy)
	
	mov		eax, [esi + 12]					;eax = cx
	mov		ebx, [esi + 16]					;ebx = cy
	
compare_while_cy_neq_y:
	cmp		ebx, [ebp + 16]
	je		end
	
	add		ebx, ecx						;cy += yi
	cmp		edx, 0
	
	jl		d_less_0_vertical
	
	add		eax, [ebp - 12]					;cx += xi 
	add		edx, [ebp - 4]					;d += ai
	
	
	pushRegisters
	push	ebx								;set cy
	push	eax								;set cx
	push	esi								;set pImg
	call	SetPixel
	add		esp, 12
	popRegisters
	
	jmp		compare_while_cy_neq_y
	
d_less_0_vertical:	
	add		edx, edi						;d += bi
	pushRegisters
	
	push	ebx								;set cy
	push	eax								;set cx
	push	esi								;set pImg
	call	SetPixel
	add		esp, 12
	popRegisters
	

	jmp		compare_while_cy_neq_y
	
end:
	
	pop		ebx
	
	mov		eax, [ebp + 12]					;pImg->cX = x
	mov		[esi + 12], eax					
	
	mov		eax, [ebp + 16]					;pImg->cY = y
	mov		[esi + 16], eax
	
	mov		eax, esi						;returns adress of pImg

	mov		esp, ebp
	pop		ebp
	ret

;typedef struct
;{
;	int width, height;					// 8
;	unsigned char* pImg;				// 4
;	int cX, cY;							// 8
;	int col;
;} imgInfo;
	
	












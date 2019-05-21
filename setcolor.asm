
section .text
global SetColorAsm



;(imgInfo* pImg, int col)

;[ebp + 8] - pImg
;[ebp + 12] - col


SetColorAsm:
	push	ebp
	mov		ebp, esp
	
	push	ebx
	
	
	mov		ebx, [ebp + 8]			;ebx - adress of pImg
	mov		eax, [ebp + 12]
	
	
	xor		ecx, ecx				;ecx - result
	cmp		eax, 0
	je		jump
	
	inc		ecx
jump:	
	
	mov 	[ebx + 20], ecx			;pImg->col = eax
	
	mov		eax, ebx				;returns *pImg

	pop 	ebx
	
	mov		esp, ebp
	pop		ebp
	ret
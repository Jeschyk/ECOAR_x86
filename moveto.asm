
section .text
global MoveToAsm

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


;[ebp + 8] - *img
;[ebp + 12] - x
;[ebp + 16] - y

MoveToAsm:
	push	ebp
	mov		ebp, esp
	
	push	ebx
	mov		ebx, [ebp + 8]
	
check_x:
	mov		eax, [ebp + 12]			;eax = x
	
	cmp		eax, 0
	jl		check_y
	
	mov		ecx, [ebx]				;ecx = pImg->width
	cmp		eax, ecx
	jge		check_y
	
	mov		[ebx + 12], eax			;pImg->cX = x
	
check_y:	
	mov		eax, [ebp + 16]			;eax = y
	
	cmp		eax, 0
	jl		end
	
	mov		ecx, [ebx + 4]			;ecx = pImg->hight
	cmp		eax, ecx
	jge		end
	
	mov		[ebx + 16], eax			;pImg->cY = y
	
end:
	
	mov		eax, ebx

	pop		ebx
	
	mov		esp, ebp
	pop		ebp
	ret



;imgInfo* MoveTo(imgInfo* pImg, int x, int y)
;{
;	if (x >= 0 && x < pImg->width)
;		pImg->cX = x;
;	if (y >= 0 && y < pImg->height)
;		pImg->cY = y;
;	return pImg;
;}

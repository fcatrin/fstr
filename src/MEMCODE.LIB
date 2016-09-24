SetError7       db      'Allocation error: '
		db      'Memory control blocks destroyed.$'
SetError8       db      'Allocation error: '
		db      'Insufficient memory.$'
SetError9       db      'Allocation error: '
		db      'Invalid memory block adress.$'

SetUnknown      db      'Unknown allocation error.$'

SetBlock        proc far
		mov     ah,4ah
		int     21h
		jc      SetBlockError
		ret
SetBlockError:
		push    ax
		mov     ax,0003h
		int     10h
		pop     ax

		cmp     ax,7
		jz      Set10
		cmp     ax,8
		jz      Set20
		cmp     ax,9
		jz      Set30
		lea     dx,SetUnknown
		jmp     short SetBlockPrint
Set10:          lea     dx,SetError7
		jmp     short SetBlockPrint
Set20:          lea     dx,SetError8
		jmp     short SetBlockPrint
Set30:          lea     dx,SetError9

SetBlockPrint:  mov     ax,seg SetError7
		mov     ds,ax
		mov     ah,9
		int     21h
		mov     ax,4c00h
		int     21h
		endp

Allocate        proc  far
		mov     ah,48h
		int     21h
		jc      AllocateError
		ret
AllocateError:
		push    ax
		mov     ax,0003h
		int     10h
		pop     ax

		cmp     ax,7
		jz      Allo10
		cmp     ax,8
		jz      Allo20
		lea     dx,SetUnknown
		jmp     short AllocatePrint
Allo10:         lea     dx,SetError7
		jmp     short AllocatePrint
Allo20:         lea     dx,SetError8

AllocatePrint:  mov     ax,seg SetError7
		mov     ds,ax
		mov     ah,9
		int     21h
		mov     ax,4c00h
		int     21h
		endp

DeAllocate      proc far
		mov     ah,49h
		int     21h
		jc      DeAlloError
		ret
DeAlloError:
		push    ax
		mov     ax,0003h
		int     10h
		pop     ax

		cmp     ax,7
		jz      DeA10
		cmp     ax,9
		jz      DeA20
		lea     dx,SetUnknown
		jmp     short DeAlloPrint
DeA10:          lea     dx,SetError7
		jmp     short DeAlloPrint
DeA20:          lea     dx,SetError9

DeAlloPrint:    mov     ax,seg SetError7
		mov     ds,ax
		mov     ah,9
		int     21h
		mov     ax,4c00h
		int     21h
		endp



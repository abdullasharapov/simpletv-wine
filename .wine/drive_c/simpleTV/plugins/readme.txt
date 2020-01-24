//--------------------------------------------------------------
/*VSG*/
original libpostproc_plugin crashed (corrupt rsp in mmx2 code) - bithack used 
original                      changed 
push rsp                -->   push rax
movd esp,mmxX           -->   mov eax,mmxX
cmp  rpl,[offset]       -->   nop; cmp al,[offset] 
pop rsp                 -->   pop rax
//--------------------------------------------------------------
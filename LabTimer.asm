#include "msp430.h"			

;------------------------------------------------------------------------------
	ORG	01100h	
        


INIT:	mov.w	#0A00h,SP		
	mov.w	#WDTPW+WDTHOLD,&WDTCTL	
  
	bis.b	#0FFh,&P2DIR		
       
        bis.b   #00001100b, P1IE
        bis     #GIE,SR
        mov.w   #MC_1|ID_3|TASSEL_2|TACLR,&TACTL
        bis.w   #GIE,SR                   ; Enable interrupts (just TACCR0)
        mov.w   #47500,&TACCR0		  
        mov.w   #CCIE,&TACCTL0
        push    SR

        

main:			
	mov.b	#000h,P2OUT		
        mov.b   #000h,R13		
        mov.b   #000h,R10

        


loop:				
        jmp     $
        

;------------------------------------------------------------------------------
button:
         bit.b	#01h,P4IN	
         jnz    hop			
         xor.b  #0FFh, R13											    
         jmp    p1w												     
         													     
hop:     bit.b  #02h,P4IN											
         jnz    p1w			
         mov.b  #00000000b,P2OUT	

         
        


p1w:     CLR.b  P1IFG
         RETI

timer:  xor.b  #0FFh, R10
        bit.b   #0FFh,R13
        jz      t1w
        bit.b   #0FFh,R10
        jz      t1w   
        pop SR
        inc.b P2OUT
        push SR				
        dadd.b #00d, P2OUT
t1w:    RETI				


        
        
        reti
        
        ORG     0FFECh			
        DC16    timer
        
        ORG	0FFFEh			
	DW	INIT			

        ORG     0FFE8h
        DW      przycisk


        
        
  
  
        reti
	
        END
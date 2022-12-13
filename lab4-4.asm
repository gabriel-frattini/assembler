; This program reads an ascii value from address FC and
; translates the alphabetical character to morse code.


Inport        EQU	          $FC
Utport	      EQU	          $FB
DelayC1	      EQU	          $5		          
DelayC2	      EQU	          $2	

              ORG		  $FF
            
              FCB		  Main
              ORG		  $20

; This function is called when an invalid character is entered. 
; It blinks the output port with a pattern of 10101010 
; (which doesn't correspond to any Morse code character) to indicate that an error has occurred.

Error:	         LDA		  #$AB
                 STA		  Utport
                 JSR		  Delay1s

; Main sets up the stack and calls the ReadAscii function to read in a character from the input port. 
; It then checks if the character is valid (i.e. in the range 'A' to 'Z') and, 
; if it is, it looks up the corresponding Morse code in the MorseCode table and stores it in the Count variable. 
; It then calls the BlinkLight function to blink the output port using the Morse code pattern.

Main:	          LDSP	          #$20
                  LDA		  #$00		
                  STA		  Utport

reset:	          JSR		  ReadAscii
	          SUBA	          #$41

                  BMI		  Error			
                  CMPA	          #$1A
                  BPL		  Error		
                  LSLA		
                  PSHA
                  LDX		  #MorseCode
                  LDA		  A,X
                  STA		  Count
                  PULA
                  INCA
                  LDA		  A,X
			
CountNotZero:     JSR		  BlinkLight
                  LSLA
                  DEC		  Count
                  BNE		  CountNotZero	
	      	  BRA		  Main


; This function reads in a single character from the input port and returns it in the accumulator (A) register. 
; It waits for the input port to be set to 1 before returning, 
; to ensure that a complete character has been received.

ReadAscii:	  LDA		Inport
		  LSRA				
	          BCC		ReadAscii	
		  RTS	

BlinkLight:	  PSHA
	          LDX		#$FF
	          STX		Utport
	          LSLA			
		  BCS		BL_4s	

BL_1s:		  JSR		Delay1s
	          JMP		BL_retur

BL_4s:		  LDA	        #$04
BL_decr:          JSR	        Delay1s
		  DECA	
		  BNE		BL_decr	
		  JMP		BL_retur 

BL_retur:         LDX		#00
                  STX		Utport
                  JSR		Delay1s
                  PULA
                  RTS
	
; Orsakar en fördröjning på ungefär 1s i simulatorn (vid snabb exekveringshastighet)
; Ändrar inga register
Delay1s:
		 PSHA
		 PSHX
		 PSHC
		 LDX	       #DelayC2
Delay1s_loop2:
		 LDA	       #DelayC1
Delay1s_loop:
		 DECA
		 BNE	       Delay1s_loop
		 LEAX	       -1,X
		 CMPX	       #0
		 BNE	       Delay1s_loop2
		 PULC
		 PULX
		 PULA
		 RTS

Count:
	         RMB	       1

MorseCode:
		 FCB	       2,%01000000 ;'A'
		 FCB	       4,%10000000 ;'B'
		 FCB	       4,%10100000 ;'C'
		 FCB	       3,%10000000 ;'D'
		 FCB	       1,%00000000 ;'E'
		 FCB	       4,%00100000 ;'F'
		 FCB	       3,%11000000 ;'G'
		 FCB	       4,%00000000 ;'H'
		 FCB	       2,%00000000 ;'I'
		 FCB	       4,%01110000 ;'J'
		 FCB	       3,%10100000 ;'K'
		 FCB	       4,%01000000 ;'L'
		 FCB	       2,%11000000 ;'M'
		 FCB	       2,%10000000 ;'N'
		 FCB	       3,%11100000 ;'O'
		 FCB	       4,%01100000 ;'P'
		 FCB	       4,%11010000 ;'Q'
		 FCB	       3,%01000000 ;'R'
		 FCB	       3,%00000000 ;'S'
		 FCB	       1,%10000000 ;'T'
		 FCB	       3,%00100000 ;'U'
		 FCB	       4,%00010000 ;'V'
		 FCB	       3,%01100000 ;'W'
		 FCB	       4,%10010000 ;'X'
		 FCB	       4,%10110000 ;'Y'
		 FCB	       4,%11000000 ;'Z'

	
	
	
	
	

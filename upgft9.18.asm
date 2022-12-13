; This program reads an 8 bit number and displays numbers 1-9 on a 7 segment display.
;
DIPSWITCH:      EQU     $FC
SEGMENT7:       EQU     $FB
SEG_ERROR:      EQU     $79
                ORG     $20
DisplaySegE:    LDX     #seg_table
DisplaySegE_1:  LDA     DIPSWITCH
                CMPA    #10
                BCS     DisplaySegE_2
                LDA     #SEG_ERROR
                JMP     DisplaySegE_3
DisplaySegE_2:  LDA     A,X
DisplaySegE_3:  STA     SEGMENT7
                JMP     DisplaySegE_1


                ORG     $E0
seg_table:      FCB     $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$67
                ORG     $FF
                FCB     $20


; This program emulates a running light in a bargraph by ligthing one light at a time.
;
LED:        EQU       $FB
            ORG       $20

start:      LDSP      #$20
            JSR       main
            JMP       start

main:       ANDCC     #0
            LDA       #1

main_1:     STA       LED
            ROLA      
            JSR       Delay
            JMP       main_1

Delay:      PSHA
            PSHC
            LDA       $FF

Delay_1:    DECA
            BNE       Delay_1
            PULC
            PULA
            RTS
            ORG       $FF
            FCB       start

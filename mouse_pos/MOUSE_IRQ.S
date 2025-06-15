 NLS
*
*#--------------->
* MOUSE_IRQ
* TEST
* P. DUBOIN
* 17 JUIN 2025
* LISA 2.5
*#--------------->
;
;
;----------------------------------------------------------
; Gestion souris + affichage coordonnées DOS 3.3 (slot 4)
;---------------------------------------------------------
;
 OBJ $800
 ORG $800
;
PTR EPZ 6
;
MS_SLOT EPZ 0 ; n° de slot (4)
XLoVar EPZ 1 ; stockage X LSB
XHiVar EPZ 2 ; stockage X MSB
YLoVar EPZ 3 ; stockage Y LSB
YHiVar EPZ 4 ; stockage Y MSB
;
IRQLOC EQU $3FE;
;
HOME EQU $FC58 ; CLEAR SCREEN
PRBYTE EQU $FDDA ; PRINT HEX BYTE
COUT EQU $FDED ; PRINT ASCII CHAR
;
;
GO:
;
 JMP MAIN
;
MOUSE:
 PHA
 LDA (PTR),Y
 LDX #$C4
 LDY #$40
 STA JUMP+1
 STX JUMP+2
 PLA
;
JMP:
 JMP $0000
;
;
MAIN:
;
 LDA #$C4
 STA PTR+1
 LDY #$19
 JSR MOUSE
;
; set the interrupt handler address to $0330
;
 LDA #MSIRQ
 STA IRQLOC
 LDA /MSIRQ
 STA IRQLOC+1
;
 LDY #$12
 LDA #$08
 JMP MOUSE
;
MSIRQ:
 JSR COORD
 STA $C030
 LDA $45
 RTI
;
;------------------------------------------------------------------------------
; COORD : lit les “screen holes” et stocke en variables
;------------------------------------------------------------------------------
;
COORD:
 LDY MS_SLOT
 LDX #$78
 LDA $0478,Y ; X LSB
 STA XLoVar
 LDA $0578,Y ; X MSB
 STA XHiVar
 LDA $04F8,Y ; Y LSB
 STA YLoVar
 LDA $05F8,Y ; Y MSB
 STA YHiVar
 RTS
;
;------------------------------------------------------------------------------
; PTR_XY : affiche "X=hhhh Y=hhhh" en hex
;------------------------------------------------------------------------------
;
PTR_XY:
; "X="
 LDA #'X'
 JSR COUT
 LDA #'='
 JSR COUT
;
; XHiVar / XLoVar
 LDA XHiVar
 JSR PRBYTE
 LDA XLoVar
 JSR PRBYTE
;
; " Y="
 LDA #' '
 JSR COUT
 LDA #'Y'
 JSR COUT
 LDA #'='
 JSR COUT
;
; YHiVar / YLoVar
 LDA YHiVar
 JSR PRBYTE
 LDA YLoVar
 JSR PRBYTE
 LDA #$8D
 JMP COUT
;
;
 END

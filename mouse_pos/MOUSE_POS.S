 NLS
*
*#--------------->
* MOUSE_DUMP
* NON FONCTIONNEL
* P. DUBOIN
* 17 MAI 2025
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
MS_SLOT EPZ 0 ; n° de slot (4)
XLoVar EPZ 1 ; stockage X LSB
XHiVar EPZ 2 ; stockage X MSB
YLoVar EPZ 3 ; stockage Y LSB
YHiVar EPZ 4 ; stockage Y MSB
OrigIRQ EPZ 5 ; sauv. vecteur IRQ original ($FFFE/$FFFF)
;
HOME EQU $FC58 ; CLEAR SCREEN
PRBYTE EQU $FDDA ; PRINT HEX BYTE
COUT EQU $FDED ; PRINT ASCII CHAR
;
;
GO:
 JSR HOME
 JSR INITMSE
MAIN:
 JSR COORD
 JSR PTR_XY
 JMP MAIN
;
;
;----------------------------------------------------------
; InitMouseSystem : sauvegarde vecteur, installe ISR, configure souris
;----------------------------------------------------------
INITMSE:
;--- sauvegarde vecteur IRQ
 LDA $FFFE ; bas du vecteur
 STA OrigIRQ
 LDA $FFFF ; haut du vecteur
 STA OrigIRQ+1
;
;--- installer notre ISR
;
 LDA #MSIRQ
 STA $FFFE
 LDA /MSIRQ
 STA $FFFF
;
;--- souris slot 4 en interruption (mvt + bouton)
;
 PHP
 SEI ; désactiver IRQ
 LDA #$04 ; slot n = 4
 STA MS_SLOT
;
;
; SETMOUSE: mode: bit0=on, bit1=mvt int, bit2=btn int => $07
;
 LDA #$07
 LDX #$C4 ; $Cn form
 LDY #$40 ; $n0 form (4*16)
 JSR $C412 ; SETMOUSE
;
;
; INITMOUSE
;
 LDX #$C4
 LDY #$40
 JSR $C419
;
;
; CLAMPMOUSE X (A=0)
 LDA #$00
 LDX #$C4
 LDY #$40
 JSR $C417
;
; CLAMPMOUSE Y (A=1)
 LDA #$01
 LDX #$C4
 LDY #$40
 JSR $C417
;
 PLP
 RTS
;
;------------------------------------------------------------------------------
; ISR souris : servi à chaque VBL IRQ générée par la souris
;------------------------------------------------------------------------------
;
MSIRQ:
 PHA
 JSR $C413 ; SERVEMOUSE, C=0 si IRQ souris
 BCS NOMSE
 JSR $C414 ; READMOUSE
NOMSE PLA
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

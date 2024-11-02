 NLS
;
*#---------------->
* HAS MOUSE
* PASCAL DUBOIN
* Le 25 Juin 2023
* LISA 2.5 — 6502
*#---------------->
;
;
; Localiser le firmware de la souris
; Recherche par slot en recherchant
; les octets d'identification de la souris :
;
;  $Cn05 = $38 — $Cn07 = $18
;  $Cn0B = $01 — $Cn0C = $20
;  $CnFB = $D6
;
; VARS ZPAGE
;
PTR EPZ 4
MSLOT EPZ 6
CN EPZ 7
N0 EPZ 8
;
; ROM
;
HOME EQU $FC58
PRBYTE EQU $FDDA
;
;
 ORG $800
 OBJ $800
;
;
FIND:
 JSR HOME
 LDA #0
 STA PTR
 STA MSLOT
 LDA #$C8
 STA PTR+1
 LDX #$08
;
NXT_SLOT:
 DEX
 BEQ BYE
 DEC PTR+1
;
 LDY #5
 LDA (PTR),Y
 CMP #$38
 BNE NXT_SLOT
;
 LDY #7
 LDA (PTR),Y
 CMP #$18
 BNE NXT_SLOT
;
 LDY #$0B
 LDA (PTR),Y
 CMP #$01
 BNE NXT_SLOT
;
 INY
 LDA (PTR),Y
 CMP #$20
 BNE NXT_SLOT
;
 LDY #$FB
 LDA (PTR),Y
 CMP #$D6
 BNE NXT_SLOT
;
BYE:
 TXA
 ASL
 ASL
 ASL
 ASL
 STA MSLOT
 LDA PTR+1
 STA CN
 STX N0
 JMP PRBYTE
;
 END

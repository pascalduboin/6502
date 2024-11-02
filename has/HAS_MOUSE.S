 NLS
*
*#--------------->
* HAS_80COLS
* SCAN SLOTS
* FOR 80 COLS CARDS
*
* P. DUBOIN
* 1 NOV 2024
* LISA 2.5
*
* $Cn05 = $38
* $Cn07 = $18
* $Cn0B = $01
* $Cn0C = $8x
* (High nibble is $8
* low nibble is
* device-specific)
*#--------------->
*
*
;
** ZPAGE
PTR EPZ 6
COL_80 EPZ 8
;
** ROM
HOME EQU $FC58
PRBYTE EQU $FDDA
;
 ORG $800
 OBJ $800
;
HAS_80C:
 JSR HOME
 LDA #0
 STA PTR
 LDX #7
;
NXT_80:
 TXA
 ORA #$C0
 STA PTR+1
;
 LDY #5
 LDA (PTR),Y
 CMP #$38
 BNE NO_80
;
 LDY #7
 LDA (PTR),Y
 CMP #$18
 BNE NO_80
;
 LDY #$0B
 LDA (PTR),Y
 CMP #1
 BNE NO_80
;
 INY
 LDA (PTR),Y
 AND #$F0
 CMP #$80
 BEQ HAS_80
;
NO_80:
 DEX
 BNE NXT_80
;
HAS_80:
 STX COL_80
 TXA
 JMP PRBYTE
;
 END

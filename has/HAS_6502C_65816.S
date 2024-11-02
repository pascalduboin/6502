 NLS
*
*#--------------->
* HAS_65C
*
* TEST THE
* PROCESSOR
* MODEL
* 6502C OR
* 65816
*
* P. DUBOIN
* 1 NOV 2024
* LISA 2.5
*
* FLAG VALUE
* SIGN (minus) 6502
* CARRY (clear) 65C02
* CARRY (set) 65816
*
*#--------------->
*
;
** ZPAGE
PTR EPZ 6
MASK EPZ 8
DSK_LST EPZ 9
;
 ORG $800
 OBJ $800
;
HAS_65C:
 SED
 LDA #$99
 CLC
 ADC #1
 BMI BY_65 ; Bug in 6502 causes sign flag not to clear.
;
 CLC
 HEX FB ; XCE opcode = 65C02 NOP.
 BCC BY_65 ; 6502C
 HEX FB ; XCE
 SEC ; flag as 65816.
;
BY_65:
 CLD
 RTS
;
 END

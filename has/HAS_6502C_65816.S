 NLS
*
*#--------------->
* HAS_6502C/65816
*
* P. DUBOIN
* 1 NOV 2024
* LISA 2.5
*
* FLAG VALUE
* SIGN (minus) 6502
* SIGN (plus) 65C02, 65816
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
HAS_02C:
 SED ; Use known bugs to determine processor type.
 LDA #$99
 CLC
 ADC #1
 BMI DONE ; Bug in 6502 causes sign flag not to clear.
;
 CLC
 XCE ; XCE instruction is a 65C02 NOP.
 BCC DONE ; If it was a 65816, carry would have set.
;
 XCE ; restore 65816 to 6502 emulation mode.
 SEC ; flag processor as 65816.
;
DONE:
 CLD
 RTS
;
 END

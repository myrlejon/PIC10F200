; the purpose of this program is to be able to blink a LED
processor 10F200
#include <xc.inc>

; CONFIG
    CONFIG  OSC = IntRC           ; Oscillator Selection bits (internal RC oscillator)
    ; CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled)
    CONFIG  CP = OFF              ; Code Protection bit (Code protection off)
    CONFIG  MCLRE = OFF           ; GP3/MCLR Pin Function Select bit (GP3/MCLR pin function is MCLR)
    ORG 0x0000
INIT:
    MOVLW ~(1 << GP1) ; set GP1 as output
    TRIS GPIO
    BSF GPIO, GP1 ;this line is where we set GP1 output high to light the LED
LOOP:
    GOTO LOOP                          ; loop forever
END ; Needed to end the program.

; psect rstVector, delta=2
; reset_vector:
;     goto main

; main:
;     goto main
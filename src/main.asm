processor 10F200

; CONFIG

;;; - triple ;;; = my own comments

;;;;;;;;;;;;;;;

; inc files:
; C:\Program Files\Microchip\xc8\v2.32\pic\include

#include <xc.inc>

CONFIG  OSC = IntRC           ; Oscillator Selection bits (internal RC oscillator)
; CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled)
CONFIG  CP = OFF              ; Code Protection bit (Code protection off)
CONFIG  MCLRE = OFF           ; GP3/MCLR Pin Function Select bit (GP3/MCLR pin function is MCLR)

; User guide chapter 4.2: delta means 2 bytes per memory address (14 bit opcodes for PIC12F683)
; this psect just holds the reset vector
;;; PIC10F200 has 12 bit opcodes, should still be 2 bytes per memory address

psect rstVector, delta=2
reset_vector:
    goto main

psect code, delta=2
main:
    ;;; Timer0 Clock Source Select (page 16) bit gets cleared in OPTION_REG (page 23)
    ; clear T0CS bit of OPTION reg to enable it as a GPIO
    movlw       0b11010001
    ;;; load option register (page 46)
    option      
    ; init gpio
    ;;; (page 33 in PIC12F683) indicates that GPIO is an 6-bit wide, bidirectional port.
    ;;; (page 20 in PIC10F200) indicates that GPIO is an 8-bit I/O register where only the lower 4 bits are used.
    ;;; change from 0b111000 > 0b00000000 (weak pull up is always on so pulling low will enable?).
    movlw       0b00000000 ; 0, 1, and 2 are outputs
    tris        GPIO
    goto        main_loop

main_loop:
    btfsc       GPIO, 2
    goto        main_loop_off
    goto        main_loop_on


main_loop_on:
    bsf         GPIO, 2
    goto        main_loop_delay
main_loop_off:
    bcf         GPIO, 2
    goto        main_loop_delay
    

main_loop_delay:
    movlw       9
    movwf       0x10 ; reg 0x10

main_loop_on_loop:
    decfsz      0x10, f
    goto        main_loop_on_loop
    goto        main_loop_end
    
main_loop_end:
    nop 
    goto        main_loop


; need to specify END directive to fix warning: "warning: (528) no start record; entry point defaults to zero"
end reset_vector

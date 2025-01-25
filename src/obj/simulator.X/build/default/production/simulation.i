# 1 "simulation.asm"
# 1 "<built-in>" 1
# 1 "simulation.asm" 2
main:
    ;;; Timer0 Clock Source Select (page 16) bit gets cleared in OPTION_REG (page 23)
    ; clear T0CS bit of OPTION reg to enable it as a GPIO
    movlw 0b11010001
    ;;; load option register (page 46)
    option
    ; init gpio
    ;;; (page 33 in PIC12F683) indicates that GPIO is an 6-bit wide, bidirectional port.
    ;;; (page 20 in PIC10F200) indicates that GPIO is an 8-bit I/O register where only the lower 4 bits are used.
    ;;; change from 0b111000 > 0b00000000 (weak pull up is always on so pulling low will enable?).
    movlw 0b01000000 ; 0, 1, and 2 are outputs
    tris GPIO
    goto main_loop


    ; general purpose registers 0x10 - 0x1Fh

main_loop:
    goto outer_loop_setup_a
    goto main_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

outer_loop_setup_a:
    bcf GPIO, 1

    clrf 0x10
    clrf 0x11
    clrf 0x12

    movlw 0xFF
    movwf 0x10
    movlw 0xFF
    movwf 0x11
    movlw 0x02 ; runs once
    movwf 0x12

    goto outer_loop_a

outer_loop_a:
    decfsz 0x12, 1
    goto inner_loop_a

    movlw 0xFF
    movwf 0x11
    movlw 0x02
    movwf 0x12

    decfsz 0x10, 1
    goto outer_loop_a
    goto outer_loop_setup_b



inner_loop_a:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    decfsz 0x11, 1
    goto inner_loop_a
    goto loop_end_a

loop_end_a:
    ; movlw 0x01 ;flag to exit loop, decrease it once
    ; movwf 0x12
    goto outer_loop_a

;;;;;;;;;;;;;;;;;;;;;;;;;;;

outer_loop_setup_b:
    bsf GPIO, 1

    clrf 0x10
    clrf 0x11
    clrf 0x12


    movlw 0xFF
    movwf 0x10
    movlw 0xFF
    movwf 0x11
    movlw 0x02
    movwf 0x12

    goto outer_loop_b

outer_loop_b:
    decfsz 0x12, 1
    goto inner_loop_b

    movlw 0xFF
    movwf 0x11
    movlw 0x02
    movwf 0x12

    decfsz 0x10, 1
    goto outer_loop_b

    goto outer_loop_setup_a

inner_loop_b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    decfsz 0x11, 1
    goto inner_loop_b
    goto loop_end_b

loop_end_b:
    ; movlw 0x01 ;flag to exit loop, decrease it once
    ; movwf 0x12
    goto outer_loop_b

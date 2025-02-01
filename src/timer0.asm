processor 10F200

;;; press a button for 1 second to light up a LED. if the button press is less than 1 second then it should not light up.
;;; button press should be input, LED should be an output (2 IO's) 

; workflow - 

; step 1 -
; read input from button
; if reading from button is high, set GPIO high

; step 2 -
; read input from button
; if reading is high for one second, set GPIO high

; GP0 = button
; GP1 = LED

; inc files:
; C:\Program Files\Microchip\xc8\v2.32\pic\include

#include <xc.inc>

CONFIG  OSC = IntRC           ; Oscillator Selection bits (internal RC oscillator)
; CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled)
CONFIG  CP = OFF              ; Code Protection bit (Code protection off)
CONFIG  MCLRE = OFF           ; GP3/MCLR Pin Function Select bit (GP3/MCLR pin function is MCLR)

psect rstVector, delta=2
reset_vector:
    goto main

psect code, delta=2
main:
    movlw       0b00010001
    option      
    movlw       0b01000000
    tris        GPIO
    bcf         GPIO, 1
    goto        main_loop

main_loop:
    clrwdt
    goto        read_gp0
    goto        main_loop

read_gp0:
    btfsc       GPIO, 0     ; check if button is pressed down
    goto        button_pressed
    goto        main_loop

button_pressed:
    btfsc       GPIO, 1
    goto        clear_gp0

    call        delay
    call        delay
    call        delay
    
    btfss       GPIO, 1
    goto        set_gp0

    call        delay
    call        delay
    call        delay

    goto        main_loop

set_gp0:
    bsf         GPIO, 1
    goto        main_loop

clear_gp0:
    bcf         GPIO, 1
    goto        main_loop

delay:
    decfsz      0x10, 1
    goto        delay
    clrwdt                  ; WDT kicks must be frequent to avoid resets
    decfsz      0x11, 1
    goto        delay
    retlw       0

; button_pressed:
;     ; movwf       GPIO
;     bsf         GPIO, 1
;     btfss       GPIO, 1
;     bsf         GPIO, 1
;     bcf         GPIO, 1
;     retlw       0


end reset_vector
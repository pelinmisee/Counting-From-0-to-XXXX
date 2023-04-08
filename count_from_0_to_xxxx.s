.global _start
_start:
LDR R5, =HEXTABLE
LDR R6, =0xff200020
LDR R10, =0xfffec600
LDR R12, = 100000000
STR R12, [R10]
MOV R9, #0
LDR R11, =TEST_WORD
LDR R8, TEST_WORD
STR R8, [R11]


MAIN_LOOP:
//clear registers
MOV R1, #0  //birler basamagi
MOV R2, #0  //onlar basamagi
MOV R3, #0  //yüzler basamagi
MOV R4, #0  //binler basamagi

//CLEAR R0 CONTENT PUT NEW NUMBER INTO
MOV R0, R9 

find_binler:
SUBS R0, #1000
BMI put_zero_r4
ADD R4, #1
CMP R0, #1000
BPL find_binler
B find_yuzler

put_zero_r4:
ADD R0, #1000
MOV R4, #0

find_yuzler:
SUBS R0, #100
BMI put_zero_r3
ADD R3, #1
CMP R0, #100
BPL find_yuzler
B find_onlar

put_zero_r3:
ADD R0, #100
MOV R3, #0

find_onlar:
SUBS R0, #10
BMI put_zero_r2
ADD R2, #1
CMP R0, #10
BPL find_onlar
B find_birler

put_zero_r2:
ADD R0, #10
MOV R2, #0

find_birler:
CMP R0, #1
BMI put_zero_r1
MOV R1, R0
B load_bytes

put_zero_r1:
ADD R0, #1
MOV R1, #0

load_bytes:
LDRB R7, [R5,R1]

LDRB R7, [R5,R2]

LDRB R7, [R5,R3]

LDRB R7, [R5,R4]

LDRB R1, [R5, R1]
LDRB R2, [R5, R2]
LDRB R3, [R5, R3]
LDRB R4, [R5, R4]

LSL R4, R4, #8
ORR R4, R4, R3
LSL R4, R4, #8
ORR R4, R4, R2
LSL R4, R4, #8
ORR R4, R4, R1

STR R4, [R6]
B DO_DELAY

sub_loop:
// reset the timer flag
STR R12, [R10,#0xC]
ADD R9, R9, #1
CMP R9, R8
BNE MAIN_LOOP
B end

DO_DELAY:
// start the timer: E=1, I=0, A=0
MOV R12, #0b011
STR R12, [R10, #8]


SUB_LOOP:
LDR R12, [R10, #0xC]
ANDS R12, #1
BEQ SUB_LOOP
B sub_loop


end: B end

TEST_WORD: .word 899
HEXTABLE: .byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f
.end

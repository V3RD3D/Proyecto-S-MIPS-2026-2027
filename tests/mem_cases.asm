# Pruebas propias de memoria: lw/sw con desplazamiento positivo y negativo,
# lb/lbu de bytes con bit7=1 en dos posiciones distintas de la palabra,
# sb en los cuatro carriles y comprobacion con lw de que los otros bytes no cambian.
        .data
pal:    .word 0x7f80ff41, 0x12345678
buf:    .space 8

        .text
main:   la   $s0, pal
        lw   $a0, 0($s0)
        jal  ph
        lw   $a0, 4($s0)
        jal  ph
        lbu  $a0, 2($s0)             # 0xff, bit7=1
        jal  ph
        lb   $a0, 2($s0)             # 0xffffffff
        jal  ph
        lbu  $a0, 3($s0)             # 0x80, otra posicion con bit7=1
        jal  ph
        jal  nl

        lb   $a0, 3($s0)             # 0xffffff80
        jal  ph
        addi $t0, $zero, -1
        sw   $t0, 4($s0)             # sw con desplazamiento positivo
        lw   $a0, 4($s0)
        jal  ph
        addi $s1, $s0, 8
        addi $t0, $zero, 0x55
        sw   $t0, -4($s1)            # sw con desplazamiento negativo
        lw   $a0, -4($s1)
        jal  ph
        jal  nl

        la   $s2, buf
        addi $t0, $zero, 0x11
        sb   $t0, 0($s2)
        addi $t0, $zero, 0x22
        sb   $t0, 1($s2)
        addi $t0, $zero, 0x33
        sb   $t0, 2($s2)
        addi $t0, $zero, 0x44
        sb   $t0, 3($s2)
        lw   $a0, 0($s2)             # 0x44332211
        jal  ph
        jal  nl

        lui  $t1, 0xabcd
        ori  $t1, $t1, 0xef01
        sw   $t1, 4($s2)
        addi $t0, $zero, -1
        sb   $t0, 5($s2)             # cambia solo el byte 1
        lw   $a0, 4($s2)             # 0xabffef01
        jal  ph
        jal  nl

        addi $v0, $zero, 10
        syscall

ph:     add  $t3, $a0, $zero
        addi $t4, $zero, 8
phl:    srl  $t5, $t3, 28
        slti $t6, $t5, 10
        beq  $t6, $zero, pha
        addi $a0, $t5, 48
        j    phi
pha:    addi $a0, $t5, 87
phi:    addi $v0, $zero, 11
        syscall
        sll  $t3, $t3, 4
        addi $t4, $t4, -1
        bne  $t4, $zero, phl
        addi $a0, $zero, 32
        addi $v0, $zero, 11
        syscall
        jr   $ra

nl:     addi $a0, $zero, 10
        addi $v0, $zero, 11
        syscall
        jr   $ra

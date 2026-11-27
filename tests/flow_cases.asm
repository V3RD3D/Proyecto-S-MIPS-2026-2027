# Pruebas propias de control de flujo: beq y bne tomados y no tomados, salto hacia atras,
# j, jal/jr con procedimiento anidado que guarda $ra en la pila, syscall 11 y 10.
        .text
main:   addi $s0, $zero, 4
        addi $s1, $zero, 4
        addi $s2, $zero, 5

        beq  $s0, $s1, b1            # tomado
        jal  error
b1:     addi $a0, $zero, 1
        jal  ph
        beq  $s0, $s2, error         # no tomado
        addi $a0, $zero, 2
        jal  ph
        bne  $s0, $s2, b2            # tomado
        jal  error
b2:     addi $a0, $zero, 3
        jal  ph
        bne  $s0, $s1, error         # no tomado
        addi $a0, $zero, 4
        jal  ph
        jal  nl

        add  $s3, $zero, $zero       # bucle hacia atras: 1+2+3 = 6
        addi $t0, $zero, 1
bucle:  add  $s3, $s3, $t0
        addi $t0, $t0, 1
        slti $t1, $t0, 4
        bne  $t1, $zero, bucle
        add  $a0, $s3, $zero
        jal  ph
        jal  nl

        j    salto_j
        jal  error
salto_j:
        addi $a0, $zero, 7
        jal  ph
        la   $t6, destino
        jr   $t6
        jal  error
destino:
        addi $a0, $zero, 8
        jal  ph
        jal  nl

        addi $a0, $zero, 9           # outer(9) = 9 + inner(10) = 19
        jal  outer
        add  $a0, $v0, $zero
        jal  ph
        jal  nl

        addi $v0, $zero, 10
        syscall

error:  addi $a0, $zero, 33          # '!'
        jal  ph
        addi $v0, $zero, 10
        syscall

outer:  addi $sp, $sp, -8
        sw   $ra, 4($sp)
        sw   $a0, 0($sp)
        addi $a0, $a0, 1
        jal  inner
        lw   $a0, 0($sp)
        lw   $ra, 4($sp)
        addi $sp, $sp, 8
        add  $v0, $v0, $a0
        jr   $ra

inner:  addi $sp, $sp, -4
        sw   $ra, 0($sp)
        add  $v0, $a0, $zero
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra

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

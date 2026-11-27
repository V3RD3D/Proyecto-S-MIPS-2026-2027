# Pruebas propias: add/sub (positivos y negativos), and/or con unos en los 16 bits altos,
# slt/slti (resultado 1 y 0, caso con signo vs sin signo), sll/srl (shamt 0 y no 0,
# srl de negativo), addi con inmediato negativo, andi/ori con bit15=1, lui con bit15=1,
# li/addiu, move/addu y escritura en $zero.
        .text
main:   addi $s0, $zero, 7
        addi $s1, $zero, -9
        add  $a0, $s0, $s1           # positivo + negativo
        jal  ph
        sub  $a0, $s0, $s1           # positivo - negativo
        jal  ph
        sub  $a0, $s1, $s0           # negativo - positivo
        jal  ph
        jal  nl

        lui  $t0, 0x8000
        ori  $t0, $t0, 0x1234        # operandos con unos arriba
        addi $t1, $zero, 0x4321
        and  $a0, $t0, $t1
        jal  ph
        or   $a0, $t0, $t1
        jal  ph
        jal  nl

        addi $t2, $zero, -1          # 0xffffffff
        slt  $a0, $t2, $s0           # -1 < 7 -> 1 (sin signo daria 0)
        jal  ph
        slt  $a0, $s0, $t2           # 7 < -1 -> 0
        jal  ph
        slti $a0, $t2, 1             # -1 < 1 -> 1 (sin signo daria 0)
        jal  ph
        slti $a0, $s0, -1            # 7 < -1 -> 0
        jal  ph
        jal  nl

        sll  $a0, $s0, 0             # shamt = 0
        jal  ph
        sll  $a0, $s0, 5             # shamt != 0
        jal  ph
        srl  $a0, $t2, 0             # shamt = 0 sobre negativo
        jal  ph
        srl  $a0, $t2, 28            # negativo: entran ceros -> 0x0000000f
        jal  ph
        jal  nl

        addi $a0, $s0, -3            # inmediato negativo
        jal  ph
        andi $a0, $t2, 0x8000        # bit15=1, extension con ceros
        jal  ph
        ori  $a0, $zero, 0x8001      # bit15=1, extension con ceros
        jal  ph
        lui  $a0, 0x8001             # bit15=1
        jal  ph
        jal  nl

        li   $a0, 300                # MARS genera addiu
        jal  ph
        move $a0, $s1                # MARS genera addu
        jal  ph
        add  $zero, $s0, $s1         # escribir en $zero
        add  $a0, $zero, $zero       # debe seguir valiendo 0
        jal  ph
        jal  nl

        addi $v0, $zero, 10
        syscall

# imprime $a0 en hexadecimal (8 digitos) y un espacio
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

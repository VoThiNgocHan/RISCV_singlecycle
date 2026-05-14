.section .text
.globl _start

_start:
    lui     sp,0x7
    addi    sp,sp,0
    jal     x0,0xd4

    jal     ra,-0x160
    sw      ra,4(sp)

    addi    a0,x0,97
    jal     ra,-0x170
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,100
    jal     ra,-0x178
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,100
    jal     ra,-0x180
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,46
    jal     ra,-0x188
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,46
    jal     ra,-0x190
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,46
    jal     ra,-0x198
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a7,x0,0
    addi    t1,x0,0
    addi    t2,x0,0
    add     t0,t1,t2
    bne     a7,t0,0x84

    addi    a7,x0,10
    addi    t1,x0,2
    addi    t2,x0,8
    add     t0,t1,t2
    bne     a7,t0,0x9c

    lui     a7,0xffff8
    addi    a7,a7,0
    addi    t1,x0,0
    lui     t2,0xffff8
    addi    t2,t2,0
    add     t0,x0,t2
    bne     a7,t0,0xa0

    lui     a7,0x80008
    addi    a7,a7,-2
    lui     t1,0x80000
    addi    t1,t1,-1
    lui     t2,0x8
    addi    t2,t2,-1
    add     t0,t1,t2
    bne     a7,t0,0x94

    addi    a7,x0,0
    addi    t1,x0,-1
    addi    t2,x0,1
    add     t0,t1,t2
    bne     a7,t0,0x8c

    addi    a7,x0,59
    addi    t1,x0,11
    addi    t2,x0,12
    addi    t3,x0,13
    add     t0,t1,t2
    add     t0,t0,t3
    add     t0,t2,t0
    bne     a7,t0,0x88

    jal     x0,-0x22c

    sw      ra,0(sp)

    addi    a0,x0,46
    jal     ra,-0x20
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,46
    jal     ra,-0x28
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,46
    jal     ra,-0x30
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,80
    jal     ra,-0x38
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,65
    jal     ra,-0x40
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,83
    jal     ra,-0x48
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,83
    jal     ra,-0x50
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,13
    jal     ra,-0x58
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    addi    a0,x0,10
    jal     ra,-0x60
    lui     t0,0x10000
    addi    t0,t0,0
    sb      a0,0(t0)
    ret

    lw      ra,0(sp)
    ret
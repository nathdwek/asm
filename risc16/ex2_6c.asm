        movi    1, 0

        movi    2, 0

        mul     3, 1, 2
        addi    4, 2, 0
        halt
//Hardware implementation of more complex arithmetic and logic
//operations allows for faster execution and simpler code, as proven by this
//code and its benchmark.

//However this tendency is limited by the fact that providing those implementations
//renders the IC design more complex (and simply bigger), and eventually requires a
//larger instruction bus.

//The consequence of this is that the critical path in the CPU can become longer, which
//then reduces the maximal possible frequency and increases the delays (as well as the
//power consumption, amongst others). This is still a good tradeoff as long as it allows
//to reduce the instruction count by a sufficient factor (This exercice is a prime example,
//since the multiplications could previously take up to 500 cycles with IS0 and 150 with
//IS1. The speedup is huge) (and as long as this speedup is actually used in production code).

//However you thus cannot keep providing more and more hardware implementations of operations
//forever, since, as we explained, it would slow down the execution of smaller, more elementary
//operations. This is especially important since we know that a huge proportion of generated
//assembly code is simply mov, variations of addition and variation of branching, all of them
//elementary instructions.

//This tradeoff is one of the key elements in the CISC vs RISC comparison.

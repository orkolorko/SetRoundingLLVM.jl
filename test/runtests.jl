using SetRoundingLLVM
using Test

@testset "SetRoundingLLVM.jl" begin
    rnd = llvm_rounding()
    
    llvm_setrounding(RoundToZero)
    @test llvm_rounding() == RoundToZero

    llvm_setrounding(RoundUp)
    @test llvm_rounding() == RoundUp

    llvm_setrounding(RoundDown)
    @test llvm_rounding() == RoundDown

    llvm_setrounding(RoundNearest)
    @test llvm_rounding() == RoundNearest

    llvm_setrounding(rnd)

    x = 1.0
    x = llvm_setrounding(RoundUp) do
        x+eps(1.0)/2
    end
    @test x == nextfloat(1.0)

    x = 1.0
    x = llvm_setrounding(RoundDown) do
        x+eps(1.0)/2
    end
    @test x == 1.0

    x = 1.0
    x = llvm_setrounding(RoundNearest) do
        x+eps(1.0)/2
    end
    @test x == 1.0

    x = 1.0
    x = llvm_setrounding(RoundNearest) do
        x-eps(1.0)/2
    end
    @test x == prevfloat(1.0)

    x = -1.0
    x = llvm_setrounding(RoundToZero) do
        x-eps(1.0)/2
    end
    @test x == -1.0

    x = 1.0
    x = llvm_setrounding(RoundToZero) do
        x+eps(1.0)/2
    end
    @test x == 1.0

    a = 0.1; b = 0.3

    c = llvm_setrounding(RoundDown) do
        a + b
    end

    d = llvm_setrounding(RoundUp) do
        a + b
    end

    @test c == 0.39999999999999997
    @test d == 0.4

end
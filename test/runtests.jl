using SetRoundingLLVM
using Test

@testset "Testing Rounding" begin
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

@testset "Testing multithreading" begin
    N = Threads.nthreads()
    @info "Number of threads is $N"

    if N>1
        function testing_roundings_up(rounding::RoundingMode)
            x = 1.0
            x = llvm_setrounding(rounding) do
            x+eps(1.0)/2
            end
            return x
        end

        function testing_roundings_down(rounding::RoundingMode)
            x = 1.0
            x = llvm_setrounding(rounding) do
            x-eps(1.0)/4
            end
            return x
        end


        a = SetRoundingLLVM.from_llvm.([Int32(i%4) for i in 1:N])

        v = zeros(N)
        Threads.@threads for i = 1:N
            v[Threads.threadid()] = testing_roundings_up(a[Threads.threadid()])
        end

        @test all(v[[i%4==1 for i in 1:N]] .== 1.0) #Nearest 
        @test all(v[[i%4==2 for i in 1:N]] .== nextfloat(1.0)) #Up 
        @test all(v[[i%4==3 for i in 1:N]] .== 1.0) #Down
        @test all(v[[i%4==0 for i in 1:N]] .== 1.0) #ToZero

        v = zeros(N)
        Threads.@threads for i = 1:N
            v[Threads.threadid()] = testing_roundings_down(a[Threads.threadid()])
        end
    
        @test all(v[[i%4==1 for i in 1:N]] .== 1.0) #Nearest 
        @test all(v[[i%4==2 for i in 1:N]] .== 1.0) #Up 
        @test all(v[[i%4==3 for i in 1:N]] .== prevfloat(1.0)) #Down
        @test all(v[[i%4==0 for i in 1:N]] .== prevfloat(1.0)) #ToZero
    end
end

@testset "Testing using external Linear Algebra library" begin
    using LinearAlgebra

    v = [1.0; 1.0]
    w = [1.0; eps(1.0)/2]
    
    x = llvm_setrounding(RoundUp) do
        BLAS.dot(v, w)
    end
    @test x == nextfloat(1.0)

    x = llvm_setrounding(RoundNearest) do
        BLAS.dot(v, w)
    end
    @test x == 1.0
end

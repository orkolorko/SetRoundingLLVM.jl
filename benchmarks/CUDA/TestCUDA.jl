import Pkg;
Pkg.activate(".")

Pkg.add(url = "https://github.com/orkolorko/SetRoundingLLVM.jl")
Pkg.add("CUDA")

using SetRoundingLLVM, CUDA

η::Float64 = nextfloat(0.0)


function CUDA_rounding(y)
    x=ccall("llvm.flt.rounds", llvmcall, Int32, () )
    y[threadIdx().x] = x
    return nothing
end

function CUDA_setrounding(rounding)
    ccall("llvm.set.rounding", llvmcall, Cvoid, (Int32, ), rounding)
    return nothing
end


function test_CUDA(η)
    x = CUDA.ones(Float64, 10)
    y = η*CUDA.ones(Float64, 10)

    v = llvm_setrounding(RoundUp) do 
        x+y
    end
    return v
end

function test_CUDA_2(η)
    x = CUDA.ones(Float64, 10)
    y = η*CUDA.ones(Float64, 10)

    v = llvm_setrounding(RoundUp) do 
        x+y
    end
    return v
end


function test_normal(η)
    x = ones(Float64, 10)
    y = η*ones(Float64, 10)

    v = llvm_setrounding(RoundUp) do 
        x+y
    end
    return v
end

function gpu_add!(y, x)
    index = threadIdx().x    
    stride = blockDim().x
    for i = index:stride:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

function test_kernel(η)
    x = CUDA.ones(Float64, 10)
    y = η*CUDA.ones(Float64, 10)

    llvm_setrounding(RoundUp) 
    @cuda threads=10 gpu_add!(y, x)
    llvm_setrounding(RoundNearest) 
    return y
end

v = Array(test_CUDA(η))
@info v

v = test_normal(η)
@info v

v = Array(test_kernel(η))
@info v


# A simple check to check if can read the rounding mode from the GPU
t = CUDA.zeros(10)
@cuda threads = 10 CUDA_rounding(t)
@info t

rnd::Int32 = 3 
@cuda CUDA_setrounding(rnd)

t = CUDA.zeros(10)
@cuda threads = 10 CUDA_rounding(t)
@info t
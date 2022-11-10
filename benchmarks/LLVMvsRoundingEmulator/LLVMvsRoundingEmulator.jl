import Pkg;
Pkg.activate(".")

Pkg.add(url = "https://github.com/matsueushi/RoundingEmulator.jl")
Pkg.add(url = "https://github.com/orkolorko/SetRoundingLLVM.jl")
Pkg.add(url = "https://github.com/KristofferC/TimerOutputs.jl")

using RoundingEmulator, SetRoundingLLVM, TimerOutputs

using TimerOutputs

const to = TimerOutput()

N::Int64 = 1000000
v::Array{Float64, 1} = rand(Float64, N)
w::Float64 = rand()

# warm up 
for x in v
    add_up(x, w)
    sub_up(x,w)
    mul_up(x,w)
    div_up(x,w)
end

for x in v
    llvm_setrounding(RoundUp)
    x+w
    x-w
    x*w
    x/w
    llvm_setrounding(RoundNearest) 
end

@timeit to "RoundingEmulator add_up" begin 
    for x in v
        add_up(x, w)
    end
end

@timeit to "SetRoundingLLVM add_up" begin 
    for x in v
        llvm_setrounding(RoundUp)
        x+w
        llvm_setrounding(RoundNearest) 
    end
end

@timeit to "SetRoundingLLVM add_up vector" begin 
    llvm_setrounding(RoundUp)
    for x in v
        x+w 
    end
    llvm_setrounding(RoundNearest)
end


@timeit to "RoundingEmulator sub_up" begin 
    for x in v
        sub_up(x, w)
    end
end

@timeit to "SetRoundingLLVM sub_up" begin 
    for x in v
        llvm_setrounding(RoundUp)
        x-w
        llvm_setrounding(RoundNearest) 
    end
end

@timeit to "SetRoundingLLVM sub_up vector" begin 
    llvm_setrounding(RoundUp)
    for x in v
        x-w 
    end
    llvm_setrounding(RoundNearest)
end

@timeit to "RoundingEmulator mul_up" begin 
    for x in v
        mul_up(x, w)
    end
end

@timeit to "SetRoundingLLVM mul_up" begin 
    for x in v
        llvm_setrounding(RoundUp)
        x*w
        llvm_setrounding(RoundNearest) 
    end
end

@timeit to "SetRoundingLLVM mul_up vector" begin 
    llvm_setrounding(RoundUp)
    for x in v
        x*w 
    end
    llvm_setrounding(RoundNearest)
end

@timeit to "RoundingEmulator div_up" begin 
    for x in v
        div_up(x, w)
    end
end

@timeit to "SetRoundingLLVM div_up" begin 
    for x in v
        llvm_setrounding(RoundUp)
        x/w
        llvm_setrounding(RoundNearest) 
    end
end

@timeit to "SetRoundingLLVM div_up vector" begin 
    llvm_setrounding(RoundUp)
    for x in v
        x/w 
    end
    llvm_setrounding(RoundNearest)
end

show(to)
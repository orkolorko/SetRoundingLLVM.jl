import Pkg;
Pkg.activate(".")

Pkg.add(url = "https://github.com/orkolorko/SetRoundingLLVM.jl")

using SetRoundingLLVM

using LinearAlgebra

A = [1 1; 0 1]
v = [1.0; eps(1.0)/2]

w = llvm_setrounding(RoundUp) do 
    A*v
end

@assert w[1] == nextfloat(1.0)

w = llvm_setrounding(RoundNearest) do 
    A*v
end

@assert w[1] == 1.0

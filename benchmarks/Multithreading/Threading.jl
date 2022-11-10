import Pkg;
Pkg.activate(".")

Pkg.add(url = "https://github.com/orkolorko/SetRoundingLLVM.jl")

using SetRoundingLLVM

@info "Running on $(Threads.nthreads()) threads"

N = Threads.nthreads()

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

@info "Threadid%4 = 1  has rounding mode $(a[1])"
@info "Threadid%4 = 2  has rounding mode $(a[2])"
@info "Threadid%4 = 3  has rounding mode $(a[3])"
@info "Threadid%4 = 4  has rounding mode $(a[4])"

v = zeros(N)
Threads.@threads for i = 1:N
    v[Threads.threadid()] = testing_roundings_up(a[Threads.threadid()])
end
@info v
@assert all(v[[i%4==1 for i in 1:N]] .== 1.0) #Nearest 
@assert all(v[[i%4==2 for i in 1:N]] .== nextfloat(1.0)) #Up 
@assert all(v[[i%4==3 for i in 1:N]] .== 1.0) #Down
@assert all(v[[i%4==0 for i in 1:N]] .== 1.0) #ToZero

v = zeros(N)
Threads.@threads for i = 1:N
    v[Threads.threadid()] = testing_roundings_down(a[Threads.threadid()])
end
@info v
@assert all(v[[i%4==1 for i in 1:N]] .== 1.0) #Nearest 
@assert all(v[[i%4==2 for i in 1:N]] .== 1.0) #Up 
@assert all(v[[i%4==3 for i in 1:N]] .== prevfloat(1.0)) #Down
@assert all(v[[i%4==0 for i in 1:N]] .== prevfloat(1.0)) #ToZero


module SetRoundingLLVM

export llvm_rounding, llvm_setrounding, @roundup, @identity_macro



#0  - toward zero
#1  - to nearest, ties to even
#2  - toward positive infinity
#3  - toward negative infinity
#4  - to nearest, ties away from zero

to_llvm(::RoundingMode{:ToZero}) = 0
to_llvm(::RoundingMode{:Nearest}) = 1
to_llvm(::RoundingMode{:Up}) = 2
to_llvm(::RoundingMode{:Down}) = 3
to_llvm(::RoundingMode{:NearestTiesAway}) = 4

function from_llvm(x::Int32)
    if x==0
        return RoundToZero
    elseif x == 1
        return RoundNearest
    elseif x == 2
        return RoundUp
    elseif x == 3
        return RoundDown
    elseif x == 4
        return RoundNearestTiesAway
    else 
        @error "Undefined behavior"
    end
end 

"""
    llvm_rounding()

Return the current rounding mode for Float64

"""
llvm_rounding() = from_llvm(ccall("llvm.flt.rounds", llvmcall, Int32, () ))

"""
    llvm_setrounding(round::RoundingMode)    

Set the rounding mode of Float64, controlling the rounding of basic arithmetic functions (+,
-, *, / and sqrt) and type conversion. Other numerical functions may give incorrect or invalid values when
using rounding modes other than the default RoundNearest

Available modes are:

* RoundToZero
* RoundNearest
* RoundUp
* RoundDown

"""
llvm_setrounding(rounding::RoundingMode) = ccall("llvm.set.rounding", llvmcall, Cvoid, (Int32, ), to_llvm(rounding))

function llvm_setrounding(f::Function, rounding::RoundingMode)
    old_rounding = llvm_rounding()
    llvm_setrounding(rounding)
    try 
        return f()
    finally 
        llvm_setrounding(old_rounding)
    end
end

end

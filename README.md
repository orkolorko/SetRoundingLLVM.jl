# SetRoundingLLVM

This is a small module that uses LLVM intrinsics to set the
rounding mode for Float64.

This is a workaround for the deprecation of setrounding for Float64, see
[Deprecate setrounding](https://github.com/JuliaLang/julia/pull/27166).
This is specially needed for the implementation of the :fast
multiplication of matrices in [IntervalLinearAlgebra](https://github.com/JuliaIntervals/IntervalLinearAlgebra.jl),
which uses directed rounding together with high performance Blas
routine to compute enclosures of matrix multiplication.

One feature of the LLVM intrinsic is that they can be used to 
set the rounding mode on AMDGPU; it may be worth investigating this direction.


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://orkolorko.github.io/SetRoundingLLVM.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://orkolorko.github.io/SetRoundingLLVM.jl/dev/)
[![Build Status](https://github.com/orkolorko/SetRoundingLLVM.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/orkolorko/SetRoundingLLVM.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/orkolorko/SetRoundingLLVM.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/orkolorko/SetRoundingLLVM.jl)

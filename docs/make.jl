using SetRoundingLLVM
using Documenter

DocMeta.setdocmeta!(SetRoundingLLVM, :DocTestSetup, :(using SetRoundingLLVM); recursive=true)

makedocs(;
    modules=[SetRoundingLLVM],
    authors="Isaia Nisoli nisoli@im.ufrj.br and contributors",
    repo="https://github.com/orkolorko/SetRoundingLLVM.jl/blob/{commit}{path}#{line}",
    sitename="SetRoundingLLVM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://orkolorko.github.io/SetRoundingLLVM.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/orkolorko/SetRoundingLLVM.jl",
    devbranch="main",
)

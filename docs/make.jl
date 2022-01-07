prodir = realpath(joinpath(dirname(dirname(@__FILE__))))
srcdir = joinpath(prodir, "src")
srcdir ∉ LOAD_PATH && push!(LOAD_PATH, srcdir)

using Documenter
using Calendars

makedocs(
    modules = [Calendars],
    sitename = "Calendars.jl",
    clean = true,
    checkdocs = :none,
    doctest = false,
    pages = [
        "Functions" => "index.md",
        "Introduction" => "Calendars.md"
    ]
)

deploydocs(
    repo = "github.com/PeterLuschny/Calendars.jl.git",
    target = "build"
)


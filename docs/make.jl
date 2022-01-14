using Documenter
using Calendars

makedocs(
    modules = [Calendars],
    sitename = "Calendars.jl",
    clean = true,
    checkdocs = :none,
    doctest = false,
    pages = [
        "Introduction" => "Calendars.md",
        "Functions" => "index.md"
    ]
)

#deploydocs(
#    repo = "github.com/PeterLuschny/Calendars.jl.git",
#    target = "build"
#)


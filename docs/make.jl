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
        "References" => "References.md"
    ]
)

# "Introduction" => "Calendars.md",
#deploydocs(
#    repo = "github.com/PeterLuschny/Calendars.jl.git";
#    push_preview = true
#)


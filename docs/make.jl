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
        "Introduction" => "Calendars.md",
        "References" => "References.md"
    ]
)

deploydocs(
    repo = "github.com/PeterLuschny/Calendars.jl.git";
    push_preview = true
)


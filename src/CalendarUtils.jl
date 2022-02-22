# This is part of Calendars.jl. See the copyright note there.
# ======================= CalendarUtils =====================

# Planetary week
# As defined by Reingold & Dershowitz
const sunday    = 0 
const monday    = 1 
const tuesday   = 2 
const wednesday = 3 
const thursday  = 4 
const friday    = 5 
const saturday  = 6 
const weeklen   = 7

# Map weekday specifiers to weekday names.
WeekDays = Dict{Int, String}(
    0 => "Sunday    ",
    1 => "Monday    ",
    2 => "Tuesday   ",
    3 => "Wednesday ", 
    4 => "Thursday  ",
    5 => "Friday    ",
    6 => "Saturday  ",
# Well, we keep this to flag potential bugs.
    7 => "Doomsday  "
)
 
const january   = 1
const february  = 2
const march     = 3
const april     = 4
const may       = 5
const june      = 6
const july      = 7
const august    = 8
const september = 9
const october   = 10
const november  = 11
const december  = 12

const MonthLength = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)


# Calendar specifiers, Int64-enumeration of calendar names
XX = :0  # Unknown 
EC = :1  # European Calendar
CE = :2  # Common Era
JD = :3  # Julian (Roman Calendar)
AM = :4  # Anno Mundi
AH = :5  # Anno Hegirae
ID = :6  # ISO Date
EN = :7  # Euro Number
JN = :8  # Julian Number
DN = :9  # FixDay Number


# Map calendar specifiers to calendar names
CalendarNames = Dict{Int64, String}(
    EC => "European ",
    CE => "Common   ",
    JD => "Julian   ",
    AM => "Hebrew   ",
    AH => "Islamic  ",
    ID => "IsoDate  ",
    EN => "EuroNum  ",
    JN => "JulianNum",
    DN => "DayNumber",
    XX => "INVALID  "
)

CalendarName(cal) = CalendarNames[cal]

# Map calendar specifiers to calendar names
SymbolToString = Dict{Int64, String}(
    EC => "EC",
    CE => "CE",
    JD => "JD",
    AM => "AM",
    AH => "AH",
    ID => "ID",
    EN => "EN",
    JN => "JN",
    DN => "DN",
    XX => "00"
)

const DPart = Int64 

# Return symbolic name representing a calendar. 
# StringToSymbol = CalendarName 
function StringToSymbol(calendar::String, warn=false)::DPart
    (calendar == "European"   || calendar == "EC")  && return EC
    (calendar == "Common"     || calendar == "CE")  && return CE
    (calendar == "CurrentEpoch")                    && return CE
    (calendar == "Gregorian"   )                    && return CE
    (calendar == "Julian"     || calendar == "JD")  && return JD
    (calendar == "Roman"      || calendar == "AD")  && return JD
    (calendar == "Hebrew"     || calendar == "AM")  && return AM
    (calendar == "Jewish"      )                    && return AM
    (calendar == "Islamic"    || calendar == "AH")  && return AH
    (calendar == "Hijri"       )                    && return AH
    (calendar == "IsoDate"    || calendar == "ID")  && return ID
    (calendar == "ISODate"     )                    && return ID
    (calendar == "EuroNum"    || calendar == "EN")  && return EN
    (calendar == "JulianNum"  || calendar == "JN")  && return JN
    (calendar == "FixNum"     || calendar == "RD")  && return DN
    (calendar == "DayNum"     || calendar == "DN")  && return DN
    warn && @warn("Unknown calendar: $calendar")
    return XX
end

const InvalidDayNumber = DPart(0)
const InvalidDayOfYear = DPart(0)
const InvalidDuration = DPart(-1)
const InvalidDate = (XX, DPart(0), DPart(0), DPart(0))
const InvalidDateString = "0000-00-00"

"""

A CDate (short for Calender Date) is defined as 

```julia
CDate = Tuple{DPart, DPart, DPart, DPart}
```

    A tuple `date` of type `CDate` is unpacked by convention as
    (calendar, year, month, day), where `calendar` is one of

```julia 
"European" 
"Common" 
"Julian" 
"Hebrew" 
"Islamic" 
"IsoDate"
``` 

    Alternatively the acronyms 

```julia
EC, CE, JD, AM, AH, and ID 
```

    can be used. "Common" or CE denotes the proleptic Gregorian calendar
    and `DPart` (date part) is a typename for Int64.

```julia
CDateStr(cd::CDate) 
```

The function CDateStr converts a date of type CDate to a string representation, where the 
numeric part follows the recommendation of ISO 8601 and is prefixed by one of the acronyms 
for the calendar names indicated above. 

Examples for `CDates` and their string representation given by `CDateStr`:

```julia
("European", 2022,  1,  6)  -> "EC-2022-01-06"
("Common",   2022,  1, 19)  -> "CE-2022-01-19"
("Julian",   2022,  1,  6)  -> "JD-2022-01-06"
("Hebrew",   5782, 11, 17)  -> "AM-5782-11-17"
("Islamic",  1443,  6, 15)  -> "AH-1443-06-15"
("IsoDate",  2022,  3,  3)  -> "ID-2022-03-03"
``` 

The components of a `CDate` can be accessed by applying the functions
```julia
Calendar, Year, Month, Day and Date 
```
to a calendar date.

The function CalendarName(CC) returns the calendar name from a calendar specifier CC. 
For example both CalendarName(ID) and CalendarName(6) return the string "IsoDate".
"""
const CDate = NTuple{4, DPart} 
const YMD = NTuple{3, DPart} 
const DateTable = NTuple{8, CDate}

Calendar(date::CDate) = date[1]
Year(date::CDate) = date[2]
Month(date::CDate) = date[3]
Day(date::CDate) = date[4]
Date(date::CDate) = (date[2], date[3], date[4])

Calendar(d::Tuple{String, DPart, DPart, DPart}) = StringToSymbol(d[1])
Year(d::Tuple{String, DPart, DPart, DPart}) = d[2]
Month(d::Tuple{String, DPart, DPart, DPart}) = d[3]
Day(d::Tuple{String, DPart, DPart, DPart}) = d[4]
Date(d::Tuple{String, DPart, DPart, DPart}) = (d[2], d[3], d[4])

# TODO Write a 'get-' interface for the DateTable, like:
GetFixNum(dt::DateTable) = dt[7][4] - 2

# Return the name of the weekday for the given fix day number.
function WeekDay(dn::DPart)::String
    day = rem(dn, weeklen)
    return WeekDays[day]
end
WeekDay(dt::DateTable) = WeekDay(GetFixNum(dt))


# CDate stringified, no validation
function DateStr(year::DPart, month::DPart, day::DPart)
    y = lpad(year,  4, "0")
    m = lpad(month, 2, "0")
    d = lpad(day,   2, "0")
    return "$y-$m-$d"
end
DateStr(d::CDate) = DateStr(d[2], d[3], d[4]) 

function CDateStr(cd::CDate)
    cal, year, month, day = cd
    if cal == DN || cal == JN || cal == EN
        s = lpad(day, 7, "0")
        return SymbolToString[cal]*"#$s"
    end
        s = DateStr(year, month, day)
    return SymbolToString[cal]*"-$s"
end

CDateStr(cal::String, d::YMD) = 
CDateStr((StringToSymbol(cal), d[1], d[2], d[3]))

CDateStr(cal::DPart, d::YMD) = 
CDateStr((cal, d[1], d[2], d[3]))

CDateStr(cal::String, day::DPart) = 
CDateStr((StringToSymbol(cal), DPart(0), DPart(0), day))

CDateStr(cal::DPart, day::DPart) = 
CDateStr((cal, DPart(0), DPart(0), day))

function CDateStr(cal::DPart, year::DPart, month::DPart) 
    y = lpad(year,  4, "0")
    m = lpad(month, 2, "0")
    return SymbolToString[cal] * "-$y-$m"
end

CDateStr(cal::String, year::DPart, month::DPart) =
CDateStr(StringToSymbol(cal), year, month) 

CDateStr(cal::String, year::DPart, month::DPart, day::DPart) =
CDateStr((StringToSymbol(cal), year, month, day)) 

"""

PrintDateTable(D::DateTable, io=stdout)

Print a `DateTable` (which normally is build by `CalendarDates`) to `io`.
"""
function PrintDateTable(D::DateTable, io=stdout)
    for d in D
        if d[1] != XX  # Don't print invalid dates
            cname = CalendarNames[d[1]]
            println(io, cname, " ", CDateStr(d))
        end
    end
end

"""

```julia
PrintDateLine(date::CDate, io=stdout)
```

Given a `date` print a line with all representations of this date to `io`. The parts of the date can also be given separately.
For example:

```julia
julia> PrintDateLine(EC, 2022, 2, 2)
```
| CE-2022-02-02 | EC-2022-02-02 | JD-2022-01-20 | AM-5782-12-01 | AH-1443-06-29 | ID-2022-05-03 | EN#0738190 | JN#2459612 |
"""
function PrintDateLine(date::CDate, io=stdout)
    dn = DayNumberFromDate(date)
    println(io,  "| ",
        CDateStr(DateFromDayNumber(CE, dn)), " | ",
        CDateStr(DateFromDayNumber(EC, dn)), " | ",
        CDateStr(DateFromDayNumber(JD, dn)), " | ",
        CDateStr(DateFromDayNumber(AM, dn)), " | ",
        CDateStr(DateFromDayNumber(AH, dn)), " | ",
        CDateStr(DateFromDayNumber(ID, dn)), " | ",
        CDateStr(DateFromDayNumber(EN, dn)), " | ",
        CDateStr(DateFromDayNumber(JN, dn)), " |" 
    )
end

PrintDateLine(cal, year, month, day, io=stdout) = PrintDateLine((cal, year, month, day), io)

header = "|    Common     |   European    |    Julian     |    Hebrew     |    Islamic    |    IsoDate    |  EuroNum   | JulianNum  |"
markup = "|    :---:      |     :---:     |    :---:      |     :---:     |    :---:      |     :---:     |   :---:    |   :---:    |"

"""

```julia
PrintEuropeanMonth(year::DPart, month::DPart, io=stdout)
```

Print a calendar for the given European month as a markdown table to `io`.

For example:
```julia
julia> PrintEuropeanMonth(2022, 2)
```
"""
function PrintEuropeanMonth(year::DPart, month::DPart, io=stdout)
    datestr = CDateStr(EC, year, month)
    println(io, "# Calendars of the month ", datestr)
    println(io, header)
    println(io, markup)
    dn = DayNumberFromDate((JD, year, month, 1))
    if dn < GregorysBreak
        for day in 1:LastDayOfMonthJulian(year, month) 
            PrintDateLine((JD, year, month, day), io)
        end
    else
    for day in 1:LastDayOfMonthGregorian(year, month) 
            PrintDateLine((CE, year, month, day), io)
        end
    end
end

datadir = realpath(joinpath(dirname(@__FILE__)))

"""

```julia
SaveEuropeanMonth(year::DPart, month::DPart, dirname:String)
```

Save the calendar of the given European month as a markdown table to a file in the directory
`dirname`. If no directory is given the file is written to the execution directory.

For example:
```julia
julia> SaveEuropeanMonth(2022, 2)
```
"""
function SaveEuropeanMonth(year::DPart, month::DPart, dir=datadir)
    datestr = CDateStr(EC, year, month)
    filename = joinpath(dir, "Calendar$datestr.md")
    f = open(filename, "w") do f
        PrintEuropeanMonth(year, month, f)
    end
    @info("Saved European month $datestr to: $filename")
end


function PrintWeekLine(date::CDate, io=stdout)
    dn = DayNumberFromDate(date)
    println(io,  "| ",
        DateStr(DateFromDayNumber(EC, dn)), " | ",
        DateStr(DateFromDayNumber(AM, dn)), " | ",
        DateStr(DateFromDayNumber(AH, dn)), " | "
    )
end

wheader = "|  Weekday  |  European  |   Hebrew   |  Islamic   |"
wmarkup = "|   :---:   |    :---:   |   :---:    |   :---:    |"

"""

```julia
PrintIsoWeek(year::DPart, week::DPart, io=stdout)
```

Print a calendar for the given Iso week as a markdown table to `io`.

For example:
```julia
julia> PrintIsoWeek(2022, 2)
```
"""
function PrintIsoWeek(year::DPart, week::DPart, io=stdout)
    println(io, "# Days of week ", week, " of the year ", year, ".")
    println(io, wheader)
    println(io, wmarkup)
    for day in 1:7
        ind = day != 7 ? day : 0
        print("| ", WeekDays[ind])
        PrintWeekLine((ID, year, week, day), io)
    end
end

NextDay(date::CDate)     = DateFromDayNumber(date[1],  1 + DayNumberFromDate(date))
PreviousDay(date::CDate) = DateFromDayNumber(date[1], -1 + DayNumberFromDate(date))

Warning(d) = string(d) * " is not a valid date!"  

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


# Calendar specifiers, symbols for calendar names
CE = :"CE"  # Common Era
EC = :"EC"  # European Calendar
JD = :"JD"  # Julian (Roman Calendar)
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
EN = :"EN"  # Euro Number
JN = :"JN"  # Julian Number
DN = :"DN"  # FixDay Number
XX = :"00"  # Unknown 

# Map calendar specifiers to calendar names
CalendarNames = Dict{String, String}(
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

# Return symbolic name representing a calendar. 
# CName = CalendarName 
function CName(calendar::String, warn=false) 
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

const DPart = Int 
const InvalidDayNumber = DPart(0)
const InvalidDayOfYear = DPart(0)
const InvalidDuration = DPart(-1)
const InvalidDate = (XX, DPart(0), DPart(0), DPart(0))
const InvalidDateString = "0000-00-00"

const JDN_DN  = DPart(1721424)
const DN_MJDN = DPart(678576)

# Days considered here start at midnight 00:00.
# (Apply 'floor' to the /real/ Julian day number.)

# Convert a fix day number to a Julian day number.
# If mod = true return the modified Julian day number.
# (which has epoch CE 1858-11-17, 00:00 UT).
function FixNumToJulianNum(rd::DPart, mod=false) 
    if mod 
        return rd - DN_MJDN
    else 
        return rd + JDN_DN
    end
end

# Convert a Julian day number to a fix day number.
# If mod = true assume a modified Julian day number.
function JulianNumToFixNum(jdn::DPart, mod=false) 
    if mod 
        return jdn + DN_MJDN
    else
        return jdn - JDN_DN
    end
end

# Convert a fix day number to an European day number.
FixNumToEuroNum(fn::DPart) = fn + 2

# Convert an European day number to a fix day number.
EuroNumToFixNum(en::DPart) = en - 2

"""
Convert a Julian day number to an European day number.
```julia
julia> JulianNumToEuroNum(2440422)
```
The European day number of the first crewed moon landing (Apollo 11) is EN#719000.
"""
JulianNumToEuroNum(jn::DPart) = jn - JDN_DN + 2


"""
Convert an European day number to an Julian day number.
```julia
julia> EuroNumToJulianNum(719000)
```
The Julian day number of the first crewed moon landing (Apollo 11) is JN#2440422.
"""
EuroNumToJulianNum(en::DPart) = en + JDN_DN - 2


# The fix day number of CE 1582-10-15.
const GregorysBreak = DPart(577736)


"""

A CDate (short for Calender Date) is defined as 

```julia
CDate = Tuple{String, DPart, DPart, DPart}
```

    A tuple `date` of type `CDate` is unpacked by convention as (calendar, year, month, day) = 
    date, where `calendar` is "Common", "Julian", "European", Hebrew", "Islamic", or "IsoDate". 
    Alternatively the acronyms CE, EC, JD, AM, AH, and ID can be used. 
    `DPart` (date part) is a typename for Int.

```julia
CDateStr(cd::CDate) 
```

The function CDateStr converts a date of type CDate to a string representation, where the 
numeric part follows the recommendation of ISO 8601 and is prefixed by one of the acronyms 
for the calendar names indicated above. 

Examples for CDates and their string representation are:

```julia
("European", 2022,  1,  6)  -> "EC-2022-01-19"
("Common",   2022,  1, 19)  -> "CE-2022-01-19"
("Julian",   2022,  1,  6)  -> "JD-2022-01-06"
("Hebrew",   5782, 11, 17)  -> "AM-5782-11-17"
("Islamic",  1443,  6, 15)  -> "AH-1443-06-15"
("IsoDate",  2022,  3,  3)  -> "ID-2022-03-03"
``` 
"""
const CDate = Tuple{String, DPart, DPart, DPart}
const DateTable = NTuple{7, CDate}

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
    cal = CName(cal)
    if cal == DN || cal == JN || cal == EN
        s = lpad(day, 7, "0")
        return "$cal#$s"
    end
        s = DateStr(year, month, day)
    return "$cal-$s"
end

CDateStr(cal::String, d::Tuple{DPart, DPart, DPart}) = CDateStr((cal, d[1], d[2], d[3]))

CDateStr(cal::String, day::DPart) = CDateStr((cal, DPart(0), DPart(0), day))

function CDateStr(cal::String, year::DPart, month::DPart) 
    y = lpad(year,  4, "0")
    m = lpad(month, 2, "0")
    cal = CName(cal)
    return "$cal-$y-$m"
end

"""

PrintDateTable(D::DateTable, io=stdout)

Print a `DateTable` (which normally is build by `CalendarDates`) to `io`.
"""
function PrintDateTable(D::DateTable, io=stdout)
    for d in D
        println(io, CalendarNames[d[1]], " ", CDateStr(d))
    end
end


"""

```julia
PrintDateLine(date::CDate, io=stdout)
```

Given a `date` print a line with all representations of this date to `io`. The parts of the date can also be given separately.

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

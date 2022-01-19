# This is part of Calendars.jl. See the copyright note there.
# ======================= CalendarUtils =====================

# Symbols for calendar names
DN = :"DN"  # Day Number
CE = :"CE"  # Current Epoch
AD = :"AD"  # Julian
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
XX = :"00"  # Unknown 

# Return symbolic name representing a calendar. 
function CName(calendar) # CName = CalendarName 
    (calendar == "CurrentEpoch" || calendar == "Gregorian" 
    || calendar == "CE") && return CE
    (calendar == "Julian"    || calendar == "AD") && return AD
    (calendar == "Hebrew"    || calendar == "AM") && return AM
    (calendar == "Islamic"   || calendar == "AH") && return AH
    (calendar == "IsoDate"   || calendar == "ID") && return ID
    (calendar == "DayNumber" || calendar == "DN") && return DN
    @warn("Unknown calendar: $calendar")
    return XX
end

const InvalidDayNumber = Int64(0)
const InvalidDayOfYear = Int64(0)
const InvalidDuration = Int64(-1)
const InvalidDate = (XX, 0, 0, 0)
const InvalidDateString = "0000-00-00"

# Map calendar specifiers or character codes to tokens.
CalendarSpecifiers = Dict{String, String}(
    "DN" => "DayNumber   ",
    "CE" => "CurrentEpoch",
    "AD" => "Julian      ",
    "ID" => "IsoDate     ",
    "AM" => "Hebrew      ",
    "AH" => "Islamic     ",
    "00" => "INVALID     "
)


"""

A CDate (short for Calender Date) is defined as 

```julia
CDate = Tuple{String, Int64, Int64, Int64}
```

    A tuple 'date' of type 'CDate' is unpacked by convention as  
    (calendar, year, month, day) = date, where 'calendar' is 
    "Gregorian", "Hebrew", "Islamic", "Julian", or "IsoDate". 
    Alternatively the acronyms "CE", "AM", "AH", "AD" and 
    "ID" can be used.  

```julia
CDateStr(cd::CDate) 
```

The function CDateStr converts a date of type CDate into a 
string representation, where the numeric part follows the
recommendation of ISO 8601 and is prefixed by one of the 
acronyms for the calendar names indicated above. 

Examples for CDates and their string representation are:

```julia
("Gregorian", 2022,  1, 19)  -> "CE 2022-01-19"
("Julian",    2022,  1,  6)  -> "AD 2022-01-06"
("Hebrew",    5782, 11, 17)  -> "AM 5782-11-17"
("Islamic",   1443,  6, 15)  -> "AH 1443-06-15"
("IsoDate",   2022,  3,  3)  -> "ID 2022-03-03"
``` 
"""
const CDate = Tuple{String, Int64, Int64, Int64}

function DateStr(year, month, day)
    if year <= 0 || month <= 0 || day <= 0
        return "0000-00-00"   # Invalid date
    else
        y = lpad(year,  4, "0")
        m = lpad(month, 2, "0")
        d = lpad(day,   2, "0")
    end
    return "$y-$m-$d"
end

DateStr(d::CDate) = DateStr(d[2], d[3], d[4]) 

function CDateStr(cd::CDate)
    cal, year, month, day = cd
    if cal == DN 
        s = lpad(day, 7, "0")
    else
        s = DateStr(year, month, day)
    end
    return "$cal $s"
end
CDateStr(day::Int64) = CDateStr((DN, 0, 0, day))
CDateStr(cal::String, d::Tuple{Int64, Int64, Int64}) = 
CDateStr((cal, d[1], d[2], d[3]))

# Typename  
DateTable = NTuple{6, CDate}

function PrintDateTable(D)
    for d in D
        println(CalendarSpecifiers[d[1]], " ", CDateStr(d))
    end
end

Warning(d) = string(d) * " is not a valid date!"  

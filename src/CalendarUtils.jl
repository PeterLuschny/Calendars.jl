# This is part of Calendars.jl. See the copyright note there.
# ======================= CalendarUtils =====================

# Symbols for calendar names
CE = :"CE"  # Current Epoch
AD = :"AD"  # Julian
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
RD = :"RD"  # Day Number
XX = :"00"  # Unknown 

# Return symbolic name representing a calendar. 
function CName(calendar) # CName = CalendarName 
    (calendar == "CurrentEpoch" || calendar == "CE") && return CE
    (calendar == "Gregorian" )                       && return CE
    (calendar == "Common"    )                       && return CE
    (calendar == "Christian" )                       && return CE
    (calendar == "Julian"    || calendar == "AD")    && return AD
    (calendar == "Hebrew"    || calendar == "AM")    && return AM
    (calendar == "Jewish"    )                       && return AM
    (calendar == "Islamic"   || calendar == "AH")    && return AH
    (calendar == "Hijri"     )                       && return AH
    (calendar == "IsoDate"   || calendar == "ID")    && return ID
    (calendar == "ISODate"   )                       && return ID
    (calendar == "DayNumber" || calendar == "DN")    && return RD
    (calendar == "RataDie"   || calendar == "RD")    && return RD
    @warn("Unknown calendar: $calendar")
    return XX
end

# Map calendar specifiers or character codes to tokens.
CalendarSpecifiers = Dict{String, String}(
    "RD" => "DayNumber   ",
    "CE" => "CurrentEpoch",
    "AD" => "Julian      ",
    "ID" => "IsoDate     ",
    "AM" => "Hebrew      ",
    "AH" => "Islamic     ",
    "00" => "INVALID     "
)

const DPart = Int64
const InvalidDayNumber = DPart(0)
const InvalidDayOfYear = DPart(0)
const InvalidDuration = DPart(-1)
const InvalidDate = (XX, DPart(0), DPart(0), DPart(0))
const InvalidDateString = "0000-00-00"

const MaxYear = DPart(9999)

"""

A CDate (short for Calender Date) is defined as 

```julia
CDate = Tuple{String, DPart, DPart, DPart}
```

    A tuple 'date' of type 'CDate' is unpacked by convention as  
    (calendar, year, month, day) = date, where 'calendar' is 
    "Gregorian", "Hebrew", "Islamic", "Julian", or "IsoDate". 
    Alternatively the acronyms "CE", "AM", "AH", "AD" and 
    "ID" can be used. 'DPart' (date part) is a typename and 
    is defined as Int64.

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
const CDate = Tuple{String, DPart, DPart, DPart}
const DateTable = NTuple{6, CDate}

function DateStr(year::DPart, month::DPart, day::DPart)
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
    if cal == RD 
        s = lpad(day, 7, "0")
    else
        s = DateStr(year, month, day)
    end
    return "$cal $s"
end
CDateStr(day::DPart) = CDateStr((RD, DPart(0), DPart(0), day))
CDateStr(cal::String, d::Tuple{DPart, DPart, DPart}) = 
CDateStr((cal, d[1], d[2], d[3]))

# Typename  
function PrintDateTable(D::DateTable)
    for d in D
        println(CalendarSpecifiers[d[1]], " ", CDateStr(d))
    end
end

Warning(d) = string(d) * " is not a valid date!"  

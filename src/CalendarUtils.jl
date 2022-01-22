# This is part of Calendars.jl. See the copyright note there.
# ======================= CalendarUtils =====================

# Symbols for calendar names
CE = :"CE"  # Common Era
RC = :"RC"  # Julian (Roman Calendar)
EC = :"EC"  # European Calendar
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
RD = :"RD"  # Day Number
XX = :"00"  # Unknown 

# Map calendar specifiers or character codes to tokens.
CalendarSpecifiers = Dict{String, String}(
    "CE" => "Common   ",
    "RC" => "Julian   ",
    "EC" => "European ",
    "AM" => "Hebrew   ",
    "AH" => "Islamic  ",
    "ID" => "IsoDate  ",
    "RD" => "DayNumber",
    "00" => "INVALID  "
)

# Return symbolic name representing a calendar. 
function CName(calendar::String) # CName = CalendarName 
    (calendar == "Common"     || calendar == "CE")    && return CE
    (calendar == "CurrentEpoch")                      && return CE
    (calendar == "Gregorian"  )                       && return CE
    (calendar == "Julian"     || calendar == "RC")    && return RC
    (calendar == "Christian"  || calendar == "AD")    && return RC
    (calendar == "European"   || calendar == "EC")    && return EC
    (calendar == "Hebrew"     || calendar == "AM")    && return AM
    (calendar == "Jewish"     )                       && return AM
    (calendar == "Islamic"    || calendar == "AH")    && return AH
    (calendar == "Hijri"      )                       && return AH
    (calendar == "IsoDate"    || calendar == "ID")    && return ID
    (calendar == "ISODate"    )                       && return ID
    (calendar == "DayNumber"  || calendar == "DN")    && return RD
    (calendar == "RataDie"    || calendar == "RD")    && return RD
    @warn("Unknown calendar: $calendar")
    return XX
end

const DPart = Int64
const InvalidDayNumber = DPart(0)
const InvalidDayOfYear = DPart(0)
const InvalidDuration = DPart(-1)
const InvalidDate = (XX, DPart(0), DPart(0), DPart(0))
const InvalidDateString = "0000-00-00"

const JDN_RD  = DPart(1721424)
const RD_MJDN = DPart(678576)

# Days considered here start at midnight 00:00.
# (Apply 'floor' to the /real/ Julian day number.)

# Convert a RD day number to a Julian day number.
# If mod = true return the modified Julian day number.
# (which has epoch CE 1858-11-17, 00:00 UT).
function RDToJulianNumber(rd::DPart, mod=false) 
    if mod 
        return rd - RD_MJDN
    else 
        return rd + JDN_RD
    end
end

# Convert a Julian day number to a RD day number.
# If mod = true assume a modified Julian day number.
function JulianNumberToRD(jdn::DPart, mod=false) 
    if mod 
        return jdn + RD_MJDN
    else
        return jdn - JDN_RD
    end
end

# The RD day number of CE 1582-10-15.
const GregorysBreak = DPart(577736)

"""

A CDate (short for Calender Date) is defined as 

```julia
CDate = Tuple{String, DPart, DPart, DPart}
```

    A tuple 'date' of type 'CDate' is unpacked by convention as  
    (calendar, year, month, day) = date, where 'calendar' is 
    "Common", "Julian", "European", Hebrew", "Islamic", 
    or "IsoDate". Alternatively the acronyms "CE", "RC", "EC",
    "AM", "AH", and "ID" can be used. 'DPart' (date part) is 
    a typename and is defined as Int64.

```julia
CDateStr(cd::CDate) 
```

The function CDateStr converts a date of type CDate into a 
string representation, where the numeric part follows the
recommendation of ISO 8601 and is prefixed by one of the 
acronyms for the calendar names indicated above. 

Examples for CDates and their string representation are:

```julia
("Common",   2022,  1, 19)  -> "CE 2022-01-19"
("Julian",   2022,  1,  6)  -> "RC 2022-01-06"
("European", 2022,  1,  6)  -> "EC 2022-01-19"
("Hebrew",   5782, 11, 17)  -> "AM 5782-11-17"
("Islamic",  1443,  6, 15)  -> "AH 1443-06-15"
("IsoDate",  2022,  3,  3)  -> "ID 2022-03-03"
``` 
"""
const CDate = Tuple{String, DPart, DPart, DPart}
const DateTable = NTuple{7, CDate}

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
        s = lpad(day, 7, " ")
    else
        s = DateStr(year, month, day)
    end
    return "$cal $s"
end
CDateStr(day::DPart) = CDateStr((RD, DPart(0), DPart(0), day))
CDateStr(cal::String, d::Tuple{DPart, DPart, DPart}) = 
CDateStr((cal, d[1], d[2], d[3]))

function PrintDateTable(D::DateTable)
    println(D)
    for d in D
        println(CalendarSpecifiers[d[1]], " ", CDateStr(d))
    end
end

Warning(d) = string(d) * " is not a valid date!"  

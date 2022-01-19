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

Warning(d) = "Date is prior to epoch " * string(d)

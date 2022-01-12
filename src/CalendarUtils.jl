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

const InvalidDate = ("00", 0, 0, 0, 0)
const InvalidDateString = "00 0000-00-00"

# Map calendar specifiers or character codes to tokens.
CalendarSpecifiers = Dict{String, String}(
    "DN" => "DayNumber   ",
    "CE" => "CurrentEpoch",
    "AD" => "Julian      ",
    "ID" => "ISODate     ",
    "AM" => "Hebrew      ",
    "AH" => "Islamic     ",
    "00" => "INVALID     "
)

# Return symbolic name representing a calendar. 
function CName(calendar) # CName = CalendarName 
    (calendar == "CurrentEpoch" || calendar == "Gregorian" 
    || calendar == "CE") && return CE
    (calendar == "Julian"    || calendar == "AD") && return AD
    (calendar == "Hebrew"    || calendar == "AM") && return AM
    (calendar == "Islamic"   || calendar == "AH") && return AH
    (calendar == "ISODate"   || calendar == "ID") && return ID
    (calendar == "DayNumber" || calendar == "DN") && return DN
    @warn("Unknown calendar: $calendar")
    return XX
end

function DateStr(year, month, day)
    # Invalid date
    if year <= 0 || month <= 0 || day <= 0
        return "0000-00-00"
    else
        y = lpad(year,  4, "0")
        m = lpad(month, 2, "0")
        d = lpad(day,   2, "0")
    end
    return "$y-$m-$d"
end

DateStr(d::Tuple{Int, Int, Int}) = DateStr(d[1], d[2], d[3]) 

# CDate = CalendarDate
function CDate(c, year, month, day)
    if c == DN 
        s = lpad(day, 7, "0")
    else
        s = DateStr(year, month, day)
    end
    return "$c $s"
end

CDate(c, d::Int) = CDate(c, 0, 0, d)
CDate(c, d::Tuple{Int, Int, Int}) = CDate(c, d[1], d[2], d[3])
CDate(d) = CDate(d[1], d[2], d[3], d[4])


DateTable = NTuple{6, Tuple{String, Int64, Int64, Int64}}

function PrintDateTable(D)
    for d in D
        println(CalendarSpecifiers[d[1]], " ", CDate(d))
    end
end

Warning(d) = "Date is prior to epoch " * d

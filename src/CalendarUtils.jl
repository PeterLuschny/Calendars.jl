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

function CDateStr(d::CDate)
    if d[1] == DN 
        s = lpad(d[4], 7, "0")
    else
        s = DateStr(d[2], d[3], d[4])
    end
    return "$(d[1]) $s"
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


# Given two dates d1 = (c1, y1, m1, d1) and d2 = (c2, y2, m2, d2),
# and assume without loss of generality d1 <= d2.
# Period(d1, d2) = { date | DNumber(d1) <= DNumber(date) < DNumber(d2) }

# This means that a /period/ is a half-open interval in the calendar, 
# where the start date d1 is inclusive but the end date d2 is exclusive. 
# Thus Period(d1, d2) represents the set of /ellapsed days/ since d1,
# limited by date d2.

# Duration(d1, d2) = Cardinality(Period(d1, d2))
# We compute Duration(d1, d2) = Abs(DNumber(d2) - DNumber(d1)).
# /Duration/ is a measure and symmetric in the variables.
# The setup makes it possible to consider time periods even when
# the start and end dates are given in different calendars.
#
# Example: Duration((2022, 1, 1), "CE", (2022, 1, 1), "ID", true)
# julia> CE 2022-01-01 -- ID 2022-01-01 -> Duration 2
function Duration(a::CDate, b::CDate, show=false)
    if isValidDate(a) && isValidDate(b)
        an = DayNumberFromDate(a)
        bn = DayNumberFromDate(b)
        dur = abs(bn - an)
        
        if show
            ad = CDateStr(a)
            bd = CDateStr(b)
            show && println(ad, " <--> ", bd, " -> Duration ", dur)
        end
        return dur 
    end
    @warn("Invalid Date: $a $b")
    return InvalidDuration
end

#=
using Dates 
# DayOfLife is an OrdinalDate, not a Duration!
function DayOfLife(birthdate) 
    if isValidDate(birthdate, CE) 
        now = Dates.yearmonthday(Dates.now())
        return Duration(birthdate, CE, now, CE) + 1
    end
    @warn("Invalid Date: CE $birthdate")
    return InvalidDuration
end
=#

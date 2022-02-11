# This is part of Calendars.jl. See the copyright note there.
# ========================= Julian dates ====================

TEST = false
if TEST
    include("CalendarUtils.jl")
end

# Day number of the start of the Julian calendar.
# JL-0001-01-01 = CE-0000-12-30  ~ DN#-1 = EpochJulian.
# JL-0001-01-03 = CE-0001-01-01  ~ DN#1.
# JD-1111-11-11 = CE-1111-11-18  ~ DN#0405740
# JD-9999-12-31 = CE-10000-03-13 ~ DN#3652132
const EpochJulian = -1 
const ValidYearsJulian = (1, 9999) # by convention

# True if year is a Julian leap year.
function isLeapYearJulian(year::DPart)
    rem(year, 4) == 0
end

# Return the last day of the month for the Julian calendar.
function LastDayOfMonthJulian(year::DPart, month::DPart)
    leap = isLeapYearJulian(year)
    (month == 2 && leap) && return 29
    return MonthLength[month]
end

# Is the date a valid Julian date?
function isValidDateJulian(cd::CDate, warn=true)
    cal, year, month, day = cd
    val = ( cal == JD 
        && (ValidYearsJulian[1] <= year && year <= ValidYearsJulian[2]) 
        && (1 <= month && month <= 12) 
        && (1 <= day && day <= LastDayOfMonthJulian(year, month))) 
    ! val && warn && @warn(Warning(cd))
    return val
end

# Represents the day number a valid Julian date?
function isValidDateJulian(dn::DPart, warn=true)
    val = EpochJulian <= dn
    ! val && warn && @warn(Warning(dn))
    return val
end

# Return the days this year so far.
function DayOfYearJulian(year::DPart, month::DPart, day::DPart) 
    for m in (month - 1):-1:1  # days in prior months this year
        day += LastDayOfMonthJulian(year, m)
    end
    return day - 1
end

# Returns the day number from a valid Julian date.
function DayNumberJulian(year::DPart, month::DPart, day::DPart)
    day = DayOfYearJulian(year, month, day) 

    return (EpochJulian      # days elapsed before absolute date 1
        + 365 * (year - 1)   # days in previous years ignoring leap days
        + div(year - 1, 4)   # leap days before this year...
        + day                # days this year
    )
end
DayNumberJulian(d::CDate) = DayNumberJulian(d[2], d[3], d[4])

# Computes the Julian date from the day number.
function DateJulian(dn::DPart)
    ! isValidDateJulian(dn) && return InvalidDate

    # Search forward year by year from approximate year
    year = div(dn + EpochJulian, 366)

    while dn >= DayNumberJulian(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from January
    month = 1
    while dn > DayNumberJulian(year, month, 
                    LastDayOfMonthJulian(year, month))
        month += 1
    end

    day = dn - DayNumberJulian(year, month, 1) + 1
    return (JD, year, month, day)::CDate
end

# Return the day number of the first day in the given Julian year.
function YearStartJulian(year::DPart)
    return DayNumberJulian(year, 1, 1)
end

# Return the day number of the last day in the given Julian year.
function YearEndJulian(year::DPart) 
    return DayNumberJulian(year + 1, 1, 1) - 1
end

# Return the number of months in the given Julian year.
function MonthsInYearJulian(year::DPart) 
    return 12 
end

# Return the number of days in the given Julian year.
function DaysInYearJulian(year::DPart) 
    return YearStartJulian(year + 1) - YearStartJulian(year) 
end

if TEST

    for n in 0:3
        local dn = 1 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateJulian(dn)))
    end
    for n in 0:3
        local date = (JD, 1, 1, 1 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberJulian(date)))
    end

    for n in 0:3
        local dn = 3652129 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateJulian(dn)))
    end
    for n in 0:3
        local date = (JD, 9999, 12, 28 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberJulian(date)))
    end

    for n in 0:2
        local dn = 405739 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateJulian(dn)))
    end
    for n in 0:2
        local date = (JD, 1111, 11, 10 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberJulian(date)))
    end

#=
DN#0000001 -> JD-0001-01-03
DN#0000002 -> JD-0001-01-04
DN#0000003 -> JD-0001-01-05
DN#0000004 -> JD-0001-01-06
JD-0001-01-01 -> DN#00000-1
JD-0001-01-02 -> DN#0000000
JD-0001-01-03 -> DN#0000001
JD-0001-01-04 -> DN#0000002
DN#3652129 -> JD-9999-12-28
DN#3652130 -> JD-9999-12-29
DN#3652131 -> JD-9999-12-30
DN#3652132 -> JD-9999-12-31
JD-9999-12-28 -> DN#3652129
JD-9999-12-29 -> DN#3652130
JD-9999-12-30 -> DN#3652131
JD-9999-12-31 -> DN#3652132
DN#0405739 -> JD-1111-11-10
DN#0405740 -> JD-1111-11-11
DN#0405741 -> JD-1111-11-12
JD-1111-11-10 -> DN#0405739
JD-1111-11-11 -> DN#0405740
JD-1111-11-12 -> DN#0405741
=#

end  # TEST
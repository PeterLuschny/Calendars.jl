# This is part of Calendars.jl. See the copyright note there.
# ====================== Gregorian dates ====================

TEST = false
if TEST
    include("CalendarUtils.jl")
end

# Day number of the start of the Gregorian calendar.
# CE-0001-01-01 ~ DN#1 = EpochGregorian.
# CE-1111-11-11 ~ DN#0405733
# CE-9999-12-31 ~ DN#3652059
const EpochGregorian = 1 
const ValidYearsGregorian = (0, 9999) # by convention

# Is a divisible by b?
divisible(a, b) = rem(a, b) == 0

# True if year is a Gregorian leap year.
function isLeapYearGregorian(year::DPart)::Bool
    (divisible(year, 4) && ! divisible(year, 100)) || divisible(year, 400) 
end

# Return the last day of the month for the Gregorian calendar.
function LastDayOfMonthGregorian(year::DPart, month::DPart) 
    leap = isLeapYearGregorian(year)
    (month == 2 && leap) && return 29
    return MonthLength[month]
end

# Is the date a valid Gregorian date?
function isValidDateGregorian(cd::CDate, warn=true)
    cal, year, month, day = cd
    val = (CName(cal) == CE 
        && (ValidYearsGregorian[1] <= year <= ValidYearsGregorian[2]) 
        && (1 <= month && month <= 12) 
        && (1 <= day <= LastDayOfMonthGregorian(year, month)))
    ! val && warn && @warn(Warning(cd))
    return val
end

# Represents the day number a valid Gregorian date?
function isValidDateGregorian(dn::DPart, warn=true)
    # val = EpochGregorian - 2 <= dn
    val = -1 <= dn  
    ! val && warn && @warn(Warning(dn))
    return val
end

# Return the days this year so far.
function DayOfYearGregorian(year::DPart, month::DPart, day::DPart) 
    day += div(367 * month - 362, 12)
    day += ((month <= 2) ? 0 : (isLeapYearGregorian(year) ? -1 : - 2))
    return day - 1
end

# Computes the day number from a valid Gregorian date.
function DayNumberGregorian(year::DPart, month::DPart, day::DPart) 
    days = DayOfYearGregorian(year, month, day) 

    dn = (EpochGregorian 
        + days                 # days this year
        + 365 * (year - 1)     # days in previous years ignoring leap days
        + div(year - 1, 4)     # Julian leap days before this year...
        - div(year - 1, 100)   # ...minus prior century years...
        + div(year - 1, 400)   # ...plus prior years divisible by 400
    )
    return dn 
end
DayNumberGregorian(d::CDate) = DayNumberGregorian(d[2], d[3], d[4])

# Return the Gregorian year from the day number.
function YearGregorian(dn::DPart)
    d = dn - EpochGregorian
    n400, d = divrem(d, 146097) # 400 years contain 146097 days
    n100, d = divrem(d, 36524)
    n4, d   = divrem(d, 1461)
    n1, d   = divrem(d, 365)
    year = 400 * n400 + 100 * n100 + 4 * n4 + n1
    (n100 == 4 || n1 == 4) && return year 
    return year + 1
end

function DayOfYearGregorian(dn::DPart, year::DPart) 
    mar = DayNumberGregorian(year, 3, 1)
    day = dn - YearStartGregorian(year)
    day += dn < mar ? 0 : (isLeapYearGregorian(year) ? 1 :  2)
    return day
end

# Computes the Gregorian date from a day number.
function DateGregorian(dn::DPart) 
    ! isValidDateGregorian(dn) && return InvalidDate

    # Patch in the two allowed exceptions.
    dn == -1 && return (CE, 0, 12, 30)
    dn ==  0 && return (CE, 0, 12, 31)

    year = YearGregorian(dn)
    pdays = DayOfYearGregorian(dn, year) 
    month = div(12 * pdays + 373, 367)
    day = dn - DayNumberGregorian(year, month, 1) + 1
    return (CE, year, month, day)::CDate
end

# Return the day number of the first day in the given Gregorian year.
function YearStartGregorian(year::DPart)
    return DayNumberGregorian(year, 1, 1) 
end

# Return the day number of the last day in the given Gregorian year.
function YearEndGregorian(year::DPart) 
    return DayNumberGregorian(year + 1, 1, 1) - 1
end

# Return the number of months in the given Gregorian year.
function MonthsInYearGregorian(year::DPart) 
    return 12
end

# Return the number of days in the given Gregorian year.
function DaysInYearGregorian(year::DPart) 
    return YearStartGregorian(year + 1) - YearStartGregorian(year) 
end

if TEST

    dn1 = -1; println(CDateStr(DN, dn1), " -> ", CDateStr(DateGregorian(dn1)))
    dn0 =  0; println(CDateStr(DN, dn0), " -> ", CDateStr(DateGregorian(dn0)))

    for n in 0:3
        local dn = 1 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateGregorian(dn)))
    end
    for n in 0:3
        local date = (CE, 1, 1, 1 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberGregorian(date)))
    end

    for n in 0:3
        local dn = 3652056 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateGregorian(dn)))
    end
    for n in 0:3
        local date = (CE, 9999, 12, 28 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberGregorian(date)))
    end

    for n in 0:2
        local dn = 405732 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateGregorian(dn)))
    end
    for n in 0:2
        date = (CE, 1111, 11, 10 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberGregorian(date)))
    end

#=
DN#00000-1 -> CE-0000-12-30
DN#0000000 -> CE-0000-12-31
DN#0000001 -> CE-0001-01-01
DN#0000002 -> CE-0001-01-02
DN#0000003 -> CE-0001-01-03
DN#0000004 -> CE-0001-01-04
CE-0001-01-01 -> DN#0000001
CE-0001-01-02 -> DN#0000002
CE-0001-01-03 -> DN#0000003
CE-0001-01-04 -> DN#0000004
DN#3652056 -> CE-9999-12-28
DN#3652057 -> CE-9999-12-29
DN#3652058 -> CE-9999-12-30
DN#3652059 -> CE-9999-12-31
CE-9999-12-28 -> DN#3652056
CE-9999-12-29 -> DN#3652057
CE-9999-12-30 -> DN#3652058
CE-9999-12-31 -> DN#3652059
DN#0405732 -> CE-1111-11-10
DN#0405733 -> CE-1111-11-11
DN#0405734 -> CE-1111-11-12
CE-1111-11-10 -> DN#0405732
CE-1111-11-11 -> DN#0405733
CE-1111-11-12 -> DN#0405734
=#

end  # TEST

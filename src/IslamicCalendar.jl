# This is part of Calendars.jl. See the copyright note there.
# ======================== Islamic dates ====================

TEST = false
if TEST
    include("CalendarUtils.jl")
end

# The start of the Islamic calendar is AH 1, Muharram 1. 
# That is equivalent to JD 622, July 16. We do not support
# dates prior to this date (no 'proleptic' Islamic calendar).
# Day number of the start of the Islamic calendar.
# AH-0001-01-01 = JD-0622-07-16 ~ DN#227015 = EpochIslamic
# AH-1111-11-11 = JD-1700-04-19 ~ DN#620667
# AH-6666-12-29 = JD-7089-11-28 ~ DN#2589222
const EpochIslamic = 227015 
const ValidYearsIslamic = (1, 9666) # by convention

# True if year is an Islamic leap year.
function isLeapYearIslamic(year::DPart)
    return rem(11 * year + 14, 30) < 11
end

# Last month of Islamic year.
function LastMonthOfYearIslamic(year::DPart)
    isLeapYearIslamic(year) ? 13 : 12
end

# Last day in month during year on the Islamic calendar.
function LastDayOfMonthIslamic(year::DPart, month::DPart)
    b = (rem(month, 2) == 1 
      || (month == 12 && isLeapYearIslamic(year)))
    return b ? 30 : 29
end

# Is the date a valid Islamic date?
function isValidDateIslamic(cd::CDate, warn=true)
    cal, year, month, day = cd
    val = (CName(cal) == AH 
        && (ValidYearsIslamic[1] <= year && year <= ValidYearsIslamic[2]) 
        && (1 <= month && month <= LastMonthOfYearIslamic(year))
        && (1 <= day && day <= LastDayOfMonthIslamic(year, month)))
    ! val && warn && @warn(Warning(cd))
    return val
end

# Represents the day number a valid Islamic date?
function isValidDateIslamic(dn::DPart, warn=true)
    val = EpochIslamic <= dn
    ! val && warn && @warn(Warning(dn))
    return val
end

# Return the days this year so far.
# Does not depend on 'year' but kept in the signature.
function DayOfYearIslamic(year::DPart, month::DPart, day::DPart) 
    # days so far this month plus ...
    day += ( 29 * (month - 1)   # days so far...
        + div(month, 2)         #   ...this year
    )
    return day 
end

# Computes the day number from a valid Islamic date.
function DayNumberIslamic(year::DPart, month::DPart, day::DPart)

    day = DayOfYearIslamic(year, month, day)
    days = (EpochIslamic - 1      # days before start of calendar 
         + 354 * (year - 1)       # non-leap days in prior years
         + div(3 + 11 * year, 30) # leap days in prior years
    )
    return day + days 
end

# Computes the day number from a valid Islamic date.
DayNumberIslamic(d::CDate) = DayNumberIslamic(d[2], d[3], d[4])

# Computes the Islamic date from the day number.
function DateIslamic(dn::DPart)
    ! isValidDateIslamic(dn, false) && return InvalidDate

    # Search forward year by year from approximate year.
    year = div(dn - EpochIslamic, 355)
    while dn >= DayNumberIslamic(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from Muharram.
    month = 1
    while dn > DayNumberIslamic(year, month,
                  LastDayOfMonthIslamic(year, month))
        month += 1
    end

    day = dn - DayNumberIslamic(year, month, 1) + 1

    return (AH, year, month, day)::CDate
end

# Return the day number of the first day in the given Islamic year.
function YearStartIslamic(year::DPart) 
    return DayNumberIslamic(year, 1, 1) 
end

# Return the day number of the last day in the given Islamic year.
function YearEndIslamic(year::DPart) 
    return DayNumberIslamic(year + 1, 1, 1) - 1
end

# Return the number of months in the given Islamic year.
function MonthsInYearIslamic(year::DPart) 
    return LastMonthOfYearIslamic(year)
end

# Return the number of days in the given Islamic year.
function DaysInYearIslamic(year::DPart) 
    return YearStartIslamic(year + 1) - YearStartIslamic(year) 
end

if TEST

    for n in 0:3
        local dn = 227015 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateIslamic(dn)))
    end
    for n in 0:3
        local date = (AH, 1, 1, 1 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberIslamic(date)))
    end

    for n in 0:2
        local dn = 2589220 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateIslamic(dn)))
    end
    for n in 0:2
        local date = (AH, 6666, 12, 27 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberIslamic(date)))
    end

    for n in 0:2
        local dn = 620666 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateIslamic(dn)))
    end
    for n in 0:2
        local date = (AH, 1111, 11, 10 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberIslamic(date)))
    end

#=
DN#0227015 -> AH-0001-01-01
DN#0227016 -> AH-0001-01-02
DN#0227017 -> AH-0001-01-03
DN#0227018 -> AH-0001-01-04
AH-0001-01-01 -> DN#0227015
AH-0001-01-02 -> DN#0227016
AH-0001-01-03 -> DN#0227017
AH-0001-01-04 -> DN#0227018
DN#2589220 -> AH-6666-12-27
DN#2589221 -> AH-6666-12-28
DN#2589222 -> AH-6666-12-29
AH-6666-12-27 -> DN#2589220
AH-6666-12-28 -> DN#2589221
AH-6666-12-29 -> DN#2589222
DN#0620666 -> AH-1111-11-10
DN#0620667 -> AH-1111-11-11
DN#0620668 -> AH-1111-11-12
AH-1111-11-10 -> DN#0620666
AH-1111-11-11 -> DN#0620667
AH-1111-11-12 -> DN#0620668
=#

end  # TEST

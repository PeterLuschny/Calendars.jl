# This is part of Calendars.jl. See the copyright note there.
# ====================== Gregorian dates ====================

# Day number of the start of the Gregorian calendar.
const EpochGregorian = 1
const ValidYearsGregorian = 1:9999

# Is a divisible by b?
divisible(a, b) = rem(a, b) == 0

function isLeapYearGregorian(year::DPart)
    (divisible(year, 4) && ! divisible(year, 100)) || divisible(year, 400) 
end

# Return the last day of the month for the Gregorian calendar.
function LastDayOfMonthGregorian(year::DPart, month::DPart) 
    leap = isLeapYearGregorian(year)
    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Is the date a valid Gregorian date?
function isValidDateGregorian(cd::CDate)
    cal, year, month, day = cd
    if CName(cal) != CE 
        @warn(Warning(cd))
        return false
    end
    ldm = LastDayOfMonthGregorian(year, month)
    val = (year in ValidYearsGregorian) && (month in 1:12) && (day in 1:ldm) 
    !val && @warn(Warning(cd))
    return val
end

# Return the days this year so far.
function DayOfYearGregorian(year::DPart, month::DPart, day::DPart) 
    for m in (month - 1):-1:1  # days in prior months this year
        day += LastDayOfMonthGregorian(year, m)
    end
    return day
end

# Computes the day number from a valid Gregorian date.
function DayNumberValidGregorian(year::DPart, month::DPart, day::DPart) 
    day = DayOfYearGregorian(year, month, day) 

    return (day                # days this year
        + 365 * (year - 1)     # days in previous years ignoring leap days
        + div(year - 1, 4)     # Julian leap days before this year...
        - div(year - 1, 100)   # ...minus prior century years...
        + div(year - 1, 400) ) # ...plus prior years divisible by 400
end

# Computes the day number from a date which might not be a valid Gregorian date.
function DayNumberGregorian(cd::CDate)
    cal, year, month, day = cd
    if isValidDateGregorian((CE, year, month, day))
        return DayNumberValidGregorian(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Gregorian date.
function DayNumberGregorian(year::DPart, month::DPart, day::DPart)
    if isValidDateGregorian((CE, year, month, day)) 
        return DayNumberValidGregorian(year, month, day) 
    end
    return InvalidDayNumber
end

# Computes the Gregorian date from a day number.
function DateGregorian(dn::DPart) 
    if dn < EpochGregorian  # Date is pre-Gregorian
       @warn(Warning(CE))
       return InvalidDate
    end

    year = div(dn, 366)

    # Search forward year by year from approximate year.
    while dn >= DayNumberValidGregorian(year + 1, 1, 1)
        year += 1 
    end

    # Search forward month by month from January.
    month = 1
    while dn > DayNumberValidGregorian(year, month, 
                LastDayOfMonthGregorian(year, month))
        month += 1
    end

    day = dn - DayNumberValidGregorian(year, month, 1) + 1
    return (CE, year, month, day)::CDate
end

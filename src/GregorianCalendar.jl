# This is part of Calendars.jl. See the copyright note there.
# ====================== Gregorian dates ====================

# Day number of the start of the Gregorian calendar.
const EpochGregorian = 1

# Is a divisible by b?
divisible(a, b) = rem(a, b) == 0

function isLeapYearGregorian(year)
    (divisible(year, 4) && divisible(year, 100)) || divisible(year, 400) 
end

# Return the last day of the month for the Gregorian calendar.
function LastDayOfMonthGregorian(year, month) 
    leap = isLeapYearGregorian(year)
    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Is the date a valid Gregorian date?
function isValidDateGregorian(year, month, day)
    ld = LastDayOfMonthGregorian(year, month)
    year >= 1 && (month in 1:12) && (day in 1:ld) 
end

# Return the days this year so far.
function DayOfYearGregorian(year, month, day) 
    for m in (month - 1):-1:1  # days in prior months this year
        day += LastDayOfMonthGregorian(year, m)
    end
    return day
end

# Computes the day number from a valid Gregorian date.
function DNumberValidGregorian(year, month, day) 
    day = DayOfYearGregorian(year, month, day) 

    return (day                # days this year
        + 365 * (year - 1)     # days in previous years ignoring leap days
        + div(year - 1, 4)     # Julian leap days before this year...
        - div(year - 1, 100)   # ...minus prior century years...
        + div(year - 1, 400) ) # ...plus prior years divisible by 400
end

# Computes the day number from a date which might not be a valid Gregorian date.
DNumberGregorian(year, month, day) = 
(isValidDateGregorian(year, month, day) ? DNumberValidGregorian(year, month, day) : 0)

# Computes the day number from a date which might not be a valid Gregorian date.
DNumberGregorian(date) = DNumberGregorian(date[1], date[2], date[3])

# Computes the Gregorian date from a day number.
function DateGregorian(dn) 
    if dn < EpochGregorian  # Date is pre-Gregorian
       @warn(Warning(CE))
       return InvalidDate
    end

    year = div(dn, 366)

    # Search forward year by year from approximate year.
    while dn >= DNumberValidGregorian(year + 1, 1, 1)
        year += 1 
    end

    # Search forward month by month from January.
    month = 1
    while dn > DNumberValidGregorian(year, month, 
                LastDayOfMonthGregorian(year, month))
        month += 1
    end

    day = dn - DNumberValidGregorian(year, month, 1) + 1
    return (CE, year, month, day)
end

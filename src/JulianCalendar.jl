# This is part of Calendars.jl. See the copyright note there.
# ========================= Julian dates ====================

# Day number of the start of the Julian calendar.
const EpochJulian = -2

function isLeapYearJulian(year)
    rem(year, 4) == 0
end

# Return the last day of the month for the Julian calendar.
function LastDayOfMonthJulian(year, month)
    leap = isLeapYearJulian(year)
    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Is the date a valid Julian date?
function isValidDateJulian(year, month, day)
    ld = LastDayOfMonthJulian(year, month)
    year >= 1 && (month in 1:12) && (day in 1:ld) 
end

# Returns the day number from the Julian date.
function DNumberValidJulian(year, month, day)
    for m in (month-1):-1:1  # days in prior months this year
        day += LastDayOfMonthJulian(year, m)
    end

    return (EpochJulian      # days elapsed before absolute date 1
        + 365 * (year - 1)   # days in previous years ignoring leap days
        + div(year - 1, 4)   # leap days before this year...
        + day                # days this year
    )
end


# Computes the day number from a date which might not be a valid Julian date.
DNumberJulian(year, month, day) = 
(isValidDateJulian(year, month, day) ? DNumberValidJulian(year, month, day) : 0)

# Computes the day number from a date which might not be a valid Julian date.
DNumberJulian(date) = DNumberJulian(date[1], date[2], date[3])

# Computes the Julian date from the day number.
function DateJulian(dn)
    if dn < EpochJulian  # Date is pre-Julian
       @warn(Warning(AD))
       return InvalidDate
    end

    # Search forward year by year from approximate year
    year = div(dn + EpochJulian, 366)

    while dn >= DNumberValidJulian(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from January
    month = 1
    while dn > DNumberValidJulian(year, month, 
               LastDayOfMonthJulian(year, month))
        month += 1
    end

    day = dn - DNumberValidJulian(year, month, 1) + 1
    return (AD, year, month, day)
end

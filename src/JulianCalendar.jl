# This is part of Calendars.jl. See the copyright note there.
# ========================= Julian dates ====================

# Day number of the start of the Julian calendar.
const JulianEpoch = -2

# Return the last day of the month for the Julian calendar.
function LastDayOfJulianMonth(year, month)
    leap = rem(year, 4) == 0

    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Returns the day number from the Julian date.
function DNumberJulian(year, month, day)
    for m in (month-1):-1:1  # days in prior months this year
        day += LastDayOfJulianMonth(year, m)
    end

    return (JulianEpoch      # days elapsed before absolute date 1
        + 365 * (year - 1)   # days in previous years ignoring leap days
        + div(year - 1, 4)   # leap days before this year...
        + day                # days this year
    )
end

# Computes the day number from the Julian date = (year, month, day).
DNumberJulian(date) = DNumberJulian(date[1], date[2], date[3])

# Computes the Julian date from the day number.
function JulianDate(dn)
    if dn < JulianEpoch  # Date is pre-Julian
       @warn(Warning(AD))
       return InvalidDate
    end

    # Search forward year by year from approximate year
    year = div(dn + JulianEpoch, 366)

    while dn >= DNumberJulian(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from January
    month = 1
    while dn > DNumberJulian(year, month, 
               LastDayOfJulianMonth(year, month))
        month += 1
    end

    day = dn - DNumberJulian(year, month, 1) + 1
    return (AD, year, month, day)
end

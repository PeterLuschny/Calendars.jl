# This is part of Calendars.jl. See the copyright note there.
# ========================= Julian dates ====================

# Day number of the start of the Julian calendar.
const EpochJulian = -2

function isLeapYearJulian(year::Int64)
    rem(year, 4) == 0
end

# Return the last day of the month for the Julian calendar.
function LastDayOfMonthJulian(year::Int64, month::Int64)
    leap = isLeapYearJulian(year)
    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Is the date a valid Julian date?
function isValidDateJulian(cd::CDate)
    cal, year, month, day = cd
    if CName(cal) != AD 
        @warn(Warning(cd))
        return false
    end
    ldm = LastDayOfMonthJulian(year, month)
    val = (year >= 1) && (month in 1:12) && (day in 1:ldm) 
    !val && @warn(Warning(cd))
    return val
end

# Return the days this year so far.
function DayOfYearJulian(year::Int64, month::Int64, day::Int64) 
    for m in (month - 1):-1:1  # days in prior months this year
        day += LastDayOfMonthJulian(year, m)
    end
    return day
end

# Returns the day number from a valid Julian date.
function DayNumberValidJulian(year::Int64, month::Int64, day::Int64)
    day = DayOfYearJulian(year, month, day) 

    return (EpochJulian      # days elapsed before absolute date 1
        + 365 * (year - 1)   # days in previous years ignoring leap days
        + div(year - 1, 4)   # leap days before this year...
        + day                # days this year
    )
end


# Computes the day number from a date which might not be a valid Julian date.
function DayNumberJulian(cd::CDate) 
    cal, year, week, day = cd
    if isValidDateJulian((AD, year, week, day)) 
        return DayNumberValidJulian(year, week, day)
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Julian date.
function DayNumberJulian(year::Int64, month::Int64, day::Int64) 
    if isValidDateJulian((AD, year, month, day)) 
        return DayNumberValidJulian(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the Julian date from the day number.
function DateJulian(dn::Int64)
    if dn < EpochJulian    # Date is pre-Julian
       @warn(Warning(AD))
       return InvalidDate
    end

    # Search forward year by year from approximate year
    year = div(dn + EpochJulian, 366)

    while dn >= DayNumberValidJulian(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from January
    month = 1
    while dn > DayNumberValidJulian(year, month, 
                    LastDayOfMonthJulian(year, month))
        month += 1
    end

    day = dn - DayNumberValidJulian(year, month, 1) + 1
    return (AD, year, month, day)
end

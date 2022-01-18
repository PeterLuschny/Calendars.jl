# This is part of Calendars.jl. See the copyright note there.
# ======================== Islamic dates ====================

# Islamic Year 1 (Muharram 1, 1 A.H.) is equivalent 
# to day number 227015 (Friday, July 16, 622 C.E. - Julian).
# Days before the start of the Islamic calendar.
const EpochIslamic = 227014 

# True if year is an Islamic leap year.
function isLeapYearIslamic(year::Int64)::Bool
    return rem(11 * year + 14, 30) < 11
end

# Last month of Islamic year.
function LastMonthOfYearIslamic(year::Int64)
    isLeapYearIslamic(year) ? 13 : 12
end

# Last day in month during year on the Islamic calendar.
function LastDayOfMonthIslamic(year::Int64, month::Int64)
    b = (rem(month, 2) == 1 
      || (month == 12 && isLeapYearIslamic(year)))
    return b ? 30 : 29
end

# Is the date a valid Islamic date?
function isValidDateIslamic(d::CDate)
    d[1] != AH && return false
    lm = LastMonthOfYearIslamic(d[2])
    ld = LastDayOfMonthIslamic(d[2], d[3])
    b = (d[2] >= 1) && (d[3] in 1:lm) && (d[4] in 1:ld) 
    !b && @warn("$d is not a valid Islamic date!")
    return b
end

# Return the days this year so far.
# Does not depend on 'year' but kept in the signature.
function DayOfYearIslamic(year::Int64, month::Int64, day::Int64) 
    # days so far this month plus ...
    day += ( 29 * (month - 1)   # days so far...
        + div(month, 2)         #   ...this year
    )
    return day 
end

# Computes the day number from a valid Islamic date.
function DNumberValidIslamic(year::Int64, month::Int64, day::Int64)

    day = DayOfYearIslamic(year, month, day)
    days = (EpochIslamic          # days before start of calendar 
         + 354 * (year - 1)       # non-leap days in prior years
         + div(3 + 11 * year, 30) # leap days in prior years
    )
    return day + days
end

# Computes the day number from a valid Islamic date.
DNumberValidIslamic(d::CDate) = DNumberValidIslamic(d[2], d[3], d[4])

# Computes the day number from a date which might not be a valid Islamic date.
function DNumberIslamic(year::Int64, month::Int64, day::Int64)  
    if isValidDateIslamic((AH, year, month, day)) 
        return DNumberValidIslamic(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Islamic date.
function DNumberIslamic(d::CDate) 
    if isValidDateIslamic((AH, d[2], d[3], d[4]))
        return DNumberValidIslamic(d[2], d[3], d[4])
    end
    return InvalidDayNumber
end

# Computes the Islamic date from the day number.
function DateIslamic(dn::Int64)
    if dn < EpochIslamic  # date is pre-Islamic
        @warn(Warning(AH))
        return InvalidDate
    end

    # Search forward year by year from approximate year.
    year = div(dn - EpochIslamic, 355)
    while dn >= DNumberValidIslamic(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from Muharram.
    month = 1
    while dn > DNumberValidIslamic(year, month,
                  LastDayOfMonthIslamic(year, month))
        month += 1
    end

    day = dn - DNumberValidIslamic(year, month, 1) + 1

    return (AH, year, month, day)
end

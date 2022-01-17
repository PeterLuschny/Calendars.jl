# This is part of Calendars.jl. See the copyright note there.
# ======================== Islamic dates ====================

# Islamic Year 1 (Muharram 1, 1 A.H.) is equivalent 
# to day number 227015 (Friday, July 16, 622 C.E. - Julian).
# Days before the start of the Islamic calendar.
const EpochIslamic = 227014 

# True if year is an Islamic leap year.
function isLeapYearIslamic(year)
    return rem(11 * year + 14, 30) < 11
end

# Last month of Islamic year.
function LastMonthOfYearIslamic(year)
    isLeapYearIslamic(year) ? 13 : 12
end

# Last day in month during year on the Islamic calendar.
function LastDayOfMonthIslamic(year, month)
    b = (rem(month, 2) == 1 
        || (month == 12 && isLeapYearIslamic(year)))
    return b ? 30 : 29
end

# Is the date a valid Islamic date?
function isValidDateIslamic(year, month, day)
    lm = LastMonthOfYearIslamic(year)
    ld = LastDayOfMonthIslamic(year, month)
    year >= 1 && (month in 1:lm) && (day in 1:ld) 
end

# Return the days this year so far.
function DayOfYearIslamic(year, month, day) 
                        # days so far this month
    day += ( 29 * (month - 1)   # days so far...
        + div(month, 2)         #   ...this year
    )
    return day 
end

# Computes the day number from a valid Islamic date.
function DNumberValidIslamic(year, month, day)

    day = DayOfYearIslamic(year, month, day)
    days = (EpochIslamic         # days before start of calendar 
        + 354 * (year - 1)       # non-leap days in prior years
        + div(3 + 11 * year, 30) # leap days in prior years
    )
    return day + days
end

# Computes the day number from a valid Islamic date.
DNumberValidIslamic(date) = DNumberValidIslamic(date[1], date[2], date[3])

# Computes the day number from a date which might not be a valid Islamic date.
DNumberIslamic(year, month, day) = 
(isValidDateIslamic(year, month, day) ? DNumberValidIslamic(year, month, day) : 0)

# Computes the day number from a date which might not be a valid Islamic date.
DNumberIslamic(date) = DNumberIslamic(date[1], date[2], date[3])

# Computes the Islamic date from the day number.
function DateIslamic(dn)
    if dn < EpochIslamic  # Date is pre-Islamic
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

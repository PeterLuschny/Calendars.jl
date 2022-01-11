# This is part of Calendars.jl. See the copyright note there.
# ======================== Islamic dates ====================

# Day number of the start of the Islamic calendar.
const IslamicEpoch = 227014 

# True if year is an Islamic leap year.
function IslamicLeapYear(year)
    return rem(11 * year + 14, 30) < 11
end

# Last day in month during year on the Islamic calendar.
function LastDayOfIslamicMonth(year, month)
    b = (rem(month, 2) == 1 
        || (month == 12 && IslamicLeapYear(year)))
    return b ? 30 : 29
end

# Computes the day number from the Islamic date = (year, month, day).
function DNumberIslamic(year, month, day)

    day += (IslamicEpoch         # days before start of calendar 
        + 29 * (month - 1)       # days so far...
        + div(month, 2)          #            ...this year
        + 354 * (year - 1)       # non-leap days in prior years
        + div(3 + 11 * year, 30) # leap days in prior years
    )
    return day
end

# Computes the day number from the Islamic date = (year, month, day).
DNumberIslamic(date) = DNumberIslamic(date[1], date[2], date[3])

# Computes the Islamic date from the day number.
function IslamicDate(dn)
    if dn < IslamicEpoch  # Date is pre-Islamic
        @warn(Warning(AH))
        return InvalidDate
    end

    # Search forward year by year from approximate year.
    year = div(dn - IslamicEpoch, 355)
    while dn >= DNumberIslamic(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from Muharram.
    month = 1
    while dn > DNumberIslamic(year, month,
                  LastDayOfIslamicMonth(year, month))
        month += 1
    end

    day = dn - DNumberIslamic(year, month, 1) + 1

    return (AH, year, month, day)
end

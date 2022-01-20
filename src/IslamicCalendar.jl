# This is part of Calendars.jl. See the copyright note there.
# ======================== Islamic dates ====================

# Islamic Year 1 (Muharram 1, 1 A.H.) is equivalent 
# to day number 227015 (Friday, July 16, 622 CE - Julian).
# Days before the start of the Islamic calendar.
const EpochIslamic = 227014 
const ValidYearsIslamic = 1:9666

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
function isValidDateIslamic(cd::CDate)
    cal, year, month, day = cd
    if CName(cal) != AH 
        @warn(Warning(cd))
        return false
    end
    lmy = LastMonthOfYearIslamic(year)
    ldm = LastDayOfMonthIslamic(year, month)
    val = (year in ValidYearsIslamic) && (month in 1:lmy) && (day in 1:ldm) 
    !val && @warn(Warning(cd))
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
function DayNumberValidIslamic(year::DPart, month::DPart, day::DPart)

    day = DayOfYearIslamic(year, month, day)
    days = (EpochIslamic          # days before start of calendar 
         + 354 * (year - 1)       # non-leap days in prior years
         + div(3 + 11 * year, 30) # leap days in prior years
    )
    return day + days
end

# Computes the day number from a valid Islamic date.
DayNumberValidIslamic(d::CDate) = DayNumberValidIslamic(d[2], d[3], d[4])

# Computes the day number from a date which might not be a valid Islamic date.
function DayNumberIslamic(year::DPart, month::DPart, day::DPart)  
    if isValidDateIslamic((AH, year, month, day)) 
        return DayNumberValidIslamic(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Islamic date.
function DayNumberIslamic(cd::CDate) 
    cal, year, month, day = cd
    if isValidDateIslamic((AH, year, month, day))
        return DayNumberValidIslamic(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the Islamic date from the day number.
function DateIslamic(dn::DPart)
    if dn < EpochIslamic  # date is pre-Islamic
        @warn(Warning(AH))
        return InvalidDate
    end

    # Search forward year by year from approximate year.
    year = div(dn - EpochIslamic, 355)
    while dn >= DayNumberValidIslamic(year + 1, 1, 1)
        year += 1
    end

    # Search forward month by month from Muharram.
    month = 1
    while dn > DayNumberValidIslamic(year, month,
                  LastDayOfMonthIslamic(year, month))
        month += 1
    end

    day = dn - DayNumberValidIslamic(year, month, 1) + 1

    return (AH, year, month, day)::CDate
end

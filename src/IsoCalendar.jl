# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

# Day number of the start of the ISO calendar.
# ID-0001-01-01 = CE-0001-01-01 ~ DN#1 = EpochIso.
# ID-1111-45-04 = CE-1111-11-11 ~ DN#0405733
# ID-9999-52-05 = CE-9999-12-31 ~ DN#3652059
const EpochIso = 1
const ValidYearsIso = (0, 9999) # by convention

# Day of week in ISO is represented by an integer from 1 through 7, 
# beginning with Monday and ending with Sunday, which is
# different from our enumeration, so we have to adjust.
function DayOfWeekIso(dn::DPart) 
    day = rem(dn, weeklen)   
    return day == 0 ? 7 : day
end

# True if year is an Iso leap year.
function isLeapYearIso(year::DPart)
    f(y) = rem(y + div(y, 4) - div(y, 100) + div(y, 400), 7) 
    f(year) == 4 || f(year - 1) == 3
end

# Return the last week of the year for the Iso calendar.
function LastWeekOfYearIso(year::DPart)
    isLeapYearIso(year) ? 53 : 52
end

# Is the date a valid Iso date?
function isValidDateIso(cd::CDate, warn=true)
    cal, year, week, day = cd
    val = ( cal == ID 
        && (ValidYearsIso[1] <= year && year <= ValidYearsIso[2]) 
        && (1 <= week && week <= LastWeekOfYearIso(year)) 
        && (1 <= day && day <= 7) 
    )
    ! val && warn && @warn(Warning(cd))
    return val
end

# Represents the day number a valid Iso date?
function isValidDateIso(dn::DPart, warn=true)
    # val = EpochGregorian - 2 <= dn
    val = -1 <= dn  
    ! val && warn && @warn(Warning(dn))
    return val
end

# Return the days this year so far.
# Does not depend on 'year' but keep it in the signature.
function DayOfYearIso(year::DPart, week::DPart, day::DPart) 
    day += 7 * (week - 1)  # days in prior weeks this year
    return day - 1
end

XdayOnOrBefore(dn, x) = dn - rem(dn - x, weeklen)

# Return the number of days in prior years.
function DaysInPriorYears(year::DPart)
    # dn = DayNumberGregorian(year, 1, 4)
    # Let's make it self-contained!
    dn = ( 4           # days this year
    + 365 * year       # days in previous years ignoring leap days
    + div(year, 4)     # Julian leap days before this year...
    - div(year, 100)   # ...minus prior century years...
    + div(year, 400)   # ...plus prior years divisible by 400
    )
    return XdayOnOrBefore(dn, 1)
end

# Returns the day number from a valid ISO date.
function DayNumberIso(year::DPart, week::DPart, day::DPart) 
    ( 
    DaysInPriorYears(year - 1) # days in prior years
    + 7 * (week - 1)           # days in prior weeks this year
    + day - 1                  # prior days this week
    )
end

# Computes the day number from a valid ISO date.
DayNumberIso(d::CDate) = DayNumberIso(d[2], d[3], d[4])

# Computes the ISO date from a day number.
function DateIso(dn::DPart)
    ! isValidDateIso(dn) && return InvalidDate

    # Patch in the two allowed exceptions.
    dn == -1 && return (ID, 0, 52, 6)
    dn ==  0 && return (ID, 0, 52, 7)

    # year = DateGregorian(dn - 3)[2]
    # Let's make it self-contained!
    year = div(400 * (dn - 4), 146097) + 1

    if dn >= YearStartIso(year + 1) 
        year += 1 
    end
    week = 1 + div(dn - YearStartIso(year), weeklen)
    day = DayOfWeekIso(dn)
    return (ID, year, week, day)::CDate
end

# Return the day number of the first day in the given Iso year.
function YearStartIso(year::DPart) 
    return DayNumberIso(year, 1, 1)
end

# Return the day number of the last day in the given Iso year.
function YearEndIso(year::DPart) 
    return DayNumberIso(year + 1, 1, 1) - 1
end

# Return the number of weeks in the given Iso year.
function WeeksInYearIso(year::DPart) 
    return LastWeekOfYearIso(year) 
end

# Return the number of days in the given Iso year.
function DaysInYearIso(year::DPart) 
    return YearStartIso(year + 1) - YearStartIso(year)
end

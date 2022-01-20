# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

# The day number of the day x on or before the day with number dn.
# x = 0 means Sunday, x = 1 means Monday, and so on.
XdayOnOrBefore(dn, x) = dn - rem(dn - x, 7)

function isLeapYearIso(year::DPart)
    f(y) = rem(y + div(y, 4) - div(y, 100) + div(y, 400), 7) 
    f(year) == 4 || f(year - 1) == 3
end

# Return the last week of the year for the Iso calendar.
function LastWeekOfYearIso(year::DPart)
    isLeapYearIso(year) ? 53 : 52
end

# Is the date a valid Iso date?
function isValidDateIso(cd::CDate)
    cal, year, week, day = cd
    if CName(cal) != ID 
        @warn(Warning(cd))
        return false
    end
    lwy = LastWeekOfYearIso(year)
    val = (year in 1:MaxYear) && (week in 1:lwy) && (day in 1:7) 
    !val && @warn(Warning(cd))
    return val
end

# Return the days this year so far.
# Does not depend on 'year' but kept in the signature.
function DayOfYearIso(year::DPart, week::DPart, day::DPart) 
    day += 7 * (week - 1)  # days in prior weeks this year
    return day - 1
end

# Computes the day number from a valid ISO date.
function DayNumberValidIso(year::DPart, week::DPart, day::DPart) 
          # days in prior years
    prior = XdayOnOrBefore(DayNumberGregorian(year, 1, 4), 1)
    day  = DayOfYearIso(year, week, day) 
    return prior + day
end

# Computes the day number from a valid ISO date.
DayNumberValidIso(d::CDate) = DayNumberValidIso(d[2], d[3], d[4])

# Computes the day number from a date which might not be a valid Iso date.
function DayNumberIso(year::DPart, month::DPart, day::DPart)  
    if isValidDateIso((ID, year, month, day)) 
        return DayNumberValidIso(year, month, day) 
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Iso date.
function DayNumberIso(cd::CDate)
    cal, year, week, day = cd  
    if isValidDateIso((ID, year, week, day))
        return DayNumberValidIso(year, week, day)
    end
    return InvalidDayNumber
end

# Computes the ISO date from a day number.
function DateIso(dn::DPart)

    # year = DateGregorian(dn - 3)[2]
    d = dn - 3
    year = div(d, 366)
    # Search forward year by year from approximate year.
    while d >= DayNumberValidGregorian(year + 1, 1, 1)
        year += 1 
    end

    # Search forward year by year from approximate year.
    if dn >= DayNumberValidIso(year + 1, 1, 1) 
        year += 1
    end
                     # Sunday : Monday..Saturday
    day = rem(dn, 7) == 0 ? 7 : rem(dn, 7)
    week = 1 + div(dn - DayNumberValidIso(year, 1, 1), 7)
    return (ID, year, week, day)::CDate
end

# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

# The day number of the day x on or before the day with number dn.
# x = 0 means Sunday, x = 1 means Monday, and so on.
XdayOnOrBefore(dn, x) = dn - rem(dn - x, 7)

function isLeapYearIso(year::Int64)
    f(y) = rem(y + div(y, 4) - div(y, 100) + div(y, 400), 7) 
    f(year) == 4 || f(year - 1) == 3
end

# Return the last week of the year for the Iso calendar.
function LastWeekOfYearIso(year::Int64)
    isLeapYearIso(year) ? 53 : 52
end

# Is the date a valid Iso date?
function isValidDateIso(d::CDate)
    d[1] != ID && return false
    lw = LastWeekOfYearIso(d[2])
    # of course "d[3]" is a misnomer but does not hurt
    b = d[2] >= 1 && (d[3] in 1:lw) && (d[4] in 1:7) 
    !b && @warn(Warning(ID))
    return b
end

# Return the days this year so far.
# Does not depend on 'year' but kept in the signature.
function DayOfYearIso(year::Int64, week::Int64, day::Int64) 
    day += 7 * (week - 1)  # days in prior weeks this year
    return day - 1
end

# Computes the day number from a valid ISO date.
function DNumberValidIso(year::Int64, week::Int64, day::Int64) 
          # days in prior years
    prior = XdayOnOrBefore(DNumberGregorian(year, 1, 4), 1)
    day  = DayOfYearIso(year, week, day) 
    return prior + day
end

# Computes the day number from a valid ISO date.
DNumberValidIso(d::CDate) = DNumberValidIso(d[2], d[3], d[4])

# Computes the day number from a date which might not be a valid Iso date.
function DNumberIso(year::Int64, month::Int64, day::Int64)  
    if isValidDateIso((ID, year, month, day)) 
        return DNumberValidIso(year, month, day) 
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Iso date.
function DNumberIso(d::CDate)  
    if isValidDateIso((ID, d[2], d[3], d[4]))
        return DNumberValidIso(d[2], d[3], d[4])
    end
    return InvalidDayNumber
end

# Computes the ISO date from a day number.
function DateIso(dn::Int64)

    # year = DateGregorian(dn - 3)[2]
    d = dn - 3
    year = div(d, 366)
    # Search forward year by year from approximate year.
    while d >= DNumberValidGregorian(year + 1, 1, 1)
        year += 1 
    end

    # Search forward year by year from approximate year.
    if dn >= DNumberValidIso(year + 1, 1, 1) 
        year += 1
    end
                     # Sunday : Monday..Saturday
    day = rem(dn, 7) == 0 ? 7 : rem(dn, 7)
    week = 1 + div(dn - DNumberValidIso(year, 1, 1), 7)
    return (ID, year, week, day)
end

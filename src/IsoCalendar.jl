# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

# The day number of the day x on or before the day with number dn.
# x = 0 means Sunday, x = 1 means Monday, and so on.
XdayOnOrBefore(dn, x) = dn - rem(dn - x, 7)

function isLeapYearIso(year)
    f(y) = rem(y + div(y, 4) - div(y, 100) + div(y, 400), 7) 
    f(year) == 4 || f(year - 1) == 3
end

# Return the last week of the year for the Iso calendar.
function LastWeekOfYearIso(year)
    isLeapYearIso(year) ? 53 : 52
end

# Is the date a valid Iso date?
function isValidDateIso(year, week, day)
    lw = LastWeekOfYearIso(year)
    year >= 1 && (week in 1:lw) && (day in 1:7) 
end

# Return the days this year so far.
function DayOfYearIso(year, week, day) 
    day += 7 * (week - 1)  # days in prior weeks this year
    return day - 1
end

# Computes the day number from a valid ISO date.
function DNumberValidIso(year, week, day) 
          # days in prior years
    prior = XdayOnOrBefore(DNumberGregorian(year, 1, 4), 1)
    day  = DayOfYearIso(year, week, day) 
    return prior + day
end

# Computes the day number from a valid ISO date.
DNumberValidIso(date) = DNumberValidIso(date[1], date[2], date[3])

# Computes the day number from a date which might not be a valid Iso date.
DNumberIso(year, week, day) = 
(isValidDateIso(year, week, day) ? DNumberValidIso(year, week, day) : 0)

# Computes the day number from a date which might not be a valid Iso date.
DNumberIso(date) = DNumberIso(date[1], date[2], date[3])

# Computes the ISO date from a day number.
function DateIso(dn)

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

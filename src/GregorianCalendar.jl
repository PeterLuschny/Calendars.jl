# This is part of Calendars.jl. See the copyright note there.
# ====================== Gregorian dates ====================

# Is a divisible by b?
divisible(a, b) = rem(a, b) == 0

# Return the last day of the month for the Gregorian calendar.
function LastDayOfGregorianMonth(year, month) 
    leap = (( divisible(year, 4) && divisible(year, 100))
           || divisible(year, 400) )

    month == 2 && return leap ? 29 : 28
    month in [4, 6, 9, 11] ? 30 : 31
end

# Computes the day number from the Gregorian date = (year, month, day).
function DNumberGregorian(year, month, day) 
    for m in (month - 1):-1:1  # days in prior months this year
        day += LastDayOfGregorianMonth(year, m)
    end

    return (day              # days this year
        + 365 * (year - 1)   # days in previous years ignoring leap days
        + div(year - 1, 4)   # Julian leap days before this year...
        - div(year - 1, 100) # ...minus prior century years...
        + div(year - 1, 400) ) # ...plus prior years divisible by 400
end        

# Computes the day number from the Gregorian date = (year, month, day).
DNumberGregorian(date) = DNumberGregorian(date[1], date[2], date[3])

# Computes the Gregorian date from a day number.
function GregorianDate(dn) 
    if dn <= 0  # Date is pre-Gregorian
       return (0, 0, 0)
    end

    year = div(dn, 366)

    # Search forward year by year from approximate year.
    while dn >= DNumberGregorian(year + 1, 1, 1)
        year += 1 
    end

    # Search forward month by month from January
    month = 1
    while dn > DNumberGregorian(year, month, 
                LastDayOfGregorianMonth(year, month))
        month += 1
    end

    day = dn - DNumberGregorian(year, month, 1) + 1
    return (year, month, day)
end

# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

# The day number of the x-day on or before the day with number dn.
# x = 0 means Sunday, x = 1 means Monday, and so on.
XdayOnOrBefore(dn, x) = dn - rem(dn - x, 7)

# Computes the day number from the ISO date = (year, week, day).
function DNumberIso(year, week, day) 

    prior = XdayOnOrBefore(DNumberGregorian(year, 1, 4), 1)
    return ( prior             # days in prior years
           + 7 * (week - 1)    # days in prior weeks this year
           + (day - 1)         # prior days this week
    )
end

# Computes the day number from the ISO date = (year, week, day).
DNumberIso(date) = DNumberIso(date[1], date[2], date[3])

# Computes the ISO date from a day number.
function IsoDate(dn)

        dng = dn - 3;
        year = div(dng, 366)

        # Search forward year by year from approximate year.
        while dng >= DNumberGregorian(year + 1, 1, 1)
            year += 1 
        end
        if dn >= DNumberIso(year + 1, 1, 1) 
            year += 1
        end
                         # Sunday : Monday..Saturday
        day = rem(dn, 7) == 0 ? 7 : rem(dn, 7)
        week = 1 + div(dn - DNumberIso(year, 1, 1), 7)
        return (ID, year, week, day)
end

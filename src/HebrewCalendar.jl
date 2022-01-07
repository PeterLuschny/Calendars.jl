# This is part of Calendars.jl. See the copyright note there.
# ========================= Hebrew dates ====================

# Day number of the start of Hebrew calendar.
const HebrewEpoch = -1373429 

# True if Heshvan is long in Hebrew year.
function isLongHeshvan(year)
    rem(DaysInHebrewYear(year), 10) == 5
end

# True if Kislev is short in Hebrew year.
function isShortKislev(year)
    rem(DaysInHebrewYear(year), 10) == 3
end

# True if year is an Hebrew leap year
function isHebrewLeapYear(year)
    (((7 * year) + 1) % 19) < 7
end

function isLongMonth(year, month)
    (   month == 2
    ||  month == 4
    ||  month == 6
    || (month == 8 && ! isLongHeshvan(year))
    || (month == 9 && isShortKislev(year))
    ||  month == 10
    || (month == 12 && ! isHebrewLeapYear(year))
    ||  month == 13 )
end

# Last day of month in Hebrew year.
function LastDayOfHebrewMonth(year, month)
    isLongMonth(year, month) ? 29 : 30
end

# Last month of Hebrew year.
function LastMonthOfHebrewYear(year)
    isHebrewLeapYear(year) ? 13 : 12
end

# Number of days in Hebrew year.
function DaysInHebrewYear(year::Int)
    HebrewCalendarElapsedDays(year + 1) -
        HebrewCalendarElapsedDays(year)
end

# Number of days elapsed from the Sunday prior to the start of the
# Hebrew calendar to the mean conjunction of Tishri of Hebrew year.
function HebrewCalendarElapsedDays(year)
    
    MonthsElapsed = ( 235 * div(year - 1, 19)  # Months in complete cycles so far.
                     + 12 * rem(year - 1, 19)  # Regular months in this cycle.
                     + div(7 * rem(year - 1, 19) + 1, 19)) # Leap months this cycle

    PartsElapsed = 204 + 793 * rem(MonthsElapsed, 1080)
    HoursElapsed = (5 + 12 * MonthsElapsed 
                   + 793 * div(MonthsElapsed, 1080) + div(PartsElapsed, 1080))
    ConjunctionDay = 1 + 29 * MonthsElapsed + div(HoursElapsed, 24)
    ConjunctionParts = 1080 * rem(HoursElapsed, 24) + rem(PartsElapsed, 1080)
    DayOfWeek = rem(ConjunctionDay, 7) 

    if (
        ConjunctionParts >= 19440           # If new moon is at or after midday,
        || (DayOfWeek == 2                  # ...or is on a Tuesday...
            && ConjunctionParts >= 9924     # at 9 hours, 204 parts or later...
            && ! isHebrewLeapYear(year))    # ...of a common year,
        || (DayOfWeek == 1                  # ...or is on a Monday at...
            && ConjunctionParts >= 16789    # 15 hours, 589 parts or later...
            && isHebrewLeapYear(year - 1))  # at the end of a leap year
    )  
        # Then postpone Rosh HaShanah one day
        ConjunctionDay += 1
        DayOfWeek = rem(ConjunctionDay, 7)
    end

    if (
        DayOfWeek == 0     # If Rosh HaShanah would occur on Sunday,
        || DayOfWeek == 3  # or Wednesday,
        || DayOfWeek == 5  # or Friday
    ) 
      # Then postpone it one (more) day
      ConjunctionDay += 1
    end

    return ConjunctionDay
end

# Computes the day number from the Hebrew date = (year, month, day).
function DNumberHebrew(year, month, day) 

    DayInYear = HebrewEpoch + HebrewCalendarElapsedDays(year) + day 
    if month < 7   # Before Tishri, so add days in prior months

        MonthInYear = LastMonthOfHebrewYear(year)

        # this year before and after Nisan.
        for m in 7:MonthInYear
            DayInYear += LastDayOfHebrewMonth(year, m)
        end

        for m in 1:month - 1
            DayInYear += LastDayOfHebrewMonth(year, m)
        end

    else # Add days in prior months this year
        for m in 7:month - 1
            DayInYear += LastDayOfHebrewMonth(year, m)
        end 
    end

    return DayInYear 
end

# Computes the day number of the Hebrew date = (year, month, day).
DNumberHebrew(date) = DNumberHebrew(date[1], date[2], date[3])

# Computes the Hebrew date from an ADNumber.
function HebrewDate(dn)
    if dn <= 0  # Date is pre-Gregorian
       return (0, 0, 0)
    end

    year = div(dn + HebrewEpoch, 366) # Approximation from below.
    # Search forward for year from the approximation.
    while dn >= DNumberHebrew(year + 1, 7, 1)
        year += 1
    end

    # Search forward for month from either Tishri (7) or Nisan (1).
    month = dn < DNumberHebrew(year, 1, 1) ? 7 : 1

    while dn > DNumberHebrew(year, month, (LastDayOfHebrewMonth(year, month)))
        month += 1
    end

    # Calculate the day by subtraction.
    day = dn - DNumberHebrew(year, month, 1) + 1

    return (year, month, day)
end

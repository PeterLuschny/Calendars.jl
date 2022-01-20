# This is part of Calendars.jl. See the copyright note there.
# ========================= Hebrew dates ====================

# Day number of the start of Hebrew calendar.
# The Jewish calendar's epoch (reference date), 1 Tishrei AM 1, 
# is equivalent to Monday, 7 October 3761 BCE in the 
# proleptic Julian calendar (from Wikipedia).
const EpochHebrew = -1373429 

# True if Heshvan is long in Hebrew year.
function isLongHeshvan(year::DPart)
    rem(DaysInYearHebrew(year), 10) == 5
end

# True if Kislev is short in Hebrew year.
function isShortKislev(year::DPart)
    rem(DaysInYearHebrew(year), 10) == 3
end

# True if year is an Hebrew leap year
function isLeapYearHebrew(year::DPart)
    rem(7 * year + 1, 19) < 7
end

function isLongMonth(year::DPart, month::DPart)
    (   month == 2
    ||  month == 4
    ||  month == 6
    || (month == 8 && ! isLongHeshvan(year))
    || (month == 9 && isShortKislev(year))
    ||  month == 10
    || (month == 12 && ! isLeapYearHebrew(year))
    ||  month == 13 )
end

# Last day of month in Hebrew year.
function LastDayOfMonthHebrew(year::DPart, month::DPart)
    isLongMonth(year, month) ? 29 : 30
end

# Last month of Hebrew year.
function LastMonthOfYearHebrew(year::DPart)
    isLeapYearHebrew(year) ? 13 : 12
end

# Number of days in Hebrew year.
function DaysInYearHebrew(year::DPart)
    RoshHaShanah(year + 1) - RoshHaShanah(year)
end

# Is the date a valid Hebrew date?
function isValidDateHebrew(cd::CDate)
    cal, year, month, day = cd
    if CName(cal) != AM 
        @warn(Warning(cd))
        return false
    end
    lmy = LastMonthOfYearHebrew(year)
    ldm = LastDayOfMonthHebrew(year, month)
    val = (year >= 1) && (month in 1:lmy) && (day in 1:ldm) 
    !val && @warn(Warning(cd))
    return val
end

# Number of days elapsed from the Sunday prior to the start of the
# Hebrew calendar to the mean conjunction of Tishri of Hebrew year.
function RoshHaShanah(year::DPart)
    
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
            && ! isLeapYearHebrew(year))    # ...of a common year,
        || (DayOfWeek == 1                  # ...or is on a Monday at...
            && ConjunctionParts >= 16789    # 15 hours, 589 parts or later...
            && isLeapYearHebrew(year - 1))  # at the end of a leap year
    )  
        # Then postpone Rosh HaShanah one day
        ConjunctionDay += 1
        DayOfWeek = rem(ConjunctionDay, 7)
    end

    if ( DayOfWeek == 0  # If Rosh HaShanah would occur on Sunday,
      || DayOfWeek == 3  # or Wednesday,
      || DayOfWeek == 5  # or Friday
    ) 
      # Then postpone it one (more) day
      ConjunctionDay += 1
    end

    return ConjunctionDay
end

# Return the days this year so far.
function DayOfYearHebrew(year::DPart, month::DPart, day::DPart) 
    DaysInYear = day 
    if month < 7   # Before Tishri, so add days in prior months

        MonthInYear = LastMonthOfYearHebrew(year)

        # this year before and after Nisan.
        for m in 7:MonthInYear
            DaysInYear += LastDayOfMonthHebrew(year, m)
        end

        for m in 1:month - 1
            DaysInYear += LastDayOfMonthHebrew(year, m)
        end

    else # Add days in prior months this year
        for m in 7:month - 1
            DaysInYear += LastDayOfMonthHebrew(year, m)
        end 
    end
    return DaysInYear
end

# Computes the day number from a valid Hebrew date.
function DayNumberValidHebrew(year::DPart, month::DPart, day::DPart) 
    DayInYear = DayOfYearHebrew(year, month, day)
    return DayInYear + EpochHebrew + RoshHaShanah(year)
end

# Computes the day number of a valid Hebrew date.
DayNumberValidHebrew(d::CDate) = DayNumberValidHebrew(d[2], d[3], d[4])

# Computes the day number from a date which might not be a valid Hebrew date.
function DayNumberHebrew(year::DPart, month::DPart, day::DPart) 
    if isValidDateHebrew((AM, year, month, day)) 
        return DayNumberValidHebrew(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the day number from a date which might not be a valid Hebrew date.
function DayNumberHebrew(cd::CDate)
    cal, year, month, day = cd
    if isValidDateHebrew((AM, year, month, day))
        return DayNumberValidHebrew(year, month, day)
    end
    return InvalidDayNumber
end

# Computes the Hebrew date from an DayNumber.
function DateHebrew(dn::DPart)
    if dn < EpochHebrew  # Date is pre-Hebrew
       @warn(Warning(AM))
       return InvalidDate
    end

    year = div(dn + EpochHebrew, 366) # Approximation from below.
    # Search forward for year from the approximation.
    while dn >= DayNumberValidHebrew(year + 1, 7, 1)
        year += 1
    end

    # Search forward for month from either Tishri (7) or Nisan (1).
    month = dn < DayNumberValidHebrew(year, 1, 1) ? 7 : 1

    while dn > DayNumberValidHebrew(year, month, (LastDayOfMonthHebrew(year, month)))
        month += 1
    end

    # Calculate the day by subtraction.
    day = dn - DayNumberValidHebrew(year, month, 1) + 1

    return (AM, year, month, day)::CDate
end

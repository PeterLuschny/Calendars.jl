# This is part of Calendars.jl. See the copyright note there.
# ========================= Hebrew dates ====================

TEST = false
if TEST
    include("CalendarUtils.jl")
end

# Day number of the start of Hebrew calendar.
# The Jewish calendar's epoch, 1 Tishri AM 1, 
# is equivalent to Monday, 7 October 3761 BCE, 
# in the proleptic Julian calendar.
# AM-0001-01-01  = JD--3761-10-07 ~ DN#-1373427 = EpochHebrew
# AM-3761-10-16  = JD-0001-01-01  ~ DN#-1
# AM-4872-09-09  = JD-1111-11-11  ~ DN#0405740
# AM-13760-11-13 = JD-9999-12-31  ~ DN#33652132
const EpochHebrew = -1373427 
const ValidYearsHebrew = (3761, 13759) # by convention

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
    (  month == 2   || month == 4 || month == 6
    || month == 10  || month == 13
    || (month == 8  && ! isLongHeshvan(year))
    || (month == 9  && isShortKislev(year))
    || (month == 12 && ! isLeapYearHebrew(year))
    )
end

# Last day of month in Hebrew year.
function LastDayOfMonthHebrew(year::DPart, month::DPart)
    isLongMonth(year, month) ? 29 : 30
end

# Last month of Hebrew year.
function LastMonthOfYearHebrew(year::DPart)
    isLeapYearHebrew(year) ? 13 : 12
end 

# Return the number of days in the given Hebrew year.
function DaysInYearHebrew(year::DPart)
    DelayHebrew(year + 1) - DelayHebrew(year)
end

# Is the date a valid Hebrew date?
function isValidDateHebrew(cd::CDate, warn=true)
    cal, year, month, day = cd
    val = ( cal == AM 
        && (ValidYearsHebrew[1] <= year && year <= ValidYearsHebrew[2]) 
        && (1 <= month && month <= LastMonthOfYearHebrew(year)) 
        && (1 <= day && day <= LastDayOfMonthHebrew(year, month))) 
    ! val && warn && @warn(Warning(cd))
    return val
end

# Represents the day number a valid Hebrew date?
function isValidDateHebrew(dn::DPart, warn=true)
    val = EpochHebrew <= dn
    ! val && warn && @warn(Warning(dn))
    return val
end

# Number of days elapsed from the Sunday prior to the start of the
# Hebrew calendar to the mean DelayHebrew of Tishri of Hebrew year.
function DelayHebrew(year::DPart)
    
    MonthsElapsed = ( 235 * div(year - 1, 19)  # Months in complete cycles so far.
                     + 12 * rem(year - 1, 19)  # Regular months in this cycle.
                     + div(7 * rem(year - 1, 19) + 1, 19)) # Leap months this cycle

    PartsElapsed = 204 + 793 * rem(MonthsElapsed, 1080)
    HoursElapsed = (5 + 12 * MonthsElapsed 
                 + 793 * div(MonthsElapsed, 1080) + div(PartsElapsed, 1080))
    DelayHebrewDay = 1 + 29 * MonthsElapsed + div(HoursElapsed, 24)
    DelayHebrewParts = 1080 * rem(HoursElapsed, 24) + rem(PartsElapsed, 1080)
    DayOfWeek = rem(DelayHebrewDay, 7) 

    if (
        DelayHebrewParts >= 19440           # If new moon is at or after midday,
        || (DayOfWeek == 2                  # ...or is on a Tuesday...
            && DelayHebrewParts >= 9924     # at 9 hours, 204 parts or later...
            && ! isLeapYearHebrew(year))    # ...of a common year,
        || (DayOfWeek == 1                  # ...or is on a Monday at...
            && DelayHebrewParts >= 16789    # 15 hours, 589 parts or later...
            && isLeapYearHebrew(year - 1))  # at the end of a leap year
    )  
        # Then postpone Rosh HaShanah one day
        DelayHebrewDay += 1
        DayOfWeek = rem(DelayHebrewDay, 7)
    end

    if ( DayOfWeek == 0  # If Rosh HaShanah would occur on Sunday,
      || DayOfWeek == 3  # or Wednesday,
      || DayOfWeek == 5  # or Friday
    ) 
      # Then postpone it one (more) day
      DelayHebrewDay += 1
    end

    return DelayHebrewDay
end

# Return the days this year so far.
function DayOfYearHebrew(year::DPart, month::DPart, day::DPart) 
    DaysInYear = day 

    if month < 7   # Before Tishri, so add days in prior months
        # this year before and after Nisan.
        for m in 7:LastMonthOfYearHebrew(year)
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
    return DaysInYear - 1
end

# Computes the day number from a valid Hebrew date.
function DayNumberHebrew(year::DPart, month::DPart, day::DPart) 
    ( EpochHebrew - 1
    + DayOfYearHebrew(year, month, day)
    + DelayHebrew(year) 
    )
end

# Computes the day number of a Hebrew date.
DayNumberHebrew(d::CDate) = DayNumberHebrew(d[2], d[3], d[4])

# Computes the Hebrew date from an DayNumber.
function DateHebrew(dn::DPart)
    ! isValidDateHebrew(dn) && return InvalidDate
    
    year = div(dn + EpochHebrew, 366) # Approximation from below.
    # Search forward for year from the approximation.
    while dn >= DayNumberHebrew(year + 1, 7, 1)
        year += 1
    end

    # Search forward for month from either Tishri (7) or Nisan (1).
    month = dn < DayNumberHebrew(year, 1, 1) ? 7 : 1

    while dn > DayNumberHebrew(year, month, (LastDayOfMonthHebrew(year, month)))
        month += 1
    end

    # Calculate the day by subtraction.
    day = dn - DayNumberHebrew(year, month, 1) + 1

    return (AM, year, month, day)::CDate
end

# Return the day number of the first day in the given Hebrew year.
function YearStartHebrew(year::DPart) 
    return DayNumberHebrew(year, 7, 1)
end

# Return the day number of the last day in the given Hebrew year.
function YearEndHebrew(year::DPart) 
    return YearStartHebrew(year + 1) - 1
end

# Return the number of months in the given Hebrew year.
function MonthsInYearHebrew(year::DPart) 
    return LastMonthOfYearHebrew(year) 
end


if TEST

    for n in 0:3
        local dn = -1 + n  # EpochJulian = -1
        println(CDateStr(DN, dn), " -> ", CDateStr(DateHebrew(dn)))
    end
    for n in 0:3
        local date = (AM, 3761, 10, 16 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberHebrew(date)))
    end

    for n in 0:3
        local dn = 3652128 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateHebrew(dn)))
    end
    for n in 0:3
        local date = (AM, 13760, 11, 9 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberHebrew(date)))
    end

    for n in 0:2
        local dn = 405739 + n
        println(CDateStr(DN, dn), " -> ", CDateStr(DateHebrew(dn)))
    end
    for n in 0:2
        local date = (AM, 4872, 9, 8 + n)
        println(CDateStr(date), " -> ", CDateStr(DN, DayNumberHebrew(date)))
    end

#=
DN#00000-1 -> AM-3761-10-16
DN#0000000 -> AM-3761-10-17
DN#0000001 -> AM-3761-10-18
DN#0000002 -> AM-3761-10-19
AM-3761-10-16 -> DN#00000-1
AM-3761-10-17 -> DN#0000000
AM-3761-10-18 -> DN#0000001
AM-3761-10-19 -> DN#0000002
DN#3652128 -> AM-13760-11-09
DN#3652129 -> AM-13760-11-10
DN#3652130 -> AM-13760-11-11
DN#3652131 -> AM-13760-11-12
AM-13760-11-09 -> DN#3652128
AM-13760-11-10 -> DN#3652129
AM-13760-11-11 -> DN#3652130
AM-13760-11-12 -> DN#3652131
DN#0405739 -> AM-4872-09-08
DN#0405740 -> AM-4872-09-09
DN#0405741 -> AM-4872-09-10
AM-4872-09-08 -> DN#0405739
AM-4872-09-09 -> DN#0405740
AM-4872-09-10 -> DN#0405741
=#

end  # TEST
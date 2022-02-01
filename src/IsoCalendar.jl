# This is part of Calendars.jl. See the copyright note there.
# ========================= ISO dates =======================

TEST = false
if TEST
    include("CalendarUtils.jl")
end

# Day number of the start of the ISO calendar.
# ID-0001-01-01 = CE-0001-01-01 ~ DN#1 = EpochIso.
# ID-1111-45-04 = CE-1111-11-11 ~ DN#0405733
# ID-9999-52-05 = CE-9999-12-31 ~ DN#3652059
const EpochIso = 1
const ValidYearsIso = (0, 9999) # by arbitrary convention

# Day of week in ISO is represented by an integer from 1 through 7, 
# beginning with Monday and ending with Sunday, which is
# different from our enumeration, so we have to adjust.
function DayOfWeekIso(dn::DPart) 
    day = rem(dn, weeklen)   
    return day == 0 ? 7 : day
end

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
    val = ( CName(cal) == ID 
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

# Return the day number of the ISO-new-year 'year'.
function NewYearIso(year::DPart)
    return DayNumberIso(year, 1, 1) 
end

# Computes the ISO date from a day number.
function DateIso(dn::DPart)
    ! isValidDateIso(dn) && return InvalidDate

    # Patch in the two allowed exceptions.
    dn == -1 && return (ID, 0, 52, 6)
    dn ==  0 && return (ID, 0, 52, 7)

    # year = DateGregorian(dn - 3)[2]
    # Let's make it self-contained!
    year = div(400 * (dn - 4), 146097) + 1

    if dn >= NewYearIso(year + 1)
        year += 1 
    end
    week = 1 + div(dn - NewYearIso(year), weeklen)
    day = DayOfWeekIso(dn)
    return (ID, year, week, day)::CDate
end


if TEST

    dn1 = -1; println(CDateStr(dn1), " -> ", CDateStr(DateIso(dn1)))
    dn0 =  0; println(CDateStr(dn0), " -> ", CDateStr(DateIso(dn0)))

    for n in 0:3
        local dn = 1 + n
        println(CDateStr(dn), " -> ", CDateStr(DateIso(dn)))
    end
    for n in 0:3
        local date = (ID, 1, 1, 1 + n)
        println(CDateStr(date), " -> ", CDateStr(DayNumberIso(date)))
    end

    for n in 0:3
        local dn = 3652056 + n
        println(CDateStr(dn), " -> ", CDateStr(DateIso(dn)))
    end
    for n in 0:3
        local date = (ID, 9999, 52, 2 + n)
        println(CDateStr(date), " -> ", CDateStr(DayNumberIso(date)))
    end

    for n in 0:2
        local dn = 405732 + n
        println(CDateStr(dn), " -> ", CDateStr(DateIso(dn)))
    end
    for n in 0:2
        local date = (ID, 1111, 45, 5 + n)
        println(CDateStr(date), " -> ", CDateStr(DayNumberIso(date)))
    end

#=
DN#00000-1 -> ID-0000-52-06
DN#0000000 -> ID-0000-52-07
DN#0000001 -> ID-0001-01-01
DN#0000002 -> ID-0001-01-02
DN#0000003 -> ID-0001-01-03
DN#0000004 -> ID-0001-01-04
ID-0001-01-01 -> DN#0000001
ID-0001-01-02 -> DN#0000002
ID-0001-01-03 -> DN#0000003
ID-0001-01-04 -> DN#0000004
DN#3652056 -> ID-9999-52-02
DN#3652057 -> ID-9999-52-03
DN#3652058 -> ID-9999-52-04
DN#3652059 -> ID-9999-52-05
ID-9999-52-02 -> DN#3652056
ID-9999-52-03 -> DN#3652057
ID-9999-52-04 -> DN#3652058
ID-9999-52-05 -> DN#3652059
DN#0405732 -> ID-1111-45-05
DN#0405733 -> ID-1111-45-06
DN#0405734 -> ID-1111-45-07
ID-1111-45-05 -> DN#0405732
ID-1111-45-06 -> DN#0405733
ID-1111-45-07 -> DN#0405734
=#

end  # TEST

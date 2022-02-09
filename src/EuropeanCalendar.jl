# This is part of Calendars.jl. See the copyright note there.
# ===================== European calendar ===================

# The Gregorian calendar is used for dates on and after 
# CE 1582-10-15, otherwise the Julian calendar is used. 

# Is the date a valid European date?
function isValidDateEuropean(cd::CDate, warn=true)
    cal, year, month, day = cd
    if CName(cal) != EC 
        warn && @warn(Warning(cd))
        return false
    end

    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return isValidDateJulian((JD, year, month, day), warn)
    end
    return isValidDateGregorian((CE, year, month, day), warn)
end

# Computes the day number from a date.
# All dates prior to CE 1582-10-15 are interpreted as Julian dates.
function DayNumberEuropean(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayNumberJulian(year, month, day)
    end
    return dn
end

# Computes the day number from a valid date.
function DayNumberEuropean(cd::CDate)
    cal, year, month, day = cd
    return DayNumberEuropean(year, month, day) 
end

# Computes the historic date from a day number.
# All dates prior to CE 1582-10-15 are returned as Julian dates.
function DateEuropean(dn::DPart)
    d = dn < GregorysBreak ? DateJulian(dn) : DateGregorian(dn)
    cal, year, month, day = d
    return (EC, year, month, day)
end

# Return the days this year so far.
function DayOfYearEuropean(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayOfYearJulian(year, month, day)
    end
    return DayOfYearGregorian(year, month, day)
end

# Return the day number of the first day in the given European year.
function YearStartEuropean(year::DPart)
    if year <= 1582 
        return YearStartJulian(year)  
    end
    return YearStartGregorian(year)  
end

# Return the day number of the last day in the given European year.
function YearEndEuropean(year::DPart) 
    if year < 1582 
        return YearEndJulian(year)  
    end
    return YearEndGregorian(year)  
end

function MonthsInYearEuropean(year::DPart) 
    return 12
end

function DaysInYearEuropean(year::DPart) 
    if year < 1582 
        return DaysInYearJulian(year)  
    end
    return DaysInYearGregorian(year)  
end
# This is part of Calendars.jl. See the copyright note there.
# ===================== Historic calendar ===================

# The Gregorian calendar is used for dates on and after 
# CE 1582-10-15, otherwise the Julian calendar is used. 

# Computes the day number from a date.
# All dates prior to CE 1582-10-15 are interpreted as Julian dates.
function DayNumberHistorical(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayNumberJulian(year, month, day)
    end
    return dn
end

# Computes the day number from a date.
function DayNumberHistorical(cd::CDate)
    cal, year, month, day = cd
    return DayNumberHistorical(year, month, day) 
end

# Computes the historic date from a day number.
# All dates prior to CE 1582-10-15 are returned as Julian dates.
function DateHistorical(dn::DPart)
    if dn < GregorysBreak
        return DateJulian(dn)
    else
        return DateGregorian(dn)
    end
end

# Return the days this year so far.
function DayOfYearHistorical(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < GregorysBreak
        return DayOfYearJulian(year, month, day)
    end
    return DayOfYearGregorian(year, month, day)
end

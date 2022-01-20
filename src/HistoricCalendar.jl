# This is part of Calendars.jl. See the copyright note there.
# ===================== Historic calendar ===================

# Computes the day number from a date.
# All dates prior to CE 1582-10-15 are interpreted as Julian dates.
function DayNumberHistoric(year::DPart, month::DPart, day::DPart) 
    dn = DayNumberGregorian(year, month, day)
    if dn < 577736
        return DayNumberJulian(year, month, day)
    end
    return dn
end

# Computes the day number from a date.
function DayNumberHistoric(cd::CDate)
    year, month, day = cd
    return DayNumberHistoric(year, month, day) 
end

# Computes the historic date from a day number.
# All dates prior to CE 1582-10-15 are returned as Julian dates.
function DateHistoric(dn::DPart)
    if dn < 577736
        return DateJulian(dn)
    else
        return DateGregorian(dn)
    end
end

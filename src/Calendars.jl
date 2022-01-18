# ---------------------------------------------------------------
# Parts of the Julia code in this package is ported from the Lisp
# and C++ code in 'Calendrical Calculations' by Nachum Dershowitz
# and Edward M. Reingold, Software---Practice & Experience,
# vol. 20, no. 9 (September, 1990), pp. 899--928.
# This code is in the public domain, but any use of it should 
# publicly acknowledge the above sources, which is done herewith.
# Copyright of this port Peter Luschny, 2022. 
# Licensed under the MIT license.
# ---------------------------------------------------------------

module Calendars

export DayNumberFromDate, DateFromDayNumber, ConvertDate, CalendarDates 
export CDate, CDateStr, DateStr, DateTable, PrintDateTable, isValidDate
export Duration, idate

include("CalendarUtils.jl")
include("GregorianCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")
include("JulianCalendar.jl")
include("IsoCalendar.jl")
include("REPLCalendar.jl")

"""

```julia
DayNumberFromDate(date::Cdate, show::Bool)
```

Return the day number correspondig to the calendar date.

    * The date is a tuple (calendar, year, month, day).
    The parts of the date can be given as a tuple or 
    individually part by part. The calendar is 
    "Gregorian", "Hebrew", "Islamic", "Julian", 
    or "IsoDate". Alternatively the acronyms
    "CE", "AM", "AH", "AD" and "ID" can be used.  

    * If the optional parameter 'show' is set to 'true',
    date and number are printed. 'show' is 'false' by
    default.

```julia
julia> DayNumberFromDate("Gregorian", 1756, 1, 27) 
```

Alternatively you can write

```julia
julia> DayNumberFromDate("CE", 1756, 1, 27) 
```

    Returns the day number 641027. If 'show' is 'true'
    the line "CE 1756-01-27 -> DN 641027" is printed.

    If an error occurs 0 (representing the invalid day 
    number) is returned.
"""
function DayNumberFromDate(d::CDate, show=false)
    calendar = CName(d[1])
    if calendar == CE 
        dn = DNumberGregorian(d)
    elseif calendar == AD
        dn = DNumberJulian(d)
    elseif calendar == AM
        dn = DNumberHebrew(d)
    elseif calendar == AH
        dn = DNumberIslamic(d)
    elseif calendar == ID
        dn = DNumberIso(d)
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayNumber
    end

    if show
        println(CDateStr(d), " -> ", CDateStr(dn))
    end
    return dn 
end

DayNumberFromDate(calendar::String, year::Int64, month::Int64, day::Int64, show=false) =
DayNumberFromDate((calendar, year, month, day),  show) 


"""

```julia
DateFromDayNumber(dn::Int64, calendar::String, show::Bool)
```

Return the calendar date from a day number.

    * The day number is an integer >= 1.

    * The calendar is "Gregorian", "Hebrew", "Islamic",
    "Julian", or "IsoDate". Alternatively use the 
    acronyms "CE", "AM", "AH", "AD" and "ID".

    * If the optional parameter 'show' is set to 'true',
    date and number are printed. 'show' is 'false' by 
    default.

```julia
julia> DateFromDayNumber(641027, "Gregorian") 
```

Alternatively you can write

```julia
julia> DateFromDayNumber(641027, "CE") 
```

    Returns the date (CE, 1756, 1, 27). If 'show' is 
    'true' the line "DN 0641027 -> CE 1756-01-27" is 
    printed.

    If an error occurs "00 0000 00 00" (representing 
    the invalid date) is returned.
"""
function DateFromDayNumber(dn::Int64, calendar::String, show=false)
    # Use a symbol for the calendar name.
    cal = CName(calendar)
    if cal == CE
        date = DateGregorian(dn)
    elseif cal == AD
        date = DateJulian(dn)
    elseif cal == AM
        date = DateHebrew(dn)
    elseif cal == AH
        date = DateIslamic(dn) 
    elseif cal == ID
        date = DateIso(dn) 
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDate
    end

    if show 
        println(CDateStr(DN, dn), " -> ", CDateStr(date))
    end
    return date 
end

"""

```julia
ConvertDate(date::CDate, to::String, show::Bool)
```

Convert the given date to a date in the calendar 'to'.

    * The date is a tuple (calendar, year, month, day).
    The parts of the date can be given as a tuple or 
    individually part by part. The calendar is 
    "Gregorian", "Hebrew", "Islamic", "Julian", 
    or "IsoDate". Alternatively the acronyms
    "CE", "AM", "AH", "AD" and "ID" can be used. 
    
    * 'to' is the name of a calendar, "Gregorian", "Hebrew",
    "Islamic", "Julian", or "IsoDate". Alternatively use
    the acronyms "CE", "AM", "AH", "AD" or "ID".
    
    * If the optional parameter 'show' is set to 'true', 
    both dates are printed. 'show' is 'false' by default.

```julia
julia> ConvertDate(("Gregorian", 1756, 1, 27), "Hebrew") 
```

Alternatively you can write

```julia
julia> ConvertDate("CE", 1756, 1, 27, "AM") 
```

    Converts the Gregorian date ("CE", 1756, 1, 27) to the 
    Hebrew date ("AM", 5516, 11, 25). If 'show' is 'true' the 
    line "CE 1756-01-27 -> AM 5516-11-25" is printed.
"""
function ConvertDate(date::CDate, to::String, show=false)
    inc = CName(date[1]) 
    toc = CName(to)
    (inc == XX || toc == XX) && return InvalidDate
    d = (inc, date[2], date[3], date[4])
    ! isValidDate(d) && return InvalidDate
    dn = DayNumberFromDate(d)
    rdate = DateFromDayNumber(dn, toc)  
    show && println(CDateStr(date), " -> ", CDateStr(rdate))

    return rdate 
end

ConvertDate(calendar::String, year::Int, month::Int, day::Int, to::String, show=false) = 
ConvertDate((CName(calendar), year, month, day), to, show) 


"""

```julia
CalendarDates(date::CDate, show::Bool)
```

Return a table of the dates of all supported calendars. 

    * The date is an integer triple (year, month, day). 
    The parts of the date can be given as a triple or 
    individually one after the other.
    
    * The 'calendar' is "Gregorian", "Hebrew", "Islamic", 
    "Julian", or "IsoDate". Alternatively use the acronyms 
    "CE", "AM", "AH", "AD" or "ID". 'calendar' is "CE" by 
    default.

    * If the optional parameter 'show' is set to 'true', 
    the date table is printed. 'show' is 'false' by 
    default.

```julia
julia> CalendarDates(("Gregorian", 1756, 1, 27),  true) 
```

Alternatively you can write

```julia
julia> CalendarDates("CE", 1756, 1, 27, true) 
```

    Computes a 'DateTable', which is the day number plus 
    a tuple of five dates. If 'show' is 'true' the table 
    below will be printed.
```julia
    CurrentEpoch  CE 1756-01-27
    Julian        AD 1756-01-16
    Hebrew        AM 5516-11-25
    Islamic       AH 1169-04-24
    IsoDate       ID 1756-05-02
    DayNumber     DN 641027
```
"""
function CalendarDates(date::CDate, show=false)

    dn = DayNumberFromDate(date)
    Table = (
        DateFromDayNumber(dn, CE),
        DateFromDayNumber(dn, AD),
        DateFromDayNumber(dn, AM),
        DateFromDayNumber(dn, AH),
        DateFromDayNumber(dn, ID),
        (DN, 0, 0, dn)
    )
    show && PrintDateTable(Table)
    return Table
end

CalendarDates(calendar::String, year::Int, month::Int, day::Int,
show=false) = CalendarDates((calendar, year, month, day), show) 


"""

```julia
isValidDate(date::CDate)::Bool
```

Query if the given date is a valid date in the given
calendar.

    * The date is an integer triple (year, month, day).
    The parts of the date can be given as a triple or
    individually one after the other.
    
    * The 'calendar' is "Gregorian", "Hebrew", "Islamic", 
    "Julian", or "IsoDate". Alternatively use the acronyms 
    "CE", "AM", "AH", "AD" or "ID".

```julia
julia> isValidDate(("Gregorian", 1756, 1, 27)) 
```

Alternatively you can write

```julia
julia> isValidDate("CE", 1756, 1, 27) 
```

    This query affirms that 1756-01-27 is a valid Gregorian
    date.
"""
function isValidDate(d::CDate)  
    calendar = CName(d[1])
    if calendar == CE
        val = isValidDateGregorian(d)
    elseif calendar == AD
        val = isValidDateJulian(d)
    elseif calendar == AM
        val = isValidDateHebrew(d)
    elseif calendar == AH
        val = isValidDateIslamic(d)
    elseif calendar == ID
        val = isValidDateIso(d)
    else
        @warn("Unknown calendar: $calendar")
        return false
    end
    return val
end

isValidDate(calendar::String, year::Int64, month::Int64, day::Int64) = 
isValidDate((calendar, year, month, day)) 

end # module

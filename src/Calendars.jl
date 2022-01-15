# ---------------------------------------------------------------

# Parts of the Julia code in this package is ported from the Lisp
# and C++ code in 'Calendrical Calculations' by Nachum Dershowitz
# and Edward M. Reingold, Software---Practice & Experience,
# vol. 20, no. 9 (September, 1990), pp. 899--928.

# This code is in the public domain, but any use of it should 
# publicly acknowledge the above sources, which is done herewith.

# Copyright of this port Peter Luschny, 2022-01-04. 
# Licensed under the MIT license.
# ---------------------------------------------------------------

# It contains the implementation of the Gregorian date, the 
# Gregorian date, the Julian date, the Hebrew date, the Islamic
# date, and the ISO date.

# We follow the C++ version of the above-cited paper, but in a 
# more functional style: we do without classes, operators, and 
# global variables.

# We follow ISO 8601 for calendar date representations: year, 
# followed by the month, then the day, YYYY-MM-DD. For example, 
# 2022-07-12 represents the 12th of July 2022. 
# This order is also used in the signature of the functions.

# A "Day number" DN is the number of days elapsed since the 
# Gregorian date Sunday, December 31, 1 BC. Since there was no 
# year 0, the year following 1 BC is 1 AD. Thus the day number 
# of the Gregorian date 0001-01-01 is 1. The day number is 
# called "absolute date" in the cited paper.

# Here the proleptic Gregorian calendar is used, which is 
# produced by extending the Gregorian rules backward to the 
# dates preceding its official introduction.

# A "date" is a name given to a day by a calendar, represented
# by a triple of integers (year, month, day). 

# A "calendar" is a map, calendar: DAY -> Y x M x D, where DAY 
# is a strictly ordered set of days and Y, M, D are some subsets
# of the integers specified by the calendar together with an 
# epoch, which is an instant in time chosen as the origin of 
# the calendar, the first day in this calendar. 

# The "day number" is a function DN : Y x M x D -> Z, where Z 
# denotes the integers. It measures the distance of a given day 
# to the epoch. To call a day number date is misleading and 
# should be avoided.

# For instance, the date of Mozart's birth is 1756-01-27. The 
# day number associated with this date is 641027 if we assume 
# that the date is a Gregorian date. The Hebrew date of Mozart's 
# birth is 5516-11-25, and the associated day number is the 
# same as the one associated with the Gregorian date.

# We use the acronyms CE for 'Current Epoch' to denote proleptic 
# Gregorian dates, AH for 'Anno Hegirae' for Islamic dates, AM for
# 'Anno Mundi' to denote Hebrew dates, and ID for 'IsoDate'. Thus 
# CE, AH, AM, and ID are acronyms for names of calendars. 

# For example with these conventions we can write Mozart's birthday 
#    CE 1756-01-27  =  AM 5516-11-25  ->  DN 641027.

# Limitations: Currently, we do not support conversions for dates 
# prior to the epoch of the respective calendar. The invalid date
# 0000-00-00 (which has the invalid day number 0) is returned to 
# either signal invalid input or a limitation of the methods.

# ---------------------------------------------------------------

module Calendars

export DNumberFromDate, DateFromDNumber, ConvertDate, CalendarDates 
export DateStr, CDate, DateTable, PrintDateTable, isValidDate, idate 

include("CalendarUtils.jl")
include("GregorianCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")
include("JulianCalendar.jl")
include("IsoCalendar.jl")
include("REPLCalendar.jl")

"""

```julia
DNumberFromDate(date::Tuple{Int, Int, Int}, calendar::String, show::Bool)
```

Return the day number correspondig to the calendar date.

    * The date is an integer triple (year, month, day).
      The parts of the date can be given as a triple or 
      individually one after the other.

    * The calendar is "Gregorian", "Hebrew", "Islamic", 
      "Julian", or "IsoDate". Alternatively use the acronyms
      "CE", "AM", "AH", "AD" and "ID".  

    * If the optional parameter 'show' is set to 'true', 
      date and number are printed. 'show' is 'false' by default.

```julia
julia> DNumberFromDate((1756, 1, 27), "Gregorian") 
```

Alternatively you can write

```julia
julia> DNumberFromDate(1756, 1, 27, "CE") 
```

    Returns the day number 641027. If 'show' is 'true' 
    the line "CE 1756-01-27 -> DN 641027" is printed.

    If an error occurs 0 (representing the invalid day number)
    is returned.
"""
function DNumberFromDate(date::Tuple{Int, Int, Int}, calendar::String, show=false)

    # Use a symbol for the calendar name.
    cname = CName(calendar)
    if cname == CE 
        dn = DNumberGregorian(date)
    elseif cname == AD
        dn = DNumberJulian(date)
    elseif cname == AM
        dn = DNumberHebrew(date)
    elseif cname == AH
        dn = DNumberIslamic(date)
    elseif cname == ID
        dn = DNumberIso(date)
    else
        @warn("Unknown calendar: $calendar")
        return 0
    end

    if show
        println(CDate(cname, date), " -> ", CDate(DN, dn))
    end
    return dn 
end

DNumberFromDate(year::Int, month::Int, day::Int, calendar::String, show=false) =
DNumberFromDate((year, month, day), calendar, show) 


"""

```julia
DateFromDNumber(dn::Int, calendar::String, show::Bool)
```

Return the calendar date from a day number.

    * The day number is an integer >= 1.

    * The calendar is "Gregorian", "Hebrew", "Islamic", 
      "Julian", or "IsoDate". Alternatively use the acronyms
      "CE", "AM", "AH", "AD" and "ID".

    * If the optional parameter 'show' is set to 'true', date
      and number are printed. 'show' is 'false' by default.

```julia
julia> DateFromDNumber(641027, "Gregorian") 
```

Alternatively you can write

```julia
julia> DateFromDNumber(641027, "CE") 
```

    Returns the date (CE, 1756, 1, 27). If 'show' is 'true' 
    the line "DN 0641027 -> CE 1756-01-27" is printed.

    If an error occurs "00 0000 00 00" (representing the
    invalid date) is returned.
"""
function DateFromDNumber(dn::Int, calendar::String, show=false)
    # Use a symbol for the calendar name.
    cname = CName(calendar)
    if cname == CE
        date = DateGregorian(dn)
    elseif cname == AD
        date = DateJulian(dn)
    elseif cname == AM
        date = DateHebrew(dn)
    elseif cname == AH
        date = DateIslamic(dn) 
    elseif cname == ID
        date = DateIso(dn) 
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDate
    end

    if show 
        println(CDate(DN, dn), " -> ", CDate(date))
    end
    return date 
end

"""

```julia
ConvertDate(date::Tuple{Int, Int, Int}, from::String, to::String, show::Bool)
```

Convert a date represented by the calendar 'from' to the 
representation of the date in the calendar 'to'.

    * The date is an integer triple (year, month, day).
      The parts of the date can be given as a triple or 
      individually one after the other.
    
    * The 'from' and 'to' is "Gregorian", "Hebrew", "Islamic",
      "Julian", or "IsoDate". Alternatively use the acronyms
      "CE", "AM", "AH", "AD" or "ID".

    * If the optional parameter 'show' is set to 'true', both
      dates are printed. 'show' is 'false' by default.

```julia
julia> ConvertDate((1756, 1, 27), "Gregorian", "Hebrew") 
```

Alternatively you can write

```julia
julia> ConvertDate(1756, 1, 27, "CE", "AM") 
```

    Computes from the Gregorian date (1756, 1, 27) the
    Hebrew date (5516, 11, 25). If 'show' is 'true' the
    line "CE 1756-01-27 -> AM 5516-11-25" is printed.
"""
function ConvertDate(date::Tuple{Int, Int, Int}, 
                     from::String, to::String, show=false)
    (CName(from) == XX || CName(to) == XX) && return InvalidDate
    
    dn = DNumberFromDate(date, from)
    rdate = DateFromDNumber(dn, to)  
    show  && println(CDate(CName(from), date), " -> ", CDate(rdate))

    return rdate 
end

ConvertDate(year::Int, month::Int, day::Int, from::String, to::String, show=false) = 
ConvertDate((year, month, day), from, to, show) 


"""

```julia
CalendarDates(date::Tuple{Int, Int, Int}, calendar::String, show::Bool)
```

Return a table of the dates of all supported calendars. 

    * The date is an integer triple (year, month, day).
      The parts of the date can be given as a triple or 
      individually one after the other.
    
    * The 'calendar' is "Gregorian", "Hebrew", "Islamic",
      "Julian", or "IsoDate". Alternatively use the acronyms 
      "CE", "AM", "AH", "AD" or "ID". 'calendar' is "CE" by
      default.

    * If the optional parameter 'show' is set to 'true', the
      date table is printed. 'show' is 'false' by default.

```julia
julia> CalendarDates((1756, 1, 27), "Gregorian", true) 
```

Alternatively you can write

```julia
julia> CalendarDates(1756, 1, 27, "CE", true) 
```

    Computes a 'DateTable', which is the day number plus 
    a tuple of five dates. If 'show' is 'true' the table 
    below will be printed.

        CurrentEpoch  CE 1756-01-27
        Julian        AD 1756-01-16
        Hebrew        AM 5516-11-25
        Islamic       AH 1169-04-24
        IsoDate       ID 1756-05-02
        DayNumber     DN 641027
"""
function CalendarDates(date::Tuple{Int, Int, Int}, calendar="CE", show=false)

    dn = DNumberFromDate(date, calendar)
    DNumber = (DN, 0, 0, dn)
    CEdate = DateFromDNumber(dn, CE)
    ADdate = DateFromDNumber(dn, AD)
    AMdate = DateFromDNumber(dn, AM)
    AHdate = DateFromDNumber(dn, AH)
    IDdate = DateFromDNumber(dn, ID)
    
    Table = (CEdate, ADdate, AMdate, AHdate, IDdate, DNumber)
    show && PrintDateTable(Table)
    return Table
end

CalendarDates(year::Int, month::Int, day::Int, calendar="CE", show=false) = 
CalendarDates((year, month, day), calendar, show) 


"""

```julia
isValidDate(year::Int, month::Int, day::Int, calendar::String)::Bool
```

Query if the given date is a valid date in the given calendar.

    * The date is an integer triple (year, month, day).
      The parts of the date can be given as a triple or 
      individually one after the other.
    
    * The 'calendar' is "Gregorian", "Hebrew", "Islamic",
      "Julian", or "IsoDate". Alternatively use the acronyms 
      "CE", "AM", "AH", "AD" or "ID".

```julia
julia> isValidDate((1756, 1, 27), "Gregorian") 
```

Alternatively you can write

```julia
julia> isValidDate(1756, 1, 27, "CE") 
```

    This query affirms that 1756-01-27 is a valid Gregorian date.
"""
function isValidDate(year::Int, month::Int, day::Int, calendar::String)  

    # Use a symbol for the calendar name.
    cname = CName(calendar)
    if cname == CE
        val = isValidDateGregorian(year, month, day)
    elseif cname == AD
        val = isValidDateJulian(year, month, day)
    elseif cname == AM
        val = isValidDateHebrew(year, month, day)
    elseif cname == AH
        val = isValidDateIslamic(year, month, day)
    elseif cname == ID
        val = isValidDateIso(year, month, day)
    else
        @warn("Unknown calendar: $calendar")
        return false
    end
    return val
end

isValidDate(date::Tuple{Int, Int, Int}, calendar::String) = 
isValidDate(date[1], date[2], date[3], calendar) 

end # module

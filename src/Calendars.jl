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

export DayNumberFromDate, DateFromDayNumber, ConvertDate
export CalendarDates, CDate, CDateStr, DateStr, DateTable
export isValidDate, Duration, DayOfYear, ConvertOrdinalDate
export PrintDateLine, PrintDateTable, PrintEuropeanMonth 
export SaveEuropeanMonth, WeekDay, WeekDays, PrintIsoWeek, IDate
export ProfileYearAsEuropean
export EC, CE, JD, AM, AH, ID, EN, JN, DN, XX

# Export only functions from CalendarUtils and from this file,
# which basically is a wrapper around a collection of calendars.
include("CalendarUtils.jl")

# Consider the following included files as 'intern', and
# do not export their functions directly. Their algorithms
# follow Dershowitz/Reingold and use RataDie-numbers 
# whereas here we use EuroDay-numbers. 
include("GregorianCalendar.jl")
include("JulianCalendar.jl")
include("EuropeanCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")
include("IsoCalendar.jl")
include("InteractiveCalendar.jl")

"""

```julia
DayNumberFromDate(date::Cdate, show::Bool)
```

Return the day number correspondig to the calendar date.
If the optional parameter `show` is set to 'true', date 
and number are printed. `show` is 'false' by default.

```julia
julia> DayNumberFromDate(("Gregorian", 1756, 1, 27)) 
```

Alternatively you can also write

```julia
julia> DayNumberFromDate(CE, 1756, 1, 27) 
```

This returns the fix day number 641027. If `show` is 'true'
the line "CE-1756-01-27 -> EN#641029" is printed.

If an error occurs 0 (representing the invalid day 
number) is returned.
"""
function DayNumberFromDate(d::CDate, show=false)
    # Don't process invalid dates
    ! isValidDate(d) && return 0
    
    calendar = CName(d[1])
    if calendar == CE 
        dn = DayNumberGregorian(d)
    elseif calendar == JD
        dn = DayNumberJulian(d)
    elseif calendar == EC
        dn = DayNumberEuropean(d)
    elseif calendar == AM
        dn = DayNumberHebrew(d)
    elseif calendar == AH
        dn = DayNumberIslamic(d)
    elseif calendar == ID
        dn = DayNumberIso(d)
    elseif calendar == DN
        dn = d[4]
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayNumber
    end
    en = FixNumToEuroNum(dn) 

    if show
        println(CDateStr(d), " -> ", CDateStr(EN, en))
    end
    return en 
end

DayNumberFromDate(calendar::String, year::DPart, month::DPart, day::DPart, 
show=false) = DayNumberFromDate((calendar, year, month, day), show)

DayNumberFromDate(calendar::String, d::Tuple{DPart, DPart, DPart}, 
show=false) = DayNumberFromDate((calendar, d[1], d[2], d[3]), show)


"""

```julia
DateFromDayNumber(calendar::String, dn::DPart, show::Bool)
```

Return the calendar date from a European day number.

The day number `dn` must be an integer >= 1. If the optional 
parameter `show` is set to 'true', date and number are printed.
`show` is 'false' by default.

```julia
julia> DateFromDayNumber("Gregorian", 641029) 
```

Alternatively you can also write

```julia
julia> DateFromDayNumber(CE, 641029) 
```

This returns the date ("CE", 1756, 1, 27). If `show` is 
'true' the line "EN#0641029 -> CE-1756-01-27" is printed.

If an error occurs ("00", 0, 0, 0) (representing the 
invalid date) is returned.
"""
function DateFromDayNumber(calendar::String, en::DPart, show=false)
    # Use a symbol for the calendar name.
    dn = EuroNumToFixNum(en)
    cal = CName(calendar)
    if cal == CE
        date = DateGregorian(dn)
    elseif cal == JD
        date = DateJulian(dn)
    elseif cal == EC
        date = DateEuropean(dn)
    elseif cal == AM
        date = DateHebrew(dn)
    elseif cal == AH
        date = DateIslamic(dn) 
    elseif cal == ID
        date = DateIso(dn) 
    elseif cal == DN
        date = (DN, 0, 0, EuroNumToFixNum(en)) 
    elseif cal == EN 
        date = (EN, 0, 0, en) 
    elseif cal == JN 
        date = (JN, 0, 0, EuroNumToJulianNum(en))
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDate
    end

    if show 
        println(CDateStr(EN, en), " -> ", CDateStr(date))
    end
    return date 
end

"""

```julia
ConvertDate(date::CDate, to::String, show::Bool)
```

Convert the given date to a date in the calendar `to`.
`to` is the name of a calendar where admissible names
are listed in the CDate docstring. If the optional 
parameter `show` is set to 'true', both dates are printed. 
`show` is 'false' by default.

```julia
julia> ConvertDate(("Gregorian", 1756, 1, 27), "Hebrew") 
```

Alternatively you can also write

```julia
julia> ConvertDate(CE, 1756, 1, 27, AM) 
```

This converts the Gregorian date ("CE", 1756, 1, 27) to the 
Hebrew date ("AM", 5516, 11, 25). If `show` is 'true' the 
following line is printed:

```julia
    "CE-1756-01-27 -> AM-5516-11-25"
```

If an error occurs ("00", 0, 0, 0) (representing the invalid 
date) is returned.
"""
function ConvertDate(date::CDate, to::String, show=false)
    cal, year, month, day = date
    inc = CName(cal) 
    toc = CName(to)
    if inc == XX || toc == XX
        @warn("Unknown calendar: $cal")
        return InvalidDate
    end 
    d = (inc, year, month, day)
    ! isValidDate(d) && return InvalidDate
    dn = DayNumberFromDate(d)
    rdate = DateFromDayNumber(toc, dn)  
    show && println(CDateStr(date), " -> ", CDateStr(rdate))

    return rdate 
end

ConvertDate(calendar::String, year::Int, month::Int, day::Int, to::String, 
show=false) = ConvertDate((calendar, year, month, day), to, show)

ConvertDate(calendar::String, d::Tuple{DPart, DPart, DPart}, to::String, 
show=false) = ConvertDate((calendar, d[1], d[2], d[3]), to, show)


"""

```julia
CalendarDates(date::CDate, show::Bool)
```

Return a table of the dates of all supported calendars 
corresponding to `date`. If the optional parameter `show` 
is set to 'true', the date table is printed. `show` is 
'false' by default.

```julia
julia> CalendarDates(("Gregorian", 1756, 1, 27),  true) 
```

Alternatively you can also write

```julia
julia> CalendarDates(CE, 1756, 1, 27, true) 
```

This computes a `DateTable`, which is a tuple of six
calendar dates plus the day number. If `show` is 'true'
the table below will be printed.
```julia
    European  EC-1756-01-27
    Common    CE-1756-01-27
    Julian    JD-1756-01-16
    Hebrew    AM-5516-11-25
    Islamic   AH-1169-04-24
    IsoDate   ID-1756-05-02
    EuroNum   EN#0641029
```
"""
function CalendarDates(date::CDate, show=false)::DateTable

    dn = DayNumberFromDate(date)
    Table = (
        DateFromDayNumber(EC, dn),
        DateFromDayNumber(CE, dn),
        DateFromDayNumber(JD, dn),
        DateFromDayNumber(AM, dn),
        DateFromDayNumber(AH, dn),
        DateFromDayNumber(ID, dn),
        DateFromDayNumber(EN, dn),
    )
    show && PrintDateTable(Table)
    return Table
end

CalendarDates(calendar::String, year::DPart, month::DPart, day::DPart, 
show=false) = CalendarDates((calendar, year, month, day), show)

CalendarDates(calendar::String, d::Tuple{DPart, DPart, DPart}, 
show=false) = CalendarDates((calendar, d[1], d[2], d[3]), show) 


"""

```julia
isValidDate(date::CDate, warn=true)::Bool
```

Query if the given `date`` is a valid calendar date.

```julia
julia> isValidDate(("Gregorian", 1756, 1, 27)) 
```

Alternatively you can also write

```julia
julia> isValidDate(CE, 1756, 1, 27) 
```

This query affirms that 1756-01-27 is a valid Gregorian date. 
But the next two queries return 'false' and 'true', respectively.

```julia
julia> isValidDate(CE, 1900, 2, 29)
julia> isValidDate(JD, 1900, 2, 29)
````
"""
function isValidDate(d::CDate, warn=true)  
    calendar = CName(d[1])
    if calendar == CE
        val = isValidDateGregorian(d, warn)
    elseif calendar == JD
        val = isValidDateJulian(d, warn)
    elseif calendar == EC
        val = isValidDateEuropean(d, warn)
    elseif calendar == AM
        val = isValidDateHebrew(d, warn)
    elseif calendar == AH
        val = isValidDateIslamic(d, warn)
    elseif calendar == ID
        val = isValidDateIso(d, warn)
    elseif calendar == DN
        val = d[4] > 0
    elseif calendar == EN
        val = d[4] > 0
    else
        @warn("Unknown calendar: $calendar")
        return false
    end
    return val
end

isValidDate(calendar::String, year::DPart, month::DPart, 
day::DPart) = isValidDate((calendar, year, month, day))

isValidDate(calendar::String, d::Tuple{DPart, DPart, DPart}) = 
isValidDate((calendar, d[1], d[2], d[3]))

"""

```julia
DayOfYear(date::CDate)
```

Return the ordinal of the day in the given calendar. Also known 
as the 'ordinal date' relative to the epoch of the calendar. 

```julia
julia> DayOfYear(EC, 1756, 1, 27) 
```

Alternatively you can write

```julia
julia> DayOfYear("European", 1756,  1, 27) 
```

From the output we see that EC-1756-01-27 is the 27-th day 
of the year 1756 in the European calendar. The same day
is in the Hebrew calendar the 144-th day of the year:

```julia
 ConvertDate(EC, 1756, 1, 27, AM) |> DayOfYear
 ```

If an error occurs 0 (representing the invalid day of the year)
is returned.
"""
function DayOfYear(date::CDate)
    if ! isValidDate(date)
        @warn(Warning(date))
        return InvalidDayOfYear
    end

    calendar, year, month, day = date
    cname = CName(calendar)
    if cname == CE
        val = DayOfYearGregorian(year, month, day)
    elseif cname == JD
        val = DayOfYearJulian(year, month, day)
    elseif cname == EC
        val = DayOfYearEuropean(year, month, day)
    elseif cname == AM
        val = DayOfYearHebrew(year, month, day)
    elseif cname == AH
        val = DayOfYearIslamic(year, month, day)
    elseif cname == ID
        val = DayOfYearIso(year, month, day)
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayOfYear
    end
    return val + 1
end

DayOfYear(calendar::String, year::DPart, month::DPart, day::DPart) = 
DayOfYear((calendar, year, month, day)) 

DayOfYear(calendar::String, d::Tuple{DPart, DPart, DPart}) = 
DayOfYear((calendar, d[1], d[2], d[3])) 


"""

```julia
Duration(a::CDate, b::CDate, show=false)
``` 

The duration gives the number of days between the two dates `a` and `b`, 
counting the first date but not the second. So it describes a right 
half-open time interval. The start and end dates can be given in 
different calendars.

If the optional parameter `show` is set to 'true', both dates are 
printed. `show` is 'false' by default.

```julia
julia> Duration((CE, 2022, 1, 1), (ID, 2022, 1, 1), true)
``` 
Perhaps to the surprise of some, these dates are two days apart.
```julia
    CE-2022-01-01 <-> ID-2022-01-01 -> Duration 2
```
"""
function Duration(a::CDate, b::CDate, show=false)
    if isValidDate(a) && isValidDate(b)
        an = DayNumberFromDate(a)
        bn = DayNumberFromDate(b)
        dur = abs(bn - an)
        
        if show
            ad = CDateStr(a)
            bd = CDateStr(b)
            show && println(ad, " <-> ", bd, " -> Duration ", dur)
        end
        return dur 
    end
    @warn("Invalid Date: $a $b")
    return InvalidDuration
end

"""
```julia
ConvertOrdinalDate(num::DPart, from::String, to::String)
```

`num` is an ordinal date, i.e. an integer counting the ellapsed days 
since the beginning of a calendrial epoch.

`from` and `to` are ordinal date names. Currently only
the ordinal date names "EuroNum" and "JulianNum", respectively
their acronyms EN, JN, are admissible.

Examples:
Convert a Julian day number to an European day number.
```julia
julia> ConvertOrdinalDate(2440422, JN, EN) 
```
The European day number of the first crewed moon landing is 719000.

Convert an European day number to an Julian day number.
```julia
julia> ConvertOrdinalDate(719000, EN, JN) 
```
The Julian day number of the first crewed moon landing is 2440422.
"""
function ConvertOrdinalDate(num::DPart, from::String, to::String)

    if from == EN && to == JN
        re = EuroNumToJulianNum(num)
    elseif from == JN && to == EN
        re = JulianNumToEuroNum(num)
    #elseif from == EN && to == DN
    #    re = EuroNumToFixNum(num)
    #elseif from == DN && to == EN
    #    re = FixNumToEuroNum(num)
    #elseif from == DN && to == JN
    #    re = FixNumToJulianNum(num)
    #elseif from == JN && to == DN
    #    re = JulianNumToFixNum(num)
    else
        @warn("Unknown ordinal date name: ", from, " ", to)
        return InvalidDayNumber
    end
    return re
end


"""
```julia
ProfileYearAsEuropean(calendar::String, year::DPart, show=false)
```
Return a 4-tuple (YearStart, YearEnd, MonthsInYear, DaysInYear) as represented in the European calendar. 

Jewish New Year (Rosh HaShanah) begins the evening before the date returned. For the ISO-calendar read 'WeeksInYear' instead of 'MonthsInYear'.

Examples:
```julia
julia> ProfileYearAsEuropean(EC, 2022, true) 
julia> ProfileYearAsEuropean(CE, 2022, true) 
julia> ProfileYearAsEuropean(JD, 2022, true) 
julia> ProfileYearAsEuropean(AM, 5783, true) 
julia> ProfileYearAsEuropean(AH, 1444, true) 
julia> ProfileYearAsEuropean(ID, 2022, true) 
```
These commands return:
```julia
EC-2022 -> [EC-2022-01-01, EC-2022-12-31], 12, 365
CE-2022 -> [EC-2022-01-01, EC-2022-12-31], 12, 365
JD-2022 -> [EC-2022-01-14, EC-2023-01-13], 12, 365
AM-5783 -> [EC-2022-09-26, EC-2023-09-15], 12, 355
AH-1444 -> [EC-2022-07-30, EC-2023-07-18], 12, 354
ID-2022 -> [EC-2022-01-03, EC-2023-01-01], 52, 364
```
"""
function ProfileYearAsEuropean(calendar::String, year::DPart, show=false)

    cname = CName(calendar)
    if cname == CE
        p = (
            DateFromDayNumber(EC, YearStartGregorian(year) + 2),
            DateFromDayNumber(EC, YearEndGregorian(year) + 2),
            MonthsInYearGregorian(year), 
            DaysInYearGregorian(year)
        ) 
    elseif cname == JD
        p = (
            DateFromDayNumber(EC, YearStartJulian(year) + 2),
            DateFromDayNumber(EC, YearEndJulian(year) + 2),
            MonthsInYearJulian(year), 
            DaysInYearJulian(year)
        ) 
    elseif cname == EC
        p = (
            DateFromDayNumber(EC, YearStartEuropean(year) + 2),
            DateFromDayNumber(EC, YearEndEuropean(year) + 2),
            MonthsInYearEuropean(year), 
            DaysInYearEuropean(year)
        ) 
    elseif cname == AM
        p = (
            DateFromDayNumber(EC, YearStartHebrew(year) + 2),
            DateFromDayNumber(EC, YearEndHebrew(year) + 2),
            MonthsInYearHebrew(year), 
            DaysInYearHebrew(year)
        ) 
    elseif cname == AH
        p = (
            DateFromDayNumber(EC, YearStartIslamic(year) + 2),
            DateFromDayNumber(EC, YearEndIslamic(year) + 2),
            MonthsInYearIslamic(year), 
            DaysInYearIslamic(year)
        ) 
    elseif cname == ID
        p = (
            DateFromDayNumber(EC, YearStartIso(year) + 2),
            DateFromDayNumber(EC, YearEndIso(year) + 2),
            WeeksInYearIso(year), 
            DaysInYearIso(year)
        ) 
    else
        @warn("Unknown calendar: $calendar")
        return (InvalidDate, InvalidDate, 0, 0)
    end
    if show
        println(cname, "-", year, " -> [", CDateStr(p[1]), 
               ", ", CDateStr(p[2]), "], ", p[3], ", ", p[4])
    end
    return p
end

end # module

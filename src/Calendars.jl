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

export EC, CE, JD, AM, AH, ID, EN, JN, DN, XX
export Calendar, Year, Month, Day, Date, CDate, YMD
export CalendarDates, CalendarName, CDateStr, DateStr, DateTable
export DayNumberFromDate, DateFromDayNumber, ConvertDate
export isValidDate, Duration, DayOfYear, ConvertOrdinalDate
export PrintDateLine, PrintDateTable, PrintEuropeanMonth 
export SaveEuropeanMonth, WeekDay, WeekDays, PrintIsoWeek, IDate
export ProfileYearAsEuropean

# Export only functions from CalendarUtils and from this file,
# which basically is a wrapper around a collection of calendars.
include("CalendarUtils.jl")

# Consider the following included files as 'intern', and
# do not export their functions directly. Their algorithms
# follow Dershowitz/Reingold and use RataDie-numbers 
# whereas here we use EuroDay-numbers. 
include("DayNumbers.jl")
include("GregorianCalendar.jl")
include("JulianCalendar.jl")
include("EuropeanCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")
include("IsoCalendar.jl")
include("InteractiveCalendar.jl")

"""

```julia
DayNumberFromDate(date::Cdate, string::Bool, show::Bool)
```

Return the day number correspondig to the calendar date.
The parts of the date can also be given separately.

If the optional parameter `string` is `true` the function returns 
the day number in string format, otherwise as an integer.
`string` is 'false' by default.

If the optional parameter `show` is 'true', date 
and number are printed. `show` is 'false' by default.

For example:
```julia
julia> DayNumberFromDate("Gregorian", 1756, 1, 27) 
```

Using the acronym CE for 'Common Epoch' which is synonymous with
'Gregorian', this can also be written as

```julia
julia> DayNumberFromDate(CE, 1756, 1, 27) 
```

This returns the European day number 641027 as an integer by default. 
If `string` is `true` the string "EN#641029" is returned. If `show` 
is `true` the line "CE-1756-01-27 -> EN#641029" is printed.

If an error occurs 0 (representing the invalid day 
number) is returned.
"""
function DayNumberFromDate(d::CDate, string=false, show=false)
    # Don't process invalid dates
    ! isValidDate(d) && return 0
    
    calendar = d[1]
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
    elseif calendar == JN
        dn = JulianNumToFixNum(d[4])
    elseif calendar == EN
        dn = EuroNumToFixNum(d[4])
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayNumber
    end

    enum = FixNumToEuroNum(dn) 

    if show
        println(CDateStr(d), " -> ", CDateStr(EN, enum))
    end

    return string ? CDateStr(EN, enum) : enum
end

DayNumberFromDate(cal::String, year::DPart, month::DPart, day::DPart, string=false,
show=false) = DayNumberFromDate((StringToSymbol(cal), year, month, day), string, show)

DayNumberFromDate(cal::String, d::YMD, string=false, show=false) = 
DayNumberFromDate((StringToSymbol(cal), d[1], d[2], d[3]), string, show)

DayNumberFromDate(cal::DPart, year::DPart, month::DPart, day::DPart, string=false,
show=false) = DayNumberFromDate((cal, year, month, day), string, show)


"""

```julia
DateFromDayNumber(calendar::DPart, enum::DPart, string::Bool, show::Bool)
```

Return the date from a European day number expressed in the calendar.

The day number `enum` must be an integer >= 1. 

If the optional parameter `string` is `true` the function returns the date 
as a string, otherwise as an integer tuple. `string` is `false` by default.

If the optional parameter `show` is set to `true`, date and number 
are printed. `show` is `false` by default.

For example:
```julia
julia> DateFromDayNumber("Gregorian", 641029) 
```

Alternatively you can also write
```julia
julia> DateFromDayNumber(CE, 641029) 
```

By default this returns the calendar representation (2, 1756, 1, 27). 
If `string` is true the string "CE-1756-01-27" is returned.
If `show` is 'true' the line "EN#0641029 -> CE-1756-01-27" 
is printed.

If an error occurs (0, 0, 0, 0) (representing the invalid date) is returned.
"""
function DateFromDayNumber(calendar::DPart, enum::DPart, string=false, show=false)
    # Use a symbol for the calendar name.
    dn = EuroNumToFixNum(enum)

    if calendar == CE
        date = DateGregorian(dn)
    elseif calendar == JD
        date = DateJulian(dn)
    elseif calendar == EC
        date = DateEuropean(dn)
    elseif calendar == AM
        date = DateHebrew(dn)
    elseif calendar == AH
        date = DateIslamic(dn) 
    elseif calendar == ID
        date = DateIso(dn) 
    elseif calendar == DN
        date = (DN, 0, 0, EuroNumToFixNum(enum)) 
    elseif calendar == EN 
        date = (EN, 0, 0, enum) 
    elseif calendar == JN 
        date = (JN, 0, 0, EuroNumToJulianNum(enum))
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDate
    end

    if show 
        println(CDateStr(EN, enum), " -> ", CDateStr(date))
    end

    return string ? CDateStr(date) : date
end

DateFromDayNumber(calendar::String, enum::DPart, string=false, show=false) =
DateFromDayNumber(StringToSymbol(calendar, true), enum, string, show)

"""

```julia
ConvertDate(date::CDate, calendar::DPart, string::Bool, show::Bool)
```

Convert the given date to a date in the calendar `calendar`.
Admissible names for the calendar are listed in the CDate docstring. 

If the optional parameter `string` is `true` the function returns the date 
as a string, otherwise as an integer tuple. `string` is `false` by default.

If the optional parameter `show` is set to 'true', both dates 
are printed. `show` is 'false' by default.

For example:
```julia
julia> ConvertDate(CE, 1756, 1, 27, AM) 
```

Alternatively this can also be written as

```julia
julia> ConvertDate("Gregorian", 1756, 1, 27, "Hebrew") 
```

This converts the Gregorian date (1756, 1, 27) to the Hebrew date (5516, 11, 25).
By default the calendar representation (4, 5516, 11, 25) is returned.

If `string` is true the string "AM-5516-11-25" is returned.
If `show` is 'true' the following line is printed:

```julia
    "CE-1756-01-27 -> AM-5516-11-25"
```

If an error occurs (0, 0, 0, 0) (representing the invalid date) is returned.
"""
function ConvertDate(date::CDate, calto::DPart, string=false, show=false)
    ! isValidDate(date) && return InvalidDate

    # TODO There should be a general validation method in Utils.
    if StringToSymbol(SymbolToString[calto]) != calto
        @warn("Unknown calendar: $calto")
        return InvalidDate
    end 
    
    enum = DayNumberFromDate(date)
    rdate = DateFromDayNumber(calto, enum)  
    show && println(CDateStr(date), " -> ", CDateStr(rdate))

    return string ? CDateStr(rdate) : rdate
end

ConvertDate(calendar::DPart, year::DPart, month::DPart, day::DPart, to::DPart, 
string=false, show=false) = ConvertDate((calendar, year, month, day), to, string, show)

ConvertDate(calendar::String, year::DPart, month::DPart, day::DPart, to::String, 
string=false, show=false) = ConvertDate((StringToSymbol(calendar), year, month, day), 
StringToSymbol(to), string, show)

ConvertDate(calendar::String, d::YMD, to::String, string=false, show=false) = 
ConvertDate((StringToSymbol(calendar), d[1], d[2], d[3]), StringToSymbol(to), string, show)

ConvertDate(date::CDate, calto::String, string=false, show=false) =
ConvertDate(date, StringToSymbol(calto), string, show)

"""

```julia
CalendarDates(date::CDate, show::Bool)
```

Return a table of the dates of all supported calendars 
corresponding to `date`. If the optional parameter `show` 
is set to 'true', the date table is printed. `show` is 
'false' by default.

```julia
julia> CalendarDates("Gregorian", 1756, 1, 27, true) 
```

Alternatively you can also write

```julia
julia> CalendarDates(CE, 1756, 1, 27, true) 
```

This computes a `DateTable`, which is a tuple of six calendar 
dates plus the Euro day number and the Julian day number.
If `show` is 'true' the table below will be printed.
```julia
    European  EC-1756-01-27
    Common    CE-1756-01-27
    Julian    JD-1756-01-16
    Hebrew    AM-5516-11-25
    Islamic   AH-1169-04-24
    IsoDate   ID-1756-05-02
    EuroNum   EN#0641029
    JulianNum JN#2362452
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
        DateFromDayNumber(JN, dn)
    )
    show && PrintDateTable(Table)
    return Table
end

CalendarDates(calendar::String, year::DPart, month::DPart, day::DPart, 
show=false) = CalendarDates((StringToSymbol(calendar), year, month, day), show)

CalendarDates(calendar::String, d::YMD, show=false) = 
CalendarDates((StringToSymbol(calendar), d[1], d[2], d[3]), show) 

CalendarDates(cal::DPart, year::DPart, month::DPart, day::DPart, 
show=false) = CalendarDates((cal, year, month, day), show) 


"""

```julia
isValidDate(date::CDate, warn=true)::Bool
```

Query if the given `date`` is a valid calendar date.

For example:
```julia
julia> isValidDate("Gregorian", 1756, 1, 27) 
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
```
"""
function isValidDate(d::CDate, warn=true)  
    calendar = d[1]

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
    elseif calendar == JN
        val = d[4] > 0    
    else
        @warn("Unknown calendar: $calendar")
        return false
    end
    return val
end

isValidDate(calendar::String, year::DPart, month::DPart, day::DPart) = 
isValidDate((StringToSymbol(calendar), year, month, day))

isValidDate(calendar::DPart, year::DPart, month::DPart, day::DPart) = 
isValidDate((calendar, year, month, day))

isValidDate(calendar::String, d::YMD) = 
isValidDate((StringToSymbol(calendar), d[1], d[2], d[3]))

"""

```julia
DayOfYear(date::CDate)
```

Return the ordinal of the day in the given calendar. Also known as the 'ordinal date' relative to the epoch of the calendar. 

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
julia> DayOfYear(ConvertDate(EC, 1756, 1, 27, AM))
 ```

If an error occurs 0 (representing the invalid day of the year) is returned.
"""
function DayOfYear(date::CDate)
    if ! isValidDate(date)
        @warn(Warning(date))
        return InvalidDayOfYear
    end

    calendar, year, month, day = date
    # cname = StringToSymbol(calendar)
    if calendar == CE
        val = DayOfYearGregorian(year, month, day)
    elseif calendar == JD
        val = DayOfYearJulian(year, month, day)
    elseif calendar == EC
        val = DayOfYearEuropean(year, month, day)
    elseif calendar == AM
        val = DayOfYearHebrew(year, month, day)
    elseif calendar == AH
        val = DayOfYearIslamic(year, month, day)
    elseif calendar == ID
        val = DayOfYearIso(year, month, day)
    else
        @warn("Unknown calendar: $calendar")
        return InvalidDayOfYear
    end
    return val + 1
end

DayOfYear(calendar::String, year::DPart, month::DPart, day::DPart) = 
DayOfYear((StringToSymbol(calendar), year, month, day)) 

DayOfYear(calendar::String, d::YMD) = 
DayOfYear((StringToSymbol(calendar), d[1], d[2], d[3])) 

DayOfYear(calendar::DPart, d::YMD) = 
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
function ConvertOrdinalDate(num::DPart, from::DPart, to::DPart)

    if from == EN && to == JN
        re = EuroNumToJulianNum(num)
    elseif from == JN && to == EN
        re = JulianNumToEuroNum(num)
    elseif from == EN && to == DN
        re = EuroNumToFixNum(num)
    elseif from == DN && to == EN
        re = FixNumToEuroNum(num)
    elseif from == DN && to == JN
        re = FixNumToJulianNum(num)
    elseif from == JN && to == DN
        re = JulianNumToFixNum(num)
    else
        @warn("Unknown ordinal date name: ", from, " ", to)
        return InvalidDayNumber
    end
    return re
end

ConvertOrdinalDate(num::DPart, from::String, to::String) =
ConvertOrdinalDate(num, StringToSymbol(from), StringToSymbol(to)) 


"""
```julia
ProfileYearAsEuropean(calendar::DPart, year::DPart, show=false)
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
function ProfileYearAsEuropean(calendar::DPart, year::DPart, show=false)

    if calendar == CE
        p = (
            DateFromDayNumber(EC, YearStartGregorian(year) + 2),
            DateFromDayNumber(EC, YearEndGregorian(year) + 2),
            MonthsInYearGregorian(year), 
            DaysInYearGregorian(year)
        ) 
    elseif calendar == JD
        p = (
            DateFromDayNumber(EC, YearStartJulian(year) + 2),
            DateFromDayNumber(EC, YearEndJulian(year) + 2),
            MonthsInYearJulian(year), 
            DaysInYearJulian(year)
        ) 
    elseif calendar == EC
        p = (
            DateFromDayNumber(EC, YearStartEuropean(year) + 2),
            DateFromDayNumber(EC, YearEndEuropean(year) + 2),
            MonthsInYearEuropean(year), 
            DaysInYearEuropean(year)
        ) 
    elseif calendar == AM
        p = (
            DateFromDayNumber(EC, YearStartHebrew(year) + 2),
            DateFromDayNumber(EC, YearEndHebrew(year) + 2),
            MonthsInYearHebrew(year), 
            DaysInYearHebrew(year)
        ) 
    elseif calendar == AH
        p = (
            DateFromDayNumber(EC, YearStartIslamic(year) + 2),
            DateFromDayNumber(EC, YearEndIslamic(year) + 2),
            MonthsInYearIslamic(year), 
            DaysInYearIslamic(year)
        ) 
    elseif calendar == ID
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
        println(SymbolToString[calendar], "-", year, " -> [", 
            CDateStr(p[1]), ", ", CDateStr(p[2]), "], ", p[3], ", ", p[4])
    end

    return p
end

ProfileYearAsEuropean(calendar::String, year::DPart, show=false) =
ProfileYearAsEuropean(StringToSymbol(calendar), year, show)

end # module

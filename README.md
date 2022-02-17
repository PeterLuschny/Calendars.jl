![Calendar Calculator](docs/src/CalendarCalculator.jpg)

.

Registered on [JuliaHub](https://juliahub.com/ui/Packages/Calendars/yDHMq), read the [Docs](https://docs.juliahub.com/Calendars/yDHMq), get the source from the [repository](https://github.com/PeterLuschny/Calendars.jl) or install with Pkg.add("Calendars").

# Calendars, Conversions of Dates, Change of Calendars  


The package _Calendars.jl_ provides a Julia implementation of six calendars and two day numbers: 

| Enum | Acronym | Calendar  |
| :-:  | :---:   |  :---     | 
| (1)  | EC      | European  |
| (2)  | CE      | Common    |
| (3)  | JD      | Julian    |
| (4)  | AM      | Hebrew    |
| (5)  | AH      | Islamic   |
| (6)  | ID      | IsoDate   |
|  ~   | ~~      | ~~~~~~~   |
| (7)  | EN      | EuroNum   |
| (8)  | JN      | JulianNum |


 The *Common Era* `CE` dates are computed according to the [proleptic Gregorian](https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar) rules, *Julian dates* `JD` according to the rules of the reformed [Roman calendar](https://en.wikipedia.org/wiki/Julian_calendar) proposed by Julius Caesar. The *European calendar* `EC` uses the Gregorian calendar for dates on and after `CE` 1582-10-15 and otherwise the Julian calendar. 

We recommend using the European calendar to avoid errors and confusion by extending the Gregorian calendar rules backward to the dates preceding its official introduction in 1582, as the common calendar `CE` does. However, if you are not working with dates older than 400 years, this distinction is irrelevant, and the use of `CE` brings no disadvantages. 

We do not use the acronym `AD` ("Anno Domini nostri Jesu Christi") but use `JD` instead, which stands for the Julian dates. [AD](https://en.wikipedia.org/wiki/Anno_Domini) is an acronym invented by a 6th-century [monk](https://en.wikipedia.org/wiki/Dionysius_Exiguus), member of the Roman Curia. Nowadays, the `AD` terminology is exclusive to non-Christian people. However, we keep the start of the epoch and allow the use of `AD` as an option. 

Dates can be converted from one to another. We follow ISO 8601 for calendar date representations: Year, followed by the month, then the day, `YYYY-MM-DD`. This order is also used in the signature of the functions. For example, 2022-07-12 represents the 12th of July 2022. We extend this notation by prefixing it with two letters, the acronyms of the names of calendars given in the table above: `CE-YYYY-MM-DD`, `JD-YYYY-MM-DD`, `AM-YYYY-MM-DD` and so on.

Roughly speaking a calendar date `CDate` is a pair (CC, YMD) where `CC` is a calendar specifier and `YMD` is 3-tuple of integers which, as a string, is written `YYYY-MM-DD`. However, internally we represent a calendar specifier also as an integer. Therefore a `CDate` is implemented as 4-tuple of integers extending the calendar date representation of ISO 8601.

The primary function provided is:

```julia
ConvertDate(date::CDate, calendar::DPart, string=false::Bool, show=false::Bool)
```

It converts a calendar date to the representation of the date in the 'calendar.'

* The calendar date `CDate` is a tuple (calendar, year, month, day). The parts of the date can be given as a tuple or individually.

* 'calendar' is one of "Common", "European", "Julian", "Hebrew", "Islamic", or "IsoDate". Alternatively, you can use the acronyms CE, EC, JD, AM, AH, or ID explained in the table above. "Gregorian" is used synonymously with "Common," and AD can be used synonymously with JD.

* If the optional parameter 'string' is set to 'true,' the date is returned as a string in the format `CC-YYYY-MM-DD`. Otherwise an integer 4-tuple is returned, where the first item is the calendar specifier as defined in the enumeration in the table at the top of this page. By default the integer representation is returned. 

* If the optional parameter 'show' is set to 'true,' both dates are printed. 'show' is 'false' by default.

For example:

```julia
julia> ConvertDate("Common", 1756, 1, 27, "Hebrew") 
```

which can also be written

```julia
julia> ConvertDate(CE, 1756, 1, 27, AM)
```

computes from the Common date (1756, 1, 27) the corresponding Hebrew date (5516, 11, 25). If 'show' is 'true' the line

    "CE-1756-01-27 -> AM-5516-11-25" 

is printed.

Another key function returns a table of the dates of all supported calendars.

```julia
CalendarDates(date::CDate, show=false::Bool)
```

The parameters follow the same conventions as those of `ConvertDate`. The date can be given as a tuple, or the components of the date can be given separately. For example:

```julia
julia> CalendarDates("Common", 1756, 1, 27, true) 
```

computes a table, which is a tuple of six dates plus the European and the Julian day number. If 'show' is 'true' the date table below will be printed.

### Why using the European calendar?

The table returned by the last command shows the birthday of Wolfgang Amadeus Mozart. The `EC`-date and the `CE`-date are the same, as was to be expected.

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

But if you look up the birthday of Leonardo da Vinci, you better use the European calendar `EC` and not the Common calendar `CE.` This time, the `EC`-date and the `JD`-date are the same, and this is correct. But the Gregorian calendar misses Leonardo's birthday by nine days! This error occurs because the Gregorian calendar extrapolates the date backward from 1582, ignoring the historical course. That is why this calendar is called 'proleptic.' (But even that is not correct: `proleptic` refers to the future; it would be better to call it `preleptic.`) 

```julia
julia> CalendarDates("European", 1452, 4, 15, true) 
 
European   EC-1452-04-15
Common     CE-1452-04-24
Julian     JD-1452-04-15
Hebrew     AM-5212-01-26
Islamic    AH-0856-03-25
IsoDate    ID-1452-17-06
EuroNum    EN#0530083
JulianNum  JN#2251506
``` 

So the message is: use the European calendar, not the Common/Gregorian one.

### Options and formats

With many functions you can choose which format the return value has: an integer tuple or a string. For example the signature of `ConvertDate` is:

```julia
ConvertDate(date, calendar, string=false, show=false)
``` 

The calls

```julia
ConvertDate("Gregorian", 1756, 1, 27, "Hebrew")
ConvertDate("Gregorian", 1756, 1, 27, "Hebrew", true)
```
return respectively

```julia
(4, 5516, 11, 25)
"AM-5516-11-25"
```
Here we see that the specifier for the Hebrew calendar, `AM`, is internally encoded as the integer 4. This integer is conventionally defined in the enumeration given in the table at the top of this page. 

One can use the functions `Calendar`, `Year`, `Month`, `Day`, and `Date` to extract the parts of a calendar date. 

### Range and tables

A broader overview give the utility functions `PrintEuropeanMonth(year, month)` and `SaveEuropeanMonth(year, month, directory)`. The latter writes the `EC-year-month` month for all calendar representations to the given directory in a markdown file. The next example is particularly instructive.

```julia
julia> PrintEuropeanMonth(1582, 10)
```  

It shows the month when Pope Gregory severely interfered with Chronos turning the Zodiac wheel: at his behest, Thursday 4 October 1582 was followed by Friday 15 October 1582. To say that the confusion this caused was minor would be the understatement of the millennium. But this break can only be seen in the European calendar; both the Julian and the Gregorian calendars smoothly cross this break as if nothing had happened. (What Gregory's contemporaries saw very differently: they felt cheated of 1/3 of their monthly rent.)


| Common        | European      | Julian        | Hebrew        | Islamic       | IsoDate       |
| :---:         |  :---:        | :---:         |  :---:        | :---:         |  :---:        |
| CE-1582-10-11 | EC-1582-10-01 | JD-1582-10-01 | AM-5343-07-15 | AH-0990-09-13 | ID-1582-41-01 |
| CE-1582-10-12 | EC-1582-10-02 | JD-1582-10-02 | AM-5343-07-16 | AH-0990-09-14 | ID-1582-41-02 |
| CE-1582-10-13 | EC-1582-10-03 | JD-1582-10-03 | AM-5343-07-17 | AH-0990-09-15 | ID-1582-41-03 |
| CE-1582-10-14 | EC-1582-10-04 | JD-1582-10-04 | AM-5343-07-18 | AH-0990-09-16 | ID-1582-41-04 |
| CE-1582-10-15 | EC-1582-10-15 | JD-1582-10-05 | AM-5343-07-19 | AH-0990-09-17 | ID-1582-41-05 |
| CE-1582-10-16 | EC-1582-10-16 | JD-1582-10-06 | AM-5343-07-20 | AH-0990-09-18 | ID-1582-41-06 |
| CE-1582-10-17 | EC-1582-10-17 | JD-1582-10-07 | AM-5343-07-21 | AH-0990-09-19 | ID-1582-41-07 |

The range of validity of the calendars is limited to the range from JD-0001-01-01 to CE-9999-12-31. This choice is by convention but has practical advantages: the four-digit year format of the ISO representation can be met (exception is the Hebrew case, which overflows this format); also, handling dates before the beginning of the Julian epoch is avoided in this way. This means that no year zero appears in our setup apart from the two dates CE-0000-12-30 and 31 (and their `ID` equivalents). We include them only for the sake of completeness at the beginning of the calendar.

The first four days of the calendar are  

| Common        | European      | Julian        | Hebrew        | Islamic       | IsoDate       |
| :---:         |  :---:        | :---:         |  :---:        | :---:         |  :---:        |
| CE-0000-12-30 | EC-0001-01-01 | JD-0001-01-01 | AM-3761-10-16 | 00-0000-00-00 | ID-0000-52-06 |
| CE-0000-12-31 | EC-0001-01-02 | JD-0001-01-02 | AM-3761-10-17 | 00-0000-00-00 | ID-0000-52-07 |
| CE-0001-01-01 | EC-0001-01-03 | JD-0001-01-03 | AM-3761-10-18 | 00-0000-00-00 | ID-0001-01-01 |
| CE-0001-01-02 | EC-0001-01-04 | JD-0001-01-04 | AM-3761-10-19 | 00-0000-00-00 | ID-0001-01-02 |

 We take advantage of the fact that there is no date (0000-00-00) and use this for uniform error handling: the tuple (0, 0, 0) represents the **invalid date** and is written as the string "00-0000-00-00". In case of invalid input or other errors, this representation is returned. The Islamic dates in the table above show this format because we do not backward extrapolate Islamic dates before JD-0622-07-16 (the start of the Islamic calendar).

The last four days of the calendar are

| Common        | European      | Julian        | Hebrew         | Islamic       | IsoDate       |
| :---:         |  :---:        | :---:         |  :---:         | :---:         |  :---:        |
| CE-9999-12-28 | EC-9999-12-28 | JD-9999-10-16 | AM-13760-08-25 | AH-9666-03-29 | ID-9999-52-02 |
| CE-9999-12-29 | EC-9999-12-29 | JD-9999-10-17 | AM-13760-08-26 | AH-9666-03-30 | ID-9999-52-03 |
| CE-9999-12-30 | EC-9999-12-30 | JD-9999-10-18 | AM-13760-08-27 | AH-9666-04-01 | ID-9999-52-04 |
| CE-9999-12-31 | EC-9999-12-31 | JD-9999-10-19 | AM-13760-08-28 | AH-9666-04-02 | ID-9999-52-05 |

In some cases it is convenient to reduce the size of this table (from which only a section was shown above). That is why we also offer a shorter week-based format. 

```julia
julia> PrintIsoWeek(1582, 41)
```  
Days of week 41 of the year 1582.

|  Weekday  |  European  |   Hebrew   |  Islamic   |
|   :---:   |    :---:   |   :---:    |   :---:    |
| Monday    | 1582-10-01 | 5343-07-15 | 0990-09-13 |
| Tuesday   | 1582-10-02 | 5343-07-16 | 0990-09-14 |
| Wednesday | 1582-10-03 | 5343-07-17 | 0990-09-15 |
| Thursday  | 1582-10-04 | 5343-07-18 | 0990-09-16 |
| Friday    | 1582-10-15 | 5343-07-19 | 0990-09-17 |
| Saturday  | 1582-10-16 | 5343-07-20 | 0990-09-18 |
| Sunday    | 1582-10-17 | 5343-07-21 | 0990-09-19 |

### Ordinal Dates

The package also implements two ordinal dates:

| Acronym |       Ordinal      |
| :---:   |  :---              | 
| EN      | European day number|
| JN      | Julian day number  |

An ordinal date is an integer counting the elapsed days since the epoch of some calendar. For example, the first day of the European calendar (EC-0001-01-01) has the European date number 1 (denoted by EN#1) and the Julian date number 1721424 (prefixed by `JN#`). 

|   European    |  EuroNum   | JulianNum  |
|     :---:     |   :---:    |   :---:    |
| EC-0001-01-01 | EN#      1 | JN#1721424 |
| EC-0001-01-02 | EN#      2 | JN#1721425 |
| EC-0001-01-03 | EN#      3 | JN#1721426 |
| ...           | ...        | ...        |
| EC-9999-12-29 | EN#3652059 | JN#5373482 |
| EC-9999-12-30 | EN#3652060 | JN#5373483 |
| EC-9999-12-31 | EN#3652061 | JN#5373484 |


According to our convention, the last day represented by the calendar is EC-9999-12-31, has the Julian date number 5373484 and the European date number 3652061. Thus the European calendar gives 3652061 days a name. Both counters differ only by an additive constant. The European date number is formally defined as 

EN(date) = JN(date) − 1721423.

The European date number is similar to the day number [Rata Die](https://en.wikipedia.org/wiki/Rata_Die) defined by `R`eingold and `D`ershowitz. In fact, `RD` differs only by two days from the European date number since `RD` is based on the proleptic Gregorian calendar and CE-0001-01-01 = EC-0001-01-03. But we think it is much more natural to start at the beginning of the Julian calendar, JD-0001-01-01 = EC-0001-01-01, and not with a 'proleptic' relation.

The `Julian day number` `JN` is the count of days since the beginning of the Julian Period in 4713 BCE. There is also a `continuous` form of the Julian day number, `JC`, containing a fraction that represents a `daytime`. This form we do not use. Our counts are pure integers, likewise our algorithms do not use real numbers. 

However, we remark that if a day indicated by a common (midnight based) date starts in the continuous form with the `JC` N.5 and ends with `JC` (N+1).4999..., then the corresponding day number `JN` is (N+1), which could be seen as (N+1).0 in terms of `JC`, indicating the noon of that day. Conceptually, of course, a counter is a different thing than a point in time.


```julia
ConvertOrdinalDate(dnum::DPart, from::String, to::String)
```
`dnum` is an ordinal day number. `from` and `to` are ordinal date names. Admissible ordinal date names are "EuroNum", "JulianNum", or their acronyms EN and JN.

For instance, to convert a Julian day number to a European day number, write
```julia
julia> ConvertOrdinalDate(2440422, JN, EN) 
```
It returns 719000, the European day number of the first crewed moon landing.

A common question is how a calendar fits into another calendar. This question is partially answered by the function `ProfileYearAsEuropean`.
```julia
ProfileYearAsEuropean(calendar::String, year::DPart, show=false)
```
This function returns a 4-tuple (YearStart, YearEnd, MonthsInYear, DaysInYear) which show how these items are represented in the European calendar. Note that the Jewish New Year (Rosh HaShanah) begins the evening before the date returned. For the ISO-calendar read 'WeeksInYear' instead of 'MonthsInYear'.

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

The package provides additional functions; read the documentation for this. You might start exploring with a Jupyter [notebook](https://github.com/PeterLuschny/Calendars.jl/blob/main/notebook/Calendars.ipynb).

### Online Calendars 

Calendars are more tricky to implement than it first appears. It is therefore essential to compare the results with reference implementations. There are many implementations online, we trust few, but we trust this one: [IMCCE](https://ssp.imcce.fr/forms/calendars). If you find any deviation from the data displayed there, please notify us immediately via the [issues page](https://github.com/PeterLuschny/Calendars.jl/issues).

### Credits

We use the algorithms by Nachum Dershowitz and Edward M. Reingold, described in 'Calendrical Calculations', Software--Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

The picture shows the 'Calendar calculator', owned by Anton Ignaz Joseph Graf von Fugger-Glött, Prince-Provost of Ellwangen, Ostalbkreis, 1765 - Landesmuseum Württemberg, Stuttgart, Germany. The picture is in the public domain. 

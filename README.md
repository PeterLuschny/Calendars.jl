![Calendar Calculator](docs/src/CalendarCalculator.jpg)

.

Registered on [JuliaHub](https://juliahub.com/ui/Packages/Calendars/yDHMq), read the [Docs](https://docs.juliahub.com/Calendars/yDHMq), get the source from the [repository](https://github.com/PeterLuschny/Calendars.jl) or install with Pkg.add("Calendars").

# Calendars, Conversions of Dates, Change of Calendars  


The package _Calendar_ provides a Julia implementation of six calendars: 

| Acronym | Calendar |
| :---:   |  :---    | 
| CE      | Common   |
| EC      | European |
| JD      | Julian   |
| AM      | Hebrew   |
| AH      | Islamic  |
| ID      | IsoDate  |

 The *Common Era* `CE` dates are computed according to the [proleptic Gregorian](https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar) rules, *Julian dates* `JD` according to the rules of the reformed [Roman calendar](https://en.wikipedia.org/wiki/Julian_calendar) proposed by Julius Caesar. The *European calendar* `EC` uses the Gregorian calendar for dates on and after `CE` 1582-10-15 and otherwise the Julian calendar. 

We recommend using the European calendar to avoid errors and confusion by extending the Gregorian calendar rules backward to the dates preceding its official introduction in 1582, as the common calendar `CE` does. However, if you are not working with dates older than 400 years, this distinction is irrelevant, and the use of `EC` brings no disadvantages. 

We do not use the acronym `AD` ("Anno Domini nostri Jesu Christi") but use `JD` instead, which stands for the Julian dates. [AD](https://en.wikipedia.org/wiki/Anno_Domini) is an acronym invented by a 6th-century [monk](https://en.wikipedia.org/wiki/Dionysius_Exiguus), member of the Roman Curia, in a successful attempt to usurp the Roman calendar for the Catholic church. Nothing would have seemed more absurd to Julius Caesar, Pontifex Maximus, the Roman state religion chief priest. He wouldn't give his name to and put his calendar reform at the service of a Jewish sect--if it existed in his day. Nowadays, the `AD` terminology is exclusive to non-Christian people. However, we keep the start of the epoch and the same numbers for `AD` years and allow the use of `AD` as a synonym. 

Dates can be converted from one to another. We follow ISO 8601 for calendar date representations: Year, followed by the month, then the day, `YYYY-MM-DD.` This order is also used in the signature of the functions. For example, 2022-07-12 represents the 12th of July 2022. We extend this notation by prefixing it with two letters, the acronyms of the names of calendars given in the table above: `CE-YYYY-MM-DD,` `JD-YYYY-MM-DD,` `AM-YYYY-MM-DD` and so on.

The primary function provided is:

    ConvertDate(date, calendar, show=false). 

It converts a calendar date to the representation of the date in the 'calendar.'

* The calendar date (CDate) is a tuple (calendar, year, month, day). The parts of the date can be given as a tuple or individually.

* 'calendar' is one of "Common", "European", "Julian", "Hebrew", "Islamic", or "IsoDate". Alternatively, you can use the acronyms "CE," "EC," "JD," "AM," "AH," or "ID" explained in the table above. "Gregorian" is used synonymously with "Common," and "AD" is used synonymously with "JD."

* If the optional parameter 'show' is set to 'true,' both dates are printed. 'show' is 'false' by default.

For example:

```julia
julia> ConvertDate(("Common", 1756, 1, 27), "Hebrew") 
```

which can also be written

```julia
julia> ConvertDate("CE", 1756, 1, 27, "AM")
```

computes from the Common date (1756, 1, 27) the Hebrew date (5516, 11, 25). If 'show' is 'true' the line

    "CE-1756-01-27 -> AM-5516-11-25" 

is printed.

A second function returns a table of the dates of all supported calendars.

    CalendarDates(date, show=false).

The parameters follow the same conventions as those of ConvertDate. For example:

```julia
julia> CalendarDates("Common", 1756, 1, 27, true) 
```

computes a table, which is a tuple of six dates plus the day number. If 'show' is 'true' the table below will be printed.

### Why using the European calendar?

The table returned by the last command shows the birthday of Wolfgang Amadeus Mozart. The `EC`-date and the `CE`-date are the same, as was to be expected.

```julia
European  EC-1756-01-27
Common    CE-1756-01-27
Julian    JD-1756-01-16
Hebrew    AM-5516-11-25
Islamic   AH-1169-04-24
IsoDate   ID-1756-05-02
EuroNum   EN#641029
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
EuroNum    EN#530083
``` 

So the message is: use the European calendar, not the Common/Gregorian one.

A broader overview give the utility functions `PrintEuropeanMonth(year, month)` and `SaveEuropeanMonth(year, month, directory)`. The latter writes the `EC-year-month` month for all calendar representations to the given directory in a markdown file. The next example is particularly instructive.

```julia
julia> PrintEuropeanMonth(1582, 10)
```  

It shows the month when Pope Gregory severely interfered with Chronos turning the Zodiac wheel: at his behest, Thursday 4 October 1582 was followed by Friday 15 October 1582. To say that the confusion this caused was minor would be the understatement of the millennium. But this break can only be seen in the European calendar; both the Julian and the Gregorian calendars smoothly cross this break as if nothing had happened. (What Gregory's contemporaries saw differently: they felt cheated of 1/3 of their monthly rent.)


| Common        | European      | Julian        | Hebrew        | Islamic       | IsoDate       |
| :---:         |  :---:        | :---:         |  :---:        | :---:         |  :---:        |
| CE-1582-10-11 | EC-1582-10-01 | JD-1582-10-01 | AM-5343-07-15 | AH-0990-09-13 | ID-1582-41-01 |
| CE-1582-10-12 | EC-1582-10-02 | JD-1582-10-02 | AM-5343-07-16 | AH-0990-09-14 | ID-1582-41-02 |
| CE-1582-10-13 | EC-1582-10-03 | JD-1582-10-03 | AM-5343-07-17 | AH-0990-09-15 | ID-1582-41-03 |
| CE-1582-10-14 | EC-1582-10-04 | JD-1582-10-04 | AM-5343-07-18 | AH-0990-09-16 | ID-1582-41-04 |
| CE-1582-10-15 | EC-1582-10-15 | JD-1582-10-05 | AM-5343-07-19 | AH-0990-09-17 | ID-1582-41-05 |
| CE-1582-10-16 | EC-1582-10-16 | JD-1582-10-06 | AM-5343-07-20 | AH-0990-09-18 | ID-1582-41-06 |
| CE-1582-10-17 | EC-1582-10-17 | JD-1582-10-07 | AM-5343-07-21 | AH-0990-09-19 | ID-1582-41-07 |
| CE-1582-10-18 | EC-1582-10-18 | JD-1582-10-08 | AM-5343-07-22 | AH-0990-09-20 | ID-1582-42-01 |

### Range 

The range of validity of the calendars is limited to the range from JD-0001-01-01 to CE-9999-12-31. This choice is by convention but has practical advantages: the four-digit year format of the ISO representation can be met (exception is the Hebrew case, which overflows this format); also, handling dates before the beginning of the Julian epoch is avoided in this way. This means that no year zero appears in our setup apart from the two dates CE-0000-12-30 and 31 (and their `ID` equivalents). We include them only for the sake of completeness at the beginning of the calendar.

The first four days of the calendar are  

| Common        | European      | Julian        | Hebrew        | Islamic       | IsoDate       |  EuroNum   | JulianNum  |
| :---:         |  :---:        | :---:         |  :---:        | :---:         |  :---:        | :---:      | :---:      |
| CE-0000-12-30 | EC-0001-01-01 | JD-0001-01-01 | AM-3761-10-16 | 00-0000-00-00 | ID-0000-52-06 | EN#      1 | JN#1721423 |
| CE-0000-12-31 | EC-0001-01-02 | JD-0001-01-02 | AM-3761-10-17 | 00-0000-00-00 | ID-0000-52-07 | EN#      2 | JN#1721424 |
| CE-0001-01-01 | EC-0001-01-03 | JD-0001-01-03 | AM-3761-10-18 | 00-0000-00-00 | ID-0001-01-01 | EN#      3 | JN#1721425 |
| CE-0001-01-02 | EC-0001-01-04 | JD-0001-01-04 | AM-3761-10-19 | 00-0000-00-00 | ID-0001-01-02 | EN#      4 | JN#1721426 |

 We take advantage of the fact that there is no year zero in the Julian calendar and use it for uniform error handling: the tuple ("00", 0, 0, 0) represents the **invalid date** and is written as the string "00-0000-00-00". In case of invalid input or other errors, this representation is returned. The Islamic dates in the table above show this format because we do not backward extrapolate Islamic dates before JD-0622-07-16 (the start of the Islamic calendar).

The last four days of the calendar are

| Common        | European      | Julian        | Hebrew         | Islamic       | IsoDate       |  EuroNum   | JulianNum  |
| :---:         |  :---:        | :---:         |  :---:         | :---:         |  :---:        | :---:      | :---:      |
| CE-9999-12-28 | EC-9999-12-28 | JD-9999-10-16 | AM-13760-08-25 | AH-9666-03-29 | ID-9999-52-02 | EN#3652058 | JN#5373480 |
| CE-9999-12-29 | EC-9999-12-29 | JD-9999-10-17 | AM-13760-08-26 | AH-9666-03-30 | ID-9999-52-03 | EN#3652059 | JN#5373481 |
| CE-9999-12-30 | EC-9999-12-30 | JD-9999-10-18 | AM-13760-08-27 | AH-9666-04-01 | ID-9999-52-04 | EN#3652060 | JN#5373482 |
| CE-9999-12-31 | EC-9999-12-31 | JD-9999-10-19 | AM-13760-08-28 | AH-9666-04-02 | ID-9999-52-05 | EN#3652061 | JN#5373483 |

The last day represented by the calendar (EC-9999-12-31) has Julian number JN#5373483 and the first day (EC-0001-01-01) has Julian number JN#1721423. Thus the calendar gives 3652061 days a name. EuroNum and JulianNum are simple counters of the days of the European calendar starting with 1, respectively with 1721423, at EC-0001-01-01.

In many cases such a table is overkill. That is why we also offer a week-based format. 

```julia
julia> PrintIsoWeek(2525, 25)
```  

Days of week 25 of the year 2525. 
|  Weekday  |  European  |   Hebrew   |  Islamic   |
|   ---:   |    :---:   |   :---:    |   :---:    |
| Monday    | 2525-06-18 | 6285-03-25 | 1962-04-25 |
| Tuesday   | 2525-06-19 | 6285-03-26 | 1962-04-26 |
| Wednesday | 2525-06-20 | 6285-03-27 | 1962-04-27 |
| Thursday  | 2525-06-21 | 6285-03-28 | 1962-04-28 |
| Friday    | 2525-06-22 | 6285-03-29 | 1962-04-29 |
| Saturday  | 2525-06-23 | 6285-03-30 | 1962-05-01 |
| Sunday    | 2525-06-24 | 6285-04-01 | 1962-05-02 |


The package provides additional functions; read the documentation for this. You might start exploring with a Jupyter [notebook](https://github.com/PeterLuschny/Calendars.jl/blob/main/notebook/Calendars.ipynb).

### Credits

We use the algorithms by Nachum Dershowitz and Edward M. Reingold, described in 'Calendrical Calculations', Software--Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

The picture shows the 'Calendar calculator', owned by Anton Ignaz Joseph Graf von Fugger-Glött, Prince-Provost of Ellwangen, Ostalbkreis, 1765 - Landesmuseum Württemberg, Stuttgart, Germany. The picture is in the public domain. 

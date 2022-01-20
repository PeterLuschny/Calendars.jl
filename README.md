<img src="https://github.com/PeterLuschny/Calendars.jl/blob/main/docs/src/CalendarCalculator.jpg">

.

Registered on [JuliaHub](https://juliahub.com/ui/Packages/Calendars/yDHMq), 
read the [Docs](https://docs.juliahub.com/Calendars/yDHMq), get the source from the [repository](https://github.com/PeterLuschny/Calendars.jl) or install with Pkg.add("Calendars").

# Calendars, Conversions of Dates, Change of Calendars  


The package _Calendar_ provides a Julia implementation of five calendars: 

| Acronym | Calendar  |
| :---:   |  :---     | 
| CE      | Current Epoch |
| AD      | Julian    |
| AM      | Hebrew    |
| AH      | Islamic   |
| ID      | IsoDate   |


Dates can be converted from one to each other. 
Note that we follow ISO 8601 for calendar date representations: 
Year, followed by the month, then the day, YYYY-MM-DD. 
This order is also used in the signature of the functions.
For example, 2022-07-12 represents the 12th of July 2022. 

The main function provided is:

    ConvertDate(date, calendar, show=false). 

It converts a calendar date to the representation of the date in the calendar 'calendar'.

* The calendar date (CDate) is a tuple (calendar, year, month, day). The parts of the date can be given as a tuple or individually.

* 'calendar' is one of "Gregorian", "Hebrew", "Islamic", "Julian", or "IsoDate". Alternatively you can use the acronyms "CE", "AM", "AH", "AD", or "ID" explained in the table above.

* If the optional parameter 'show' is set to 'true', both dates are printed. 'show' is 'false' by default.

For example:

```julia
julia> ConvertDate(("Gregorian", 1756, 1, 27), "Hebrew") 
```

or written alternatively

```julia
julia> ConvertDate("CE", 1756, 1, 27, "AM")
```

computes from the Gregorian date (1756, 1, 27) the Hebrew date (5516, 11, 25). If 'show' is 'true' the line

    "CE 1756-01-27 -> AM 5516-11-25" 

is printed.

A second function returns a table of the dates of all supported calendars.

    CalendarDates(date, show=false).

The parameters follow the same conventions as those of ConvertDate. For example:

```julia
julia> CalendarDates("Gregorian", 1756, 1, 27, true) 
```

computes a table, which is a tuple of five dates plus the day number. If 'show' is 'true' the table below will be printed.

```julia
    CurrentEpoch  CE 1756-01-27
    Julian        AD 1756-01-16
    Hebrew        AM 5516-11-25
    Islamic       AH 1169-04-24
    IsoDate       ID 1756-05-02
    DayNumber     RD 641027
``` 

The package provides additional functions; read the documentation for this.

You might start exploring with a Jupyter [notebook](https://github.com/PeterLuschny/Calendars.jl/blob/main/notebook/Calendars.ipynb).

---


### Credits

We use the algorithms by Nachum Dershowitz and Edward M. Reingold, described in 'Calendrical Calculations', Software--Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

The picture shows the 'Calendar calculator', owned by Anton Ignaz Joseph Graf von Fugger-Glött, Prince-Provost of Ellwangen, Ostalbkreis, 1765 - Landesmuseum Württemberg, Stuttgart, Germany. The picture is in the public domain.
 

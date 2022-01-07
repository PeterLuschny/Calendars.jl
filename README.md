<img src="https://github.com/PeterLuschny/Calendars.jl/blob/main/docs/src/CalendarCalculator.jpg">
--

# Calendars, Conversions of Dates, Change of Calendars  

Currently we support three calendars: 

* Gregorian (CE)
* Hebrew (AM)
* Islamic (AH)

Dates can be converted from each other. The main function provided is 

    ConvertDate(date, A, B, show=false). 

It converts a date represented by the calendar 'A' to the 
representation of the date in the calendar 'B'.

    * The date is an integer triple (year, month, day).

    * 'A' and 'B' is one of "Gregorian", "Hebrew", or "Islamic".

      Alternatively you can use the acronyms "CE", "AM", and "AH".
      They stand for 'Current Epoch' (denoting proleptic Gregorian
      dates), AM for 'Anno Mundi' to denote Hebrew dates, and 
      AH for 'Anno Hegirae' for Islamic dates.

    * If the optional parameter 'show' is set to 'true', both
      dates are printed. 'show' is 'false' by default.

For example:

    >> ConvertDate((1756, 1, 27), "Gregorian", "Hebrew") 

    converts the Gregorian date 1756-01-27 to the
    Hebrew date 5516-11-25. If 'show' is 'true' the line 
           "CE 1756-01-27 -> AM 5516-11-25" 
    is printed.

    Note that we follow ISO 8601 for calendar date representations: 
    Year, followed by the month, then the day, YYYY-MM-DD. 
    This order is also used in the signature of the functions.
    For example, 2022-07-12 represents the 12th of July 2022. 

---

    We use the algorithms by Nachum Dershowitz and Edward M. Reingold,
    described in 'Calendrical Calculations', Software--Practice & Experience, 
    vol. 20, no. 9 (September, 1990), pp. 899--928.

    Calendar calculator, owned by Anton Ignaz Joseph Graf von Fugger-Glött, 
    Prince-Provost of Ellwangen, Ostalbkreis, 1765 - Landesmuseum Württemberg,
    Stuttgart, Germany. The picture is in the public domain, CCO 1.0. 
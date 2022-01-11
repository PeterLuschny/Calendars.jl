![CalendarCalculator](CalendarCalculator.jpg)

     Parts of the Julia code in this package is ported from the Lisp 
     and C++ code in 'Calendrical Calculations' by Nachum Dershowitz
     and Edward M. Reingold, Software---Practice & Experience,
     vol. 20, no. 9 (September, 1990), pp. 899--928.

     This code is in the public domain, but any use of it should 
     publicly acknowledge the above sources, which is done herewith.

     Copyright of this port Peter Luschny, 2022-01-04. 
     Licensed under the MIT license.

    The picture 'Calendar calculator', owned by Anton Ignaz Joseph 
    Graf von Fugger-Glött, Prince-Provost of Ellwangen, Ostalbkreis, 
    1765 - Landesmuseum Württemberg, Stuttgart, Germany. 
    The picture is in the public domain, CCO 1.0. 

 ---------------------------------------------------------------

     It contains the implementation of the Gregorian date, the 
     Hebrew date, and the Islamic date.

     We follow ISO 8601 for calendar date representations: year,
     followed by the month, then the day, YYYY-MM-DD. For example,
     2022-07-12 represents the 12th of July 2022. 
     This order is also used in the signature of the functions.

     "Day number" DN means the number of days elapsed since the 
     Gregorian date Sunday, December 31, 1 BC. Since there was no 
     year 0, the year following 1 BC is 1 AD. Thus the day number 
     of the Gregorian date 0001-01-01 is 1. The DN is called 
     "absolute date" in the cited paper.

     Here the proleptic Gregorian calendar is used, which is 
     produced by extending the Gregorian rules backward to the 
     dates preceding its official introduction.

     A "date" is a name given to a day by a calendar, represented
     by a triple of integers (year, month, day).  A calendar 
     is a map, calendar: DAY -> Y x M x D, where DAY is a set
     of days and Y, M, D are some subsets of the integers 
     specified by the calendar together with an epoch, which is 
     an instant in time chosen as the origin of the calendar. 

     The "day number" is a function DN : Y x M x D -> Z, where Z
     are the integers. It measures the distance of a given day 
     to the origin (to the epoch). To call a day number date is 
     misleading and should be avoided. 

     For instance, the date of Mozart's birth is 1756-01-27. The
     day number associated with this date is 641027 if we assume 
     that the date is a Gregorian date. The Hebrew date of Mozart's 
     birth is 5516-11-25, and the associated day number is the 
     same as the one associated with the Gregorian date.

     We use the acronyms CE for 'Current Epoch' to denote proleptic 
     Gregorian dates, AH for 'Anno Hegirae' for Islamic dates, AM for
     'Anno Mundi' to denote Hebrew dates, and ID for 'ISODate'. Thus 
     CE, AH, AM, and ID are names of calendars. For example we write 
          CE 1756-01-27  =  AM 5516-11-25  ->  DN 641027.

     Limitations: Currently, we do not support conversions for dates 
     prior to the epoch of the respective calendar. The invalid date
     0000-00-00 (which has the invalid day number 0) is returned to
     either signal invalid input or limitations of the method.

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
# Hebrew date, and the Islamic date.

# We follow the C++ version of the above-cited paper, but in a 
# more functional style: we do without classes, operators, and 
# global variables.

# We follow ISO 8601 for calendar date representations: year, 
# followed by the month, then the day, YYYY-MM-DD. For example, 
# 2022-07-12 represents the 12th of July 2022. 
# This order is also used in the signature of the functions.

# "Day number" DN means the number of days elapsed since the 
# Gregorian date Sunday, December 31, 1 BC. Since there was no 
# year 0, the year following 1 BC is 1 AD. Thus the day number 
# of the Gregorian date 0001-01-01 is 1. The DN is called 
# "absolute date" in the cited paper.

# Here the proleptic Gregorian calendar is used, which is 
# produced by extending the Gregorian rules backward to the 
# dates preceding its official introduction.

# A "date" is a name given to a day by a calendar, represented
# by a triple of integers (year, month, day). # A calendar 
# is a map, calendar: DAY -> Y x M x D, where DAY is a set
# of days and Y, M, D are some subsets of the integers 
# specified by the calendar together with an epoch, which is 
# an instant in time chosen as the origin of the calendar. 

# The "day number" is a function DN : Y x M x D -> Z, where Z 
# are the integers. It measures the distance of a given day 
# to the origin (to the epoch). To call a day number date is 
# misleading and should be avoided. 

# For instance, the date of Mozart's birth is 1756-01-27. The 
# day number associated with this date is 641027 if we assume 
# that the date is a Gregorian date. The Hebrew date of Mozart's 
# birth is 5516-11-25, and the associated day number is the 
# same as the one associated with the Gregorian date.

# We use the acronyms CE for 'Current Epoch' to denote proleptic 
# Gregorian dates, AH for 'Anno Hegirae' for Islamic dates, and 
# AM for 'Anno Mundi' to denote Hebrew dates. Thus CE, AH, and 
# AM are names of calendars. For example we write 
#    CE 1756-01-27  =  AM 5516-11-25  ->  DN 641027.

# Limitations: Currently, we support no conversions of dates 
# before CE 0001-01-01. The invalid date 0000-00-00 (which has 
# the invalid day number 0) is returned to either signal invalid 
# input or limitations of the method.

# ---------------------------------------------------------------

module Calendars
using Dates

export DNumberFromDate, DateFromDNumber, ConvertDate

include("GregorianCalendar.jl")
include("HebrewCalendar.jl")
include("IslamicCalendar.jl")

function Date(d) 
    if d[1] <= 0 || d[2] <= 0 || d[3] <= 0
        "0000-00-00"
    else
        Dates.Date(d[1], d[2], d[3])
    end
end

function CalenderName(calendar)
    calendar == "Gregorian" && return "CE"
    calendar == "Hebrew"    && return "AM"
    calendar == "Islamic"   && return "AH"
    @warn("Unknown calendar: $calendar")
    return "XX"
end

Warning(d) = d * "\n We do not support conversions of dates prior to CE 0001-01-01."

"""

Return the day number correspondig to the date of the calendar.

    * The calendar is "Gregorian", "Hebrew", or "Islamic".
      Alternatively use the abbreviations "CE", "AM", and "AH".

    * The date is an integer triple (year, month, day).

    * If the optional parameter 'show' is set to 'true', 
      date and number are printed. 'show' is 'false' by default.

    >> DNumberFromDate("Gregorian", (1756, 1, 27)) 

    returns the day number 641027. If 'show' is 'true' 
    the line "CE 1756-01-27 -> DN 641027" is printed.
"""
function DNumberFromDate(calendar, date, show=false)
    
    if calendar == "Gregorian" || calendar == "CE"
        dn = DNumberGregorian(date)
    elseif calendar == "Hebrew" || calendar == "AM"
        dn = DNumberHebrew(date)
    elseif calendar == "Islamic" || calendar == "AH"
        dn = DNumberIslamic(date)
    else
        @warn("Unknown calendar: $calendar")
        return 0
    end

    if dn <= 0
        @warn(Warning("$calendar$date"))
        return 0
    end

    show && println(CalenderName(calendar), " ", 
            Date(date), " -> DN ", lpad(dn, 7))
    return dn 
end

"""

Return the day number correspondig to the date of the calendar.

    * The calendar is "Gregorian", "Hebrew", or "Islamic".
      Alternatively use the abbreviations "CE", "AM", and "AH".

    * The day number is an integer >= 1.

    * If the optional parameter 'show' is set to 'true', date
      and number are printed. 'show' is 'false' by default.

    >> DateFromDNumber("Gregorian", 641027) 

    returns the date (1756, 1, 27). If 'show' is 'true' 
    the line "DN 641027 -> CE 1756-01-27" is printed.
"""
function DateFromDNumber(calendar, dn, show=false)
    if dn <= 0
        @warn(Warning("$calendar $dn"))
        return (0,0,0)
    end

    if calendar == "Gregorian" || calendar == "CE"
        date = GregorianDate(dn)
    elseif calendar == "Hebrew" || calendar == "AM"
        date = HebrewDate(dn)
    elseif calendar == "Islamic" || calendar == "AH"
        date = IslamicDate(dn) 
    else
        @warn("Unknown calendar: $calendar")
        return (0,0,0)
    end

    show && println("DN ", lpad(dn, 7), " -> ",
        CalenderName(calendar), " ", Date(date))
    return date 
end

"""

Convert a date represented by the calendar 'from' to the 
representation of the date in the calendar 'to'.

    * The date is an integer triple (year, month, day).
    
    * The 'from' and 'to' is "Gregorian", "Hebrew", or "Islamic".
      Alternatively use the abbreviations "CE", "AM", and "AH".

    * If the optional parameter 'show' is set to 'true', both
      dates are printed. 'show' is 'false' by default.

    >> ConvertDate((1756, 1, 27), "Gregorian", "Hebrew") 

    computes for the Gregorian date (1756, 1, 27) the
    Hebrew date (5516, 11, 25). If 'show' is 'true' the
    line "CE 1756-01-27 -> AM 5516-11-25" is printed.
"""
function ConvertDate(date, from, to, show=false, debug=false)
    dn = DNumberFromDate(from, date)
    rdate = dn == 0 ? (0,0,0) : DateFromDNumber(to, dn)  
    if rdate != (0,0,0) 
        debug && print("DN ", lpad(dn, 7), " -> ")
        show && println(CalenderName(from), " ", Date(date), 
                " -> ", CalenderName(to), " ", Date(rdate))
    end
    return rdate 
end

end # module

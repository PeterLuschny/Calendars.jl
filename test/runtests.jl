using Calendars
using Test, Dates

# Symbols for calendar names
DN = :"DN"  # Day Number
CE = :"CE"  # Current Epoch
AD = :"AD"  # Julian
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # Iso Date
XX = :"00"  # Unknown 

# Note that you can use "Gregorian" as the calendar name
# when calling the function, but the System always returns
# the CDate in standard form, where the Gregorian calendar 
# has the name "CE".
function TestDateGregorian()
    SomeDateGregorian = [ 
        ("Gregorian",    1, 1,  1)::CDate, 
        ("Gregorian", 1756, 1, 27)::CDate, 
        ("CE",        2022, 1,  1)::CDate, 
        ("CE",        2022, 9, 26)::CDate  
        ] 

    for date in SomeDateGregorian
        # dn = DNumberGregorian(date)
        # gdate = DateGregorian(dn) 
        dn = DayNumberFromDate(date)
        gdate = DateFromDayNumber(dn, "Gregorian")
        @test gdate == ("CE", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(gdate))
    end
end

#=
CE 0001-01-01 -> DN      1 -> CE 0001-01-01
CE 1756-01-27 -> DN 641027 -> CE 1756-01-27
CE 2022-01-01 -> DN 738156 -> CE 2022-01-01
CE 2022-09-26 -> DN 738424 -> CE 2022-09-26
=#

# Note that you can use "Julian" as the calendar name
# when calling the function, but the System always returns
# the CDate in standard form, where the Julian calendar 
# has the name "AD".
function TestDateJulian()
    SomeDateJulian = [ 
        ("Julian",    1,  1,  3)::CDate,
        ("Julian", 1756,  1, 16)::CDate,
        ("AD",     2021, 12, 19)::CDate,
        ("AD",     2022,  9, 13)::CDate
        ] 

    for date in SomeDateJulian
        #dn = DNumberJulian(date)
        #jdate = DateJulia(dn) 
        dn = DayNumberFromDate(date)
        jdate = DateFromDayNumber(dn, "Julian")
        @test jdate == ("AD", date[2], date[3], date[4]) 
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(jdate))
    end
end

#=
AD 0001-01-03 -> DN      1 -> AD 0001-01-03
AD 1756-01-16 -> DN 641027 -> AD 1756-01-16
AD 2021-12-19 -> DN 738156 -> AD 2021-12-19
AD 2022-09-13 -> DN 738424 -> AD 2022-09-13
=#

# See the comments above!
function TestDateHebrew()
    SomeDateHebrew  = [ 
        ("Hebrew", 5516, 11, 25)::CDate, 
        ("Hebrew", 5782,  7,  1)::CDate,
        ("Hebrew", 5782, 10, 27)::CDate,
        ("AM",     5782,  6, 29)::CDate,
        ("AM",     5783,  7,  1)::CDate
        ]

    for date in SomeDateHebrew
        # dn = DNumberHebrew(date)
        # hdate = DateHebrew(dn) 
        dn = DayNumberFromDate(date)
        hdate = DateFromDayNumber(dn, "Hebrew")
        @test hdate == ("AM", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(hdate))
    end
end

#=
AM 5516-11-25 -> DN 641027 -> AM 5516-11-25
AM 5782-07-01 -> DN 738040 -> AM 5782-07-01
AM 5782-10-27 -> DN 738155 -> AM 5782-10-27
AM 5782-06-29 -> DN 738423 -> AM 5782-06-29
AM 5783-07-01 -> DN 738424 -> AM 5783-07-01
=#

# See the comments above!
function TestDateIslamic()
    SomeDateIslamic = [ 
        ("Islamic",    1, 1,  1)::CDate,
        ("Islamic", 1756, 1, 27)::CDate,
        ("AH",      2022, 1,  1)::CDate,
        ("AH",      2022, 9, 26)::CDate 
        ] 

    for date in SomeDateIslamic
        # dn = DNumberIslamic(date)
        # idate = DateIslamic(dn) 
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber(dn, "Islamic")
        @test idate == ("AH", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(idate))
    end
end

#=
AH 0001-01-01 -> DN 227015 -> AH 0001-01-01
AH 1756-01-27 -> DN 848954 -> AH 1756-01-27
AH 2022-01-01 -> DN 943190 -> AH 2022-01-01
AH 2022-09-26 -> DN 943451 -> AH 2022-09-26
=# 

# See the comments above!
function TestDateIso()
    SomeDateIso = [ 
        ("IsoDate",    1,  1, 1)::CDate,
        ("IsoDate", 1756,  5, 2)::CDate,
        ("ID",      2021, 52, 6)::CDate,
        ("ID",      2022, 39, 1)::CDate 
        ] 

    for date in SomeDateIso
        # dn = DNumberIso(date)
        # idate = IsoDate(dn) 
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber(dn, "IsoDate")
        @test idate == ("ID", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(idate))
    end
end

#=
ID 0001-01-01 -> DN 0000001 -> ID 0001-01-01
ID 1756-05-02 -> DN 0641027 -> ID 1756-05-02
ID 2021-52-06 -> DN 0738156 -> ID 2021-52-06
ID 2022-39-01 -> DN 0738424 -> ID 2022-39-01
=#

function TestConversions()
    
    @test (AM, 9543, 7,24) == ConvertDate(("Gregorian", 5782, 10, 28), "Hebrew") 
    @test (AH, 5319, 8,25) == ConvertDate(("Gregorian", 5782, 10, 28), "Islamic") 
    @test (AM, 5516,11,25) == ConvertDate(("Gregorian", 1756,  1, 27), "Hebrew") 
    @test (AH,    1, 1, 1) == ConvertDate(("Gregorian", 622,   7, 19), "Islamic") 

    println("=")
    @test (AH, 1443, 5,27) == ConvertDate(("Hebrew", 5782, 10, 28), "Islamic") 
    @test (CE, 5782,10,28) == ConvertDate(("Hebrew", 9543,  7, 24), "Gregorian") 
    @test (AH, 4501, 8, 3) == ConvertDate(("Hebrew", 8749, 11, 03), "Islamic") 

    println("==")
    @test (AM, 7025,11,23) == ConvertDate(("Islamic", 2724, 08, 23), "Hebrew") 
    @test (CE, 7025,11,29) == ConvertDate(("Islamic", 6600, 11, 21), "Gregorian") 
    @test (AM, 9992,12,27) == ConvertDate(("Islamic", 5782, 10, 28), "Hebrew") 

    @test (AM, 9543, 7,24) == ConvertDate(("CE", 5782, 10, 28), "AM") 
    @test (AH, 5319, 8,25) == ConvertDate(("CE", 5782, 10, 28), "AH") 
    @test (AM, 5516,11,25) == ConvertDate(("CE", 1756,  1, 27), "AM") 
    @test (AH,    1, 1, 1) == ConvertDate(("CE", 622,   7, 19), "AH") 

    println("===")
    @test (AH, 1443, 5,27) == ConvertDate(("AM", 5782, 10, 28), "AH") 
    @test (CE, 5782,10,28) == ConvertDate(("AM", 9543,  7, 24), "CE") 
    @test (AH, 4501, 8, 3) == ConvertDate(("AM", 8749, 11, 03), "AH") 

    println("====")
    @test (AM, 7025,11,23) == ConvertDate(("AH", 2724, 08, 23), "AM") 
    @test (CE, 7025,11,29) == ConvertDate(("AH", 6600, 11, 21), "CE") 
    @test (AM, 9992,12,27) == ConvertDate(("AH", 5782, 10, 28), "AM") 

    println("\nThe following conversions test warnings, so worry only if you do not see them.\n")
    ConvertDate(("Hebrew", 2022,  1,  1), "Gregorian") 
    ConvertDate(("Hebrew", 5782, 10, 28), "Georgian") 
    ConvertDate(("Homebrew", 2022, 1, 1), "Gregorian") 
end

#=
DN 2111768 -> CE 5782-10-28 -> AM 9543-07-24
DN 2111768 -> CE 5782-10-28 -> AH 5319-08-25
DN  641027 -> CE 1756-01-27 -> AM 5516-11-25
DN  227015 -> CE 0622-07-19 -> AH 0001-01-01

DN  738156 -> AM 5782-10-28 -> AH 1443-05-27
DN 2111768 -> AM 9543-07-24 -> CE 5782-10-28
DN 1821874 -> AM 8749-11-03 -> AH 4501-08-03

DN 1192184 -> AH 2724-08-23 -> AM 7025-11-23
DN 2565796 -> AH 6600-11-21 -> CE 7025-11-29
DN 2275902 -> AH 5782-10-28 -> AM 9992-12-27
=#

function TestDateTables()
TestDates = [
((DN,     0,0,1),(CE,1,1,1),     (AD,1,1,3),     (ID,1,1,1),     (AM,3761,10,18), (AH,   0,0, 0))::DateTable,
((DN,0,0,405733),(CE,1111,11,11),(AD,1111,11,4), (ID,1111,45,6), (AM,4872,9,2),   (AH, 505,4,29))::DateTable,
((DN,0,0,811256),(CE,2222,2,22), (AD,2222,2,7),  (ID,2222,8,5),  (AM,5982,12,10), (AH,1649,9,10))::DateTable,
((DN,0,0,641027),(CE,1756,1,27), (AD,1756,1,16), (ID,1756,5,2),  (AM,5516,11,25), (AH,1169,4,24))::DateTable,
((DN,0,0,738156),(CE,2022,1,1),  (AD,2021,12,19),(ID,2021,52,6), (AM,5782,10,28), (AH,1443,5,27))::DateTable,
((DN,0,0,738424),(CE,2022,9,26), (AD,2022,9,13), (ID,2022,39,1), (AM,5783,7,1),   (AH,1444,2,29))::DateTable
]

    for D in TestDates
        println()
        PrintDateTable(D)
    end
end

#=
DayNumber    DN 0000001
CurrentEpoch CE 0001-01-01
Julian       AD 0001-01-03
IsoDate      ID 0001-01-01
Hebrew       AM 3761-10-18
Islamic      AH 0000-00-00

DayNumber    DN 0405733
CurrentEpoch CE 1111-11-11
Julian       AD 1111-11-04
IsoDate      ID 1111-45-06
Hebrew       AM 4872-09-02
Islamic      AH 0505-04-29

DayNumber    DN 0811256
CurrentEpoch CE 2222-02-22
Julian       AD 2222-02-07
IsoDate      ID 2222-08-05
Hebrew       AM 5982-12-10
Islamic      AH 1649-09-10

DayNumber    DN 0641027
CurrentEpoch CE 1756-01-27
Julian       AD 1756-01-16
IsoDate      ID 1756-05-02
Hebrew       AM 5516-11-25
Islamic      AH 1169-04-24
=#

function TestCalenderDates()
    println("---")
    CalendarDates((CE, 1111,11,11), true); println()
    CalendarDates((AD, 1111,11, 4), true); println()
    CalendarDates((ID, 1111,45, 6), true); println()
    CalendarDates((AM, 4872, 9, 2), true); println()
    CalendarDates((AH, 0505, 4,29), true); println()
    println("---")
    CalendarDates((CE, 2222, 2,22), true); println()
    CalendarDates((AD, 2222, 2, 7), true); println()
    CalendarDates((ID, 2222, 8, 5), true); println()
    CalendarDates((AM, 5982,12,10), true); println()
    CalendarDates((AH, 1649, 9,10), true); println()
    println("---")
    CalendarDates((CE, 1756, 1,27), true); println()
    CalendarDates((AD, 1756, 1,16), true); println()
    CalendarDates((ID, 1756, 5, 2), true); println()
    CalendarDates((AM, 5516,11,25), true); println()
    CalendarDates((AH, 1169, 4,24), true); println()
    println("---")
    CalendarDates((CE, 3141, 5, 9), true); println()
    CalendarDates((AD, 3141, 4,17), true); println()
    CalendarDates((ID, 3141,19, 5), true); println()
    CalendarDates((AM, 6901, 2, 9), true); println()
    CalendarDates((AH, 2597, 2,10), true); println()
end

function TestDuration()
    Duration((CE, 2022, 1, 1), (ID, 2022, 1, 1), true)
    Duration((ID, 2022, 1, 1), (CE, 2022, 1, 1), true)
    Duration((CE, 2022, 1, 1), (CE, 2022, 1, 1), true)
    Duration((ID, 2022, 1, 1), (CE, 2022, 1, 3), true)
end

function TestAll()
    TestDateGregorian(); println()
    TestDateJulian();    println()
    TestDateHebrew();    println()
    TestDateIslamic();   println()
    TestDateIso();       println()
 
    TestConversions();  println()
    TestDateTables();   println()
    TestCalenderDates()
end

TestAll()

#=
function TestDayOfYear()
    date = (2022, 1, 1)
    for c in [CE, AD, AM, AH, ID]  
        println(CDate(c, date), " ::", lpad(DayOfYear(date, c),  4, " "))
    end
    date = (1756,  1, 27)
    for c in [CE, AD, AM, AH, ID]  
        println(CDate(c, date), " ::", lpad(DayOfYear(date, c),  4, " "))
    end
    date = (1949, 11, 29)
    for c in [CE, AD, AM, AH, ID]  
        println(CDate(c, date), " ::", lpad(DayOfYear(date, c),  4, " "))
    end
    date = (1990, 10, 20)  
    for c in [CE, AD, AM, AH, ID]  
        println(CDate(c, date), " ::", lpad(DayOfYear(date, c),  4, " "))
    end
end

TestDayOfYear(); println()
=#

println("Today in all calendars:\n")
now = Dates.yearmonthday(Dates.now())
date = ("CE", now[1], now[2], now[3])
CalendarDates(date, true)
# println("Today is the ", DayOfYear(date), 
# "-th day of the year ", date[2], " in the Gregorian calendar.")


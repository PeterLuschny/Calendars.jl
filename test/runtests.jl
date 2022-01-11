using Calendars
using Test

function TestGregorianDates()
    SomeGregorianDates = [ (1, 1, 1), (1756, 1, 27), (2022, 1, 1), 
                           (2022, 9, 26) ] 

    for date in SomeGregorianDates
        # dn = DNumberGregorian(date)
        # gdate = GregorianDate(dn) 
        dn = DNumberFromDate(date, "Gregorian")
        gdate = DateFromDNumber(dn, "Gregorian")
        @test gdate == (CE, date[1], date[2], date[3])  
        println(CDate(CE, date), " -> ", CDate(DN, dn), " -> ", CDate(gdate))
    end
end

#=
CE 0001-01-01 -> DN      1 -> CE 0001-01-01
CE 1756-01-27 -> DN 641027 -> CE 1756-01-27
CE 2022-01-01 -> DN 738156 -> CE 2022-01-01
CE 2022-09-26 -> DN 738424 -> CE 2022-09-26
=#

function TestJulianDates()
    SomeJulianDates = [ (1, 1, 3), (1756, 1, 16), (2021, 12, 19), (2022, 9, 13) ] 

    for date in SomeJulianDates
        #dn = DNumberJulian(date)
        #jdate = JulianDate(dn) 
        dn = DNumberFromDate(date, "Julian")
        jdate = DateFromDNumber(dn, "Julian")
        @test jdate == (AD, date[1], date[2], date[3]) 
        println(CDate(AD, date), " -> ", CDate(DN, dn), " -> ", CDate(jdate))
    end
end

#=
AD 0001-01-03 -> DN      1 -> AD 0001-01-03
AD 1756-01-16 -> DN 641027 -> AD 1756-01-16
AD 2021-12-19 -> DN 738156 -> AD 2021-12-19
AD 2022-09-13 -> DN 738424 -> AD 2022-09-13
=#


function TestHebrewDates()
    SomeHebrewDates  = [ (5516, 11, 25), (5782, 7, 1), (5782, 10, 27), 
                         (5782,  6, 29), (5783, 7, 1) ]

    for date in SomeHebrewDates
        # dn = DNumberHebrew(date)
        # hdate = HebrewDate(dn) 
        dn = DNumberFromDate(date, "Hebrew")
        hdate = DateFromDNumber(dn, "Hebrew")
        @test hdate == (AM, date[1], date[2], date[3])
        println(CDate(AM, date), " -> ", CDate(DN, dn), " -> ", CDate(hdate))
    end
end

#=
AM 5516-11-25 -> DN 641027 -> AM 5516-11-25
AM 5782-07-01 -> DN 738040 -> AM 5782-07-01
AM 5782-10-27 -> DN 738155 -> AM 5782-10-27
AM 5782-06-29 -> DN 738423 -> AM 5782-06-29
AM 5783-07-01 -> DN 738424 -> AM 5783-07-01
=#


function TestIslamicDates()
    SomeIslamicDates = [ (1, 1, 1), (1756, 1, 27), (2022, 1, 1), (2022, 9, 26) ] 

    for date in SomeIslamicDates
        # dn = DNumberIslamic(date)
        # idate = IslamicDate(dn) 
        dn = DNumberFromDate(date, "Islamic")
        idate = DateFromDNumber(dn, "Islamic")
        @test idate == (AH, date[1], date[2], date[3])
        println(CDate(AH, date), " -> ", CDate(DN, dn), " -> ", CDate(idate))
    end
end

#=
AH 0001-01-01 -> DN 227015 -> AH 0001-01-01
AH 1756-01-27 -> DN 848954 -> AH 1756-01-27
AH 2022-01-01 -> DN 943190 -> AH 2022-01-01
AH 2022-09-26 -> DN 943451 -> AH 2022-09-26
=# 

function TestIsoDates()
    SomeIsoDates = [ (1, 1, 1), 
    (1756, 5, 2), (2021, 52, 6), (2022, 39, 1) ] 

    for date in SomeIsoDates
        # dn = DNumberIso(date)
        # idate = ISODate(dn) 
        dn = DNumberFromDate(date, "ISODate")
        idate = DateFromDNumber(dn, "ISODate")
        @test idate == (ID, date[1], date[2], date[3])
        println(CDate(ID, date), " -> ", CDate(DN, dn), " -> ", CDate(idate))
    end
end

# Symbols for calendar names
DN = :"DN"  # Day Number
CE = :"CE"  # Current Epoch
AD = :"AD"  # Julian
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # Iso Date
XX = :"00"  # Unknown 

function TestConversions1()
    
    @test (AM, 9543, 7,24) == ConvertDate((5782, 10, 28), "Gregorian", "Hebrew") 
    @test (AH, 5319, 8,25) == ConvertDate((5782, 10, 28), "Gregorian", "Islamic") 
    @test (AM, 5516,11,25) == ConvertDate((1756,  1, 27), "Gregorian", "Hebrew") 
    @test (AH,    1, 1, 1) == ConvertDate((622,   7, 19), "Gregorian", "Islamic") 

    println()
    @test (AH, 1443, 5,27) == ConvertDate((5782, 10, 28), "Hebrew", "Islamic") 
    @test (CE, 5782,10,28) == ConvertDate((9543,  7, 24), "Hebrew", "Gregorian") 
    @test (AH, 4501, 8, 3) == ConvertDate((8749, 11, 03), "Hebrew", "Islamic") 

    println()
    @test (AM, 7025,11,23) == ConvertDate((2724, 08, 23), "Islamic", "Hebrew") 
    @test (CE, 7025,11,29) == ConvertDate((6600, 11, 21), "Islamic", "Gregorian") 
    @test (AM, 9992,12,27) == ConvertDate((5782, 10, 28), "Islamic", "Hebrew") 

    println("\nThe following conversions test warnings, so worry only if you do not see them.\n")
    ConvertDate((2022,  1,  1), "Hebrew",   "Gregorian") 
    ConvertDate((5782, 10, 28), "Hebrew",   "Georgian") 
    ConvertDate((2022,  1,  1), "Homebrew", "Gregorian") 
end

function TestConversions2()
    debug = true

    @test (AM, 9543, 7,24) == ConvertDate((5782, 10, 28), "CE", "AM") 
    @test (AH, 5319, 8,25) == ConvertDate((5782, 10, 28), "CE", "AH") 
    @test (AM, 5516,11,25) == ConvertDate((1756,  1, 27), "CE", "AM") 
    @test (AH,    1, 1, 1) == ConvertDate((622,   7, 19), "CE", "AH") 

    println()
    @test (AH, 1443, 5,27) == ConvertDate((5782, 10, 28), "AM", "AH") 
    @test (CE, 5782,10,28) == ConvertDate((9543,  7, 24), "AM", "CE") 
    @test (AH, 4501, 8, 3) == ConvertDate((8749, 11, 03), "AM", "AH") 

    println()
    @test (AM, 7025,11,23) == ConvertDate((2724, 08, 23), "AH", "AM") 
    @test (CE, 7025,11,29) == ConvertDate((6600, 11, 21), "AH", "CE") 
    @test (AM, 9992,12,27) == ConvertDate((5782, 10, 28), "AH", "AM") 
    
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

function TestDateInfos()
TestDates = [
((DN,     0,0,1),(CE,1,1,1),     (AD,1,1,3),     (ID,1,1,1),     (AM,3761,10,18), (AH,   0,0, 0))::DateInfo,
((DN,0,0,405733),(CE,1111,11,11),(AD,1111,11,4), (ID,1111,45,6), (AM,4872,9,2),   (AH, 505,4,29))::DateInfo,
((DN,0,0,811256),(CE,2222,2,22), (AD,2222,2,7),  (ID,2222,8,5),  (AM,5982,12,10), (AH,1649,9,10))::DateInfo,
((DN,0,0,641027),(CE,1756,1,27), (AD,1756,1,16), (ID,1756,5,2),  (AM,5516,11,25), (AH,1169,4,24))::DateInfo,
((DN,0,0,738156),(CE,2022,1,1),  (AD,2021,12,19),(ID,2021,52,6), (AM,5782,10,28), (AH,1443,5,27))::DateInfo,
((DN,0,0,738424),(CE,2022,9,26), (AD,2022,9,13), (ID,2022,39,1), (AM,5783,7,1),   (AH,1444,2,29))::DateInfo
]

    for D in TestDates
        println()
        PrintDateInfo(D)
    end
end

#=
DayNumber    DN 0000001
CurrentEpoch CE 0001-01-01
Julian       AD 0001-01-03
ISODate      ID 0001-01-01
Hebrew       AM 3761-10-18
Islamic      AH 0000-00-00

DayNumber    DN 0405733
CurrentEpoch CE 1111-11-11
Julian       AD 1111-11-04
ISODate      ID 1111-45-06
Hebrew       AM 4872-09-02
Islamic      AH 0505-04-29

DayNumber    DN 0811256
CurrentEpoch CE 2222-02-22
Julian       AD 2222-02-07
ISODate      ID 2222-08-05
Hebrew       AM 5982-12-10
Islamic      AH 1649-09-10

DayNumber    DN 0641027
CurrentEpoch CE 1756-01-27
Julian       AD 1756-01-16
ISODate      ID 1756-05-02
Hebrew       AM 5516-11-25
Islamic      AH 1169-04-24
=#

function TestCalenderDates()
println("---")
CalendarDates(1111,11,11, CE, true); println()
CalendarDates(1111,11, 4, AD, true); println()
CalendarDates(1111,45, 6, ID, true); println()
CalendarDates(4872, 9, 2, AM, true); println()
CalendarDates(0505, 4,29, AH, true); println()
println("---")
CalendarDates(2222, 2,22, CE, true); println()
CalendarDates(2222, 2, 7, AD, true); println()
CalendarDates(2222, 8, 5, ID, true); println()
CalendarDates(5982,12,10, AM, true); println()
CalendarDates(1649, 9,10, AH, true); println()
println("---")
CalendarDates(1756, 1,27, CE, true); println()
CalendarDates(1756, 1,16, AD, true); println()
CalendarDates(1756, 5, 2, ID, true); println()
CalendarDates(5516,11,25, AM, true); println()
CalendarDates(1169, 4,24, AH, true); println()
println("---")
CalendarDates(3141, 5, 9, CE, true); println()
CalendarDates(3141, 4,17, AD, true); println()
CalendarDates(3141,19, 5, ID, true); println()
CalendarDates(6901, 2, 9, AM, true); println()
CalendarDates(2597, 2,10, AH, true); println()
println("---")
CalendarDates(1,    1, 1, CE, true); println()
CalendarDates(1,    1, 3, AD, true); println()
CalendarDates(3761,10,18, AM, true); println()
CalendarDates(1,    1, 1, ID, true); println()
end

TestGregorianDates(); println()
TestJulianDates();    println()
TestHebrewDates();    println()
TestIslamicDates();   println()
TestIsoDates();       println()
 
TestConversions1();   println()
TestConversions2();   println()

TestDateInfos()
TestCalenderDates()

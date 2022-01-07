using Calendars
using Dates, Test

function Date(d) 
    if d[1] <= 0 || d[2] <= 0 || d[3] <= 0
        "0000-00-00"
    else
        Dates.Date(d[1], d[2], d[3])
    end
end


function TestGregorianDates()
    SomeGregorianDates = [ (1, 1, 1), (1756, 1, 27), (2022, 1, 1), 
                           (2022, 9, 26) ] 

    for gdate in SomeGregorianDates
        # dn = DNumberGregorian(gdate)
        # date = GregorianDate(dn) 
        dn = DNumberFromDate("Gregorian", gdate)
        date = DateFromDNumber("Gregorian", dn)
        println("CE ", Date(gdate), " -> DN ", dn, " -> CE ", Date(date))
        @test gdate == date
    end
end

#=
CE 0001-01-01 -> DN      1 -> CE 0001-01-01
CE 1756-01-27 -> DN 641027 -> CE 1756-01-27
CE 2022-01-01 -> DN 738156 -> CE 2022-01-01
CE 2022-09-26 -> DN 738424 -> CE 2022-09-26
=#


function TestHebrewDates()
    SomeHebrewDates  = [ (5516, 11, 25), (5782, 7, 1), (5782, 10, 27), 
                         (5782,  6, 29), (5783, 7, 1) ]

    for hdate in SomeHebrewDates
        # dn = DNumberHebrew(hdate)
        # date = HebrewDate(dn) 
        dn = DNumberFromDate("Hebrew", hdate)
        date = DateFromDNumber("Hebrew", dn)
        println("AM ", Date(hdate), " -> DN ", dn, " -> AM ", Date(date))
        @test hdate == date
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

    for idate in SomeIslamicDates
        # dn = DNumberIslamic(idate)
        # date = IslamicDate(dn) 
        dn = DNumberFromDate("Islamic", idate)
        date = DateFromDNumber("Islamic", dn)
        println("AH ", Date(idate), " -> DN ", dn, " -> AH ", Date(date))
        @test idate == date
    end
end

#=
AH 0001-01-01 -> DN 227015 -> AH 0001-01-01
AH 1756-01-27 -> DN 848954 -> AH 1756-01-27
AH 2022-01-01 -> DN 943190 -> AH 2022-01-01
AH 2022-09-26 -> DN 943451 -> AH 2022-09-26
=# 


function TestConversions()
    debug = true
    
    @test (9543, 7,24) == ConvertDate((5782, 10, 28), "Gregorian", "Hebrew",  true, debug)
    @test (5319, 8,25) == ConvertDate((5782, 10, 28), "Gregorian", "Islamic", true, debug) 
    @test (5516,11,25) == ConvertDate((1756,  1, 27), "Gregorian", "Hebrew",  true, debug) 
    @test (   1, 1, 1) == ConvertDate((622,   7, 19), "Gregorian", "Islamic", true, debug) 
    
    println()
    @test (1443, 5,27) == ConvertDate((5782, 10, 28), "Hebrew", "Islamic",   true, debug) 
    @test (5782,10,28) == ConvertDate((9543,  7, 24), "Hebrew", "Gregorian", true, debug) 
    @test (4501, 8, 3) == ConvertDate((8749, 11, 03), "Hebrew", "Islamic",   true, debug) 

    println()
    @test (7025,11,23) == ConvertDate((2724, 08, 23), "Islamic", "Hebrew",    true, debug) 
    @test (7025,11,29) == ConvertDate((6600, 11, 21), "Islamic", "Gregorian", true, debug) 
    @test (9992,12,27) == ConvertDate((5782, 10, 28), "Islamic", "Hebrew",    true, debug) 

    println("\nThe following warnings are OK.\n")
    ConvertDate((2022,  1,  1), "Hebrew",   "Gregorian", true, debug) 
    ConvertDate((5782, 10, 28), "Hebrew",   "Georgian",  true, debug) 
    ConvertDate((2022,  1,  1), "Homebrew", "Gregorian", true, debug) 
end

#=
DN 2111768 -> CE 5782-10-28 -> AM 9543-07-24
DN 2111768 -> CE 5782-10-28 -> AH 5319-08-25
DN  641027 -> CE 1756-01-27 -> AM 5516-11-25
DN  227012 -> CE 0622-07-16 -> AH 0000-00-00

DN  738156 -> AM 5782-10-28 -> AH 1443-05-27
DN 2111768 -> AM 9543-07-24 -> CE 5782-10-28
DN 1821874 -> AM 8749-11-03 -> AH 4501-08-03

DN 1192184 -> AH 2724-08-23 -> AM 7025-11-23
DN 2565796 -> AH 6600-11-21 -> CE 7025-11-29
DN 2275902 -> AH 5782-10-28 -> AM 9992-12-27
=#


TestGregorianDates(); println()
TestHebrewDates();    println()
TestIslamicDates();   println()
TestConversions()

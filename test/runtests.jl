using Calendars
using Test, Dates

# Symbols for calendar names
CE = :"CE"  # Current Epoch
AD = :"AD"  # Julian
HC = :"HC"  # Historical Calendar
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
RD = :"RD"  # Day Number
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

    @testset "DateGregorian" begin
    for date in SomeDateGregorian
        # dn = DayNumberGregorian(date)
        # gdate = DateGregorian(dn) 
        dn = DayNumberFromDate(date)
        gdate = DateFromDayNumber("Gregorian", dn)
        @test gdate == ("CE", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(gdate))
    end
    end
end

#=
CE 0001-01-01 -> RD      1 -> CE 0001-01-01
CE 1756-01-27 -> RD 641027 -> CE 1756-01-27
CE 2022-01-01 -> RD 738156 -> CE 2022-01-01
CE 2022-09-26 -> RD 738424 -> CE 2022-09-26
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

    @testset "DateJulian" begin
    for date in SomeDateJulian
        #dn = DayNumberJulian(date)
        #jdate = DateJulia(dn) 
        dn = DayNumberFromDate(date)
        jdate = DateFromDayNumber("Julian", dn)
        @test jdate == ("AD", date[2], date[3], date[4]) 
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(jdate))
    end
    end
end

#=
AD 0001-01-03 -> RD      1 -> AD 0001-01-03
AD 1756-01-16 -> RD 641027 -> AD 1756-01-16
AD 2021-12-19 -> RD 738156 -> AD 2021-12-19
AD 2022-09-13 -> RD 738424 -> AD 2022-09-13
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

    @testset "DateHebrew" begin
    for date in SomeDateHebrew
        # dn = DayNumberHebrew(date)
        # hdate = DateHebrew(dn) 
        dn = DayNumberFromDate(date)
        hdate = DateFromDayNumber("Hebrew", dn)
        @test hdate == ("AM", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(hdate))
    end
    end
end

#=
AM 5516-11-25 -> RD 641027 -> AM 5516-11-25
AM 5782-07-01 -> RD 738040 -> AM 5782-07-01
AM 5782-10-27 -> RD 738155 -> AM 5782-10-27
AM 5782-06-29 -> RD 738423 -> AM 5782-06-29
AM 5783-07-01 -> RD 738424 -> AM 5783-07-01
=#

# See the comments above!
function TestDateIslamic()
    SomeDateIslamic = [ 
        ("Islamic",    1, 1,  1)::CDate,
        ("Islamic", 1756, 1, 27)::CDate,
        ("AH",      2022, 1,  1)::CDate,
        ("AH",      2022, 9, 26)::CDate 
        ] 

    @testset "DateIslamic" begin
    for date in SomeDateIslamic
        # dn = DayNumberIslamic(date)
        # idate = DateIslamic(dn) 
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber("Islamic", dn)
        @test idate == ("AH", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(idate))
    end
    end
end

#=
AH 0001-01-01 -> RD 227015 -> AH 0001-01-01
AH 1756-01-27 -> RD 848954 -> AH 1756-01-27
AH 2022-01-01 -> RD 943190 -> AH 2022-01-01
AH 2022-09-26 -> RD 943451 -> AH 2022-09-26
=# 

# See the comments above!
function TestDateIso()
    SomeDateIso = [ 
        ("IsoDate",    1,  1, 1)::CDate,
        ("IsoDate", 1756,  5, 2)::CDate,
        ("ID",      2021, 52, 6)::CDate,
        ("ID",      2022, 39, 1)::CDate 
        ] 

    @testset "DateIso" begin
    for date in SomeDateIso
        # dn = DayNumberIso(date)
        # idate = IsoDate(dn) 
        dn = DayNumberFromDate(date)
        idate = DateFromDayNumber("IsoDate", dn)
        @test idate == ("ID", date[2], date[3], date[4])
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(idate))
    end
    end
end

#=
ID 0001-01-01 -> RD 0000001 -> ID 0001-01-01
ID 1756-05-02 -> RD 0641027 -> ID 1756-05-02
ID 2021-52-06 -> RD 0738156 -> ID 2021-52-06
ID 2022-39-01 -> RD 0738424 -> ID 2022-39-01
=#

function TestConversions()
    
    @testset "Conversions" begin
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

    end

    println("\nThe following 3 conversions test warnings, so worry only if you do not see them.\n")
    ConvertDate(("Hebrew", 2022,  1,  1), "Gregorian") 
    ConvertDate(("Hebrew", 5782, 10, 28), "Georgian") 
    ConvertDate(("Homebrew", 2022, 1, 1), "Gregorian") 
end

#=
RD 2111768 -> CE 5782-10-28 -> AM 9543-07-24
RD 2111768 -> CE 5782-10-28 -> AH 5319-08-25
RD  641027 -> CE 1756-01-27 -> AM 5516-11-25
RD  227015 -> CE 0622-07-19 -> AH 0001-01-01

RD  738156 -> AM 5782-10-28 -> AH 1443-05-27
RD 2111768 -> AM 9543-07-24 -> CE 5782-10-28
RD 1821874 -> AM 8749-11-03 -> AH 4501-08-03

RD 1192184 -> AH 2724-08-23 -> AM 7025-11-23
RD 2565796 -> AH 6600-11-21 -> CE 7025-11-29
RD 2275902 -> AH 5782-10-28 -> AM 9992-12-27
=#

function TestDateTables()

# The case (AH, 0, 0, 0) is not valid and excluded in the test.
TestDates = [
((RD,     0,0,1),(CE,1,1,1),     (AD,1,1,3), (HC,1,1,3),         (ID,1,1,1),     (AM,3761,10,18), (AH,   0,0, 0))::DateTable,
((RD,0,0,405733),(CE,1111,11,11),(AD,1111,11,4), (HC,1111,11,4), (ID,1111,45,6), (AM,4872,9,2),   (AH, 505,4,29))::DateTable,
((RD,0,0,811256),(CE,2222,2,22), (AD,2222,2,7),  (HC,2222,2,22), (ID,2222,8,5),  (AM,5982,12,10), (AH,1649,9,10))::DateTable,
((RD,0,0,641027),(CE,1756,1,27), (AD,1756,1,16), (HC,1756,1,27), (ID,1756,5,2),  (AM,5516,11,25), (AH,1169,4,24))::DateTable,
((RD,0,0,738156),(CE,2022,1,1),  (AD,2021,12,19),(HC,2022,1,1),  (ID,2021,52,6), (AM,5782,10,28), (AH,1443,5,27))::DateTable,
((RD,0,0,738424),(CE,2022,9,26), (AD,2022,9,13),(HC,2022,9,26),  (ID,2022,39,1), (AM,5783,7,1),   (AH,1444,2,29))::DateTable,
((RD,0,0,1146990),(CE, 3141,5,9),(AD,3141,4,17),(HC,3141,5,9),   (ID,3141,19,5), (AM,6901,2,9),   (AH,2597,2,10))::DateTable
]
    @testset "DayNumbers" begin
    for D in TestDates
        println()
        PrintDateTable(D)
        num = D[1][4]
        
        for d in D[2:end]
            dn = DayNumberFromDate(d)
            if dn > 0
                @test dn == num
            end
        end
    end
    end
end

#=
DayNumber    RD 0000001
CurrentEpoch CE 0001-01-01
Julian       AD 0001-01-03
IsoDate      ID 0001-01-01
Hebrew       AM 3761-10-18
Islamic      AH 0000-00-00

DayNumber    RD 0405733
CurrentEpoch CE 1111-11-11
Julian       AD 1111-11-04
IsoDate      ID 1111-45-06
Hebrew       AM 4872-09-02
Islamic      AH 0505-04-29

DayNumber    RD 0811256
CurrentEpoch CE 2222-02-22
Julian       AD 2222-02-07
IsoDate      ID 2222-08-05
Hebrew       AM 5982-12-10
Islamic      AH 1649-09-10

DayNumber    RD 0641027
CurrentEpoch CE 1756-01-27
Julian       AD 1756-01-16
IsoDate      ID 1756-05-02
Hebrew       AM 5516-11-25
Islamic      AH 1169-04-24

DayNumber    RD 1146990
CurrentEpoch CE 3141-05-09
Julian       AD 3141-04-17
IsoDate      ID 3141-19-05
Hebrew       AM 6901-02-09
Islamic      AH 2597-02-10
=#

function TestDuration()
    @testset "Duration" begin
    @test 2 == Duration((CE, 2022, 1, 1), (ID, 2022, 1, 1), true) 
    @test 2 == Duration((ID, 2022, 1, 1), (CE, 2022, 1, 1), true) 
    @test 0 == Duration((CE, 2022, 1, 1), (CE, 2022, 1, 1), true) 
    @test 0 == Duration((ID, 2022, 1, 1), (CE, 2022, 1, 3), true) 
    # Nota bene, not 365! Duration is a paradise for off-by-one errors.
    @test 364 == Duration((CE, 2022, 1, 1), (CE, 2022, 12, 31), true) 
    @test 365 == Duration((CE, 2022, 1, 1), (CE, 2023,  1,  1), true) 
    end
end

function TestDayOfYear()
    DOY = [
        ((CE, 1000,02,28),  59), 
        ((CE, 1000,02,29),   0), 
        ((CE, 1111,11,11), 315),
        ((CE, 1756,01,27),  27),
        ((CE, 1900,02,28),  59), 
        ((CE, 1900,02,29),   0), 
        ((CE, 1901,02,28),  59), 
        ((CE, 1901,02,29),   0), 
        ((CE, 1949,11,29), 333),
        ((CE, 1990,10,20), 293),
        ((CE, 2000,02,28),  59), 
        ((CE, 2000,02,29),  60), 
        ((CE, 2020,02,28),  59), 
        ((CE, 2020,02,29),  60), 
        ((CE, 2020,07,30), 212), 
        ((CE, 2020,08,20), 233), 
        ((CE, 2021,09,07), 250),  
        ((CE, 2022,01,01),   1),
        ((CE, 2022,09,26), 269),
        ((CE, 2023,07,19), 200),
        ((CE, 2040,02,28),  59), 
        ((CE, 2040,02,29),  60), 
        ((CE, 2040,09,08), 252), 
        ((CE, 2222,02,22),  53),
        ((CE, 3141,05,09), 129)
    ]

    println("\n====================\n")

    @testset "DayOfYear" begin
    for x in DOY
        date, num = x
        doy = DayOfYear(date)
        print(CDateStr(date), " ::", lpad(num, 4, " "), lpad(doy, 4, " "))
        println(" ", doy == num)
        @test doy == num
    end
    end
end

function ShowDayOfYear()
    println("\n======== NEEDS CONFIRMED TEST DATA! ============\n")

    date = (2022, 1, 1)
    for c in [CE, AD, HC, AM, AH]  
        println(CDateStr(c, date), " ::", lpad(DayOfYear(c, date),  4, " "))
    end
    println()
    date = (1756,  1, 27)
    for c in [CE, AD, HC, AM, AH] 
        println(CDateStr(c, date), " ::", lpad(DayOfYear(c, date),  4, " "))
    end
    println()
    date = (1949, 11, 29)
    for c in [CE, AD, HC, AM, AH] 
        println(CDateStr(c, date), " ::", lpad(DayOfYear(c, date),  4, " "))
    end
    println()
    date = (1990, 10, 20)  
    for c in [CE, AD, HC, AM, AH] 
        println(CDateStr(c, date), " ::", lpad(DayOfYear(c, date),  4, " "))
    end
end

#=
CE 0800-12-25 -> RD 0292188
292188 2013612 -386388
2013612 292188 292188

CE 0843-08-10 -> RD 0307756
307756 2029180 -370820
2029180 307756 307756

CE 1204-04-12 -> RD 0439489
439489 2160913 -239087
2160913 439489 439489

CE 1452-04-15 -> RD 0530072
530072 2251496 -148504
2251496 530072 530072

CE 1666-09-02 -> RD 0608374
608374 2329798 -70202
2329798 608374 608374

CE 1789-07-14 -> RD 0653249
653249 2374673 -25327
2374673 653249 653249

CE 1906-04-28 -> RD 0695904
695904 2417328 17328
2417328 695904 695904
=#

function TestJulianDayNumbers()
    test = [
    ((CE,800,12,25)::CDate, 292188, 2013612, -386388),  # Coronation of Carolus Magnus
    ((CE,843,8,10)::CDate,  307756, 2029180, -370820),  # Treaty of Verdun
    ((CE,1204,4,12)::CDate, 439489, 2160913, -239087),  # Sack of Constantinople
    ((CE,1452,4,15)::CDate, 530072, 2251496, -148504),  # Birth of Leonardo da Vinci
    ((CE,1666,9,2)::CDate,  608374, 2329798, -70202),   # Great Fire of London
    ((CE,1789,7,14)::CDate, 653249, 2374673, -25327),   # The Storming of the Bastille
    ((CE,1906,4,28)::CDate, 695904, 2417328, 17328)]    # Birth of Kurt Gödel

    @testset "JulianDayNumbers" begin
    for t in test
        println()
        rd   = DayNumberFromDate(t[1], true)
        jdn  = RDToJulianNumber(rd) 
        jdnm = RDToJulianNumber(rd, true) 
        @test jdn  == t[3]
        @test jdnm == t[4]
        println(rd, " ", jdn, " ", jdnm)
        rdn  = JulianNumberToRD(jdn) 
        rdnm = JulianNumberToRD(jdnm, true) 
        @test rdn  == t[2]
        @test rdnm == t[2]
        println(jdn, " ", rdn, " ", rdnm)
    end
    end
end

# DayOfLife is an OrdinalDate, not a Duration!
function DayOfLife(birthdate::CDate) 
    if isValidDate(birthdate) 
        y, m, d = Dates.yearmonthday(Dates.now())
        return Duration(birthdate, (CE, y, m, d)) + 1
    end
    @warn("Invalid Date: $birthdate")
    return InvalidDuration
end

function TestToday()
    println("\nMozart would be ", DayOfLife((CE, 1756, 1, 27)), " days old today.")
    println("\nToday on all calendars:\n")
    now = Dates.yearmonthday(Dates.now())
    date = ("CE", now[1], now[2], now[3])
    CalendarDates(date, true)
    doy = DayOfYear(date)
    println("\nThis is the $doy-th day of a CE-year.")
end

function TestAll()
    TestDateGregorian(); println()
    TestDateJulian();    println()
    TestDateHebrew();    println()
    TestDateIslamic();   println()
    TestDateIso();       println()
 
    TestConversions();   println()
    TestDateTables();    println()
    TestDuration();      println()
    TestJulianDayNumbers()
    TestDayOfYear();     println()
    # ShowDayOfYear();     println()
    TestToday()
end

TestAll()

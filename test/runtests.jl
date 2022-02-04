using Calendars
using Test, Dates

# Symbols for calendar names
CE = :"CE"  # Common Era
EC = :"EC"  # European Calendar
JD = :"JD"  # Julian (Roman Calendar)
AM = :"AM"  # Anno Mundi
AH = :"AH"  # Anno Hegirae
ID = :"ID"  # ISO Date
EN = :"EN"  # Euro Number
JN = :"JN"  # Julian Number
DN = :"DN"  # FixDay Number
XX = :"00"  # Unknown 

# Note that you can use "Gregorian" as the calendar name
# when calling the function, but the System always returns
# the CDate in standard form, where the Gregorian calendar 
# has the acronym "CE" (Common Era).
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
CE 0001-01-01 -> DN      1 -> CE 0001-01-01
CE 1756-01-27 -> DN 641027 -> CE 1756-01-27
CE 2022-01-01 -> DN 738156 -> CE 2022-01-01
CE 2022-09-26 -> DN 738424 -> CE 2022-09-26
=#

# Note that you can use "Julian" as the calendar name
# when calling the function, but the System always returns
# the CDate in standard form, where the Julian calendar 
# has the acronym "JD" (Roman Calendar).
function TestDateJulian()
    SomeDateJulian = [ 
        ("Julian",    1,  1,  3)::CDate,
        ("Julian", 1756,  1, 16)::CDate,
        ("JD",     2021, 12, 19)::CDate,
        ("JD",     2022,  9, 13)::CDate
        ] 

    @testset "DateJulian" begin
    for date in SomeDateJulian
        #dn = DayNumberJulian(date)
        #jdate = DateJulia(dn) 
        dn = DayNumberFromDate(date)
        jdate = DateFromDayNumber("Julian", dn)
        @test jdate == ("JD", date[2], date[3], date[4]) 
        println(CDateStr(date), " -> ", CDateStr(dn), " -> ", CDateStr(jdate))
    end
    end
end

#=
JD 0001-01-03 -> DN      1 -> JD 0001-01-03
JD 1756-01-16 -> DN 641027 -> JD 1756-01-16
JD 2021-12-19 -> DN 738156 -> JD 2021-12-19
JD 2022-09-13 -> DN 738424 -> JD 2022-09-13
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
ID 0001-01-01 -> DN 0000001 -> ID 0001-01-01
ID 1756-05-02 -> DN 0641027 -> ID 1756-05-02
ID 2021-52-06 -> DN 0738156 -> ID 2021-52-06
ID 2022-39-01 -> DN 0738424 -> ID 2022-39-01
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
    println("This Hebrew date is before the Julian epoch.")
    ConvertDate(("Hebrew", 2022,  1,  1), "Gregorian") |> println
    ConvertDate(("Hebrew", 5782, 10, 28), "Georgian")  |> println
    ConvertDate(("Homebrew", 2022, 1, 1), "Gregorian") |> println
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

#PrintEuropeanMonth(1, 1)
#PrintEuropeanMonth(1452, 4)
#PrintEuropeanMonth(1582, 10)
#PrintEuropeanMonth(2022, 1)
#PrintEuropeanMonth(9999, 12)

#println("==")
#println("EC "); PrintDateLine((EC, 1452, 4, 15))
#println("JD "); PrintDateLine((JD, 1452, 4, 15))
#println("CE "); PrintDateLine((CE, 1452, 4, 15))

#function PrintIntervall(date::CDate, len)
#
#    dn = DayNumberFromDate(date)
#    println("Starting ", CDateStr(date), " ", dn)
#
#    for day in 1:len
#
#        jn = FixNumToJulianNumber(dn)
#        println( "| ",
#            CDateStr(DateFromDayNumber(date[1], dn)), " | ",
#            CDateStr((DN, 0, 0, dn)),  " | ",
#            CDateStr((JN, 0, 0, jn)),
#            " |" )
#        dn += 1
#    end
#end

#= 
Starting CE 0001-12-27 
| CE 0001-12-27 | DN     361 | JN 1721785 |
| CE 0001-12-28 | DN     362 | JN 1721786 |
| CE 0001-12-29 | DN     363 | JN 1721787 |
| CE 0001-12-30 | DN     364 | JN 1721788 |
| CE 0001-12-31 | DN     365 | JN 1721789 |
| CE 0002-01-01 | DN     366 | JN 1721790 |

| ID 0001-52-04 | DN     361 | JN 1721785 |
| ID 0001-52-05 | DN     362 | JN 1721786 |
| ID 0001-52-06 | DN     363 | JN 1721787 |
| ID 0001-52-07 | DN     364 | JN 1721788 |
| ID 0002-01-01 | DN     365 | JN 1721789 |
| ID 0002-01-02 | DN     366 | JN 1721790 |

Starting CE 0002-12-27 
| CE 0002-12-27 | DN     726 | JN 1722150 |
| CE 0002-12-28 | DN     727 | JN 1722151 |
| CE 0002-12-29 | DN     728 | JN 1722152 |
| CE 0002-12-30 | DN     729 | JN 1722153 |
| CE 0002-12-31 | DN     730 | JN 1722154 |
| CE 0003-01-01 | DN     731 | JN 1722155 |

| ID 0002-52-05 | DN     726 | JN 1722150 |
| ID 0002-52-06 | DN     727 | JN 1722151 |
| ID 0002-52-07 | DN     728 | JN 1722152 |
| ID 0003-01-01 | DN     729 | JN 1722153 |
| ID 0003-01-02 | DN     730 | JN 1722154 |
| ID 0003-01-03 | DN     731 | JN 1722155 |

PrintIntervall((CE, 1, 12, 27), 6)
PrintIntervall((ID, 1, 52,  4), 6)

PrintIntervall((CE, 2, 12, 27), 6)
PrintIntervall((ID, 2, 52,  5), 6)
=#

function TestIso()

    ISO = [
        ((CE, 1977,01,01 ), (ID, 1976,53,6 )),
        ((CE, 1977,01,02 ), (ID, 1976,53,7 )),
        ((CE, 1977,12,31 ), (ID, 1977,52,6 )),
        ((CE, 1978,01,01 ), (ID, 1977,52,7 )),
        ((CE, 1978,01,02 ), (ID, 1978,01,1 )),
        ((CE, 1978,12,31 ), (ID, 1978,52,7 )),
        ((CE, 1979,01,01 ), (ID, 1979,01,1 )),
        ((CE, 1979,12,30 ), (ID, 1979,52,7 )),
        ((CE, 1979,12,31 ), (ID, 1980,01,1 )),
        ((CE, 1980,01,01 ), (ID, 1980,01,2 )),
        ((CE, 1980,12,28 ), (ID, 1980,52,7 )),
        ((CE, 1980,12,29 ), (ID, 1981,01,1 )),
        ((CE, 1980,12,30 ), (ID, 1981,01,2 )),
        ((CE, 1980,12,31 ), (ID, 1981,01,3 )),
        ((CE, 1981,01,01 ), (ID, 1981,01,4 )),
        ((CE, 1981,12,31 ), (ID, 1981,53,4 )),
        ((CE, 1982,01,01 ), (ID, 1981,53,5 )),
        ((CE, 1982,01,02 ), (ID, 1981,53,6 )),
        ((CE, 1982,01,03 ), (ID, 1981,53,7 ))
    ]

    @testset "ISODates" begin
    for iso in ISO
        a = DayNumberFromDate(iso[1])
        b = DayNumberFromDate(iso[2])
        @test a == b
        println(a, " = ", b)
    end
    end
end

function TestDateTables()

# The case (AH, 0, 0, 0) is not valid and excluded in the test.
TestDates = [
#((DN,0,0,1),     (CE,0,12,30),   (JD,1,1,1),     (EC,1,1,1),    (ID,0,52,6), (AM,3761,10,16),(AH,-639,1,-221))::DateTable,
((DN,0,0,405733),(CE,1111,11,11),(JD,1111,11,4), (EC,1111,11,4),(ID,1111,45,6),(AM,4872,9,2),  (AH, 505,4,29))::DateTable,
((DN,0,0,811256),(CE,2222,2,22), (JD,2222,2,7),  (EC,2222,2,22),(ID,2222,8,5), (AM,5982,12,10),(AH,1649,9,10))::DateTable,
((DN,0,0,641027),(CE,1756,1,27), (JD,1756,1,16), (EC,1756,1,27),(ID,1756,5,2), (AM,5516,11,25),(AH,1169,4,24))::DateTable,
((DN,0,0,738156),(CE,2022,1,1),  (JD,2021,12,19),(EC,2022,1,1), (ID,2021,52,6),(AM,5782,10,28),(AH,1443,5,27))::DateTable,
((DN,0,0,738424),(CE,2022,9,26), (JD,2022,9,13), (EC,2022,9,26),(ID,2022,39,1),(AM,5783,7,1),  (AH,1444,2,29))::DateTable,
((DN,0,0,1146990),(CE, 3141,5,9),(JD,3141,4,17), (EC,3141,5,9), (ID,3141,19,5),(AM,6901,2,9),  (AH,2597,2,10))::DateTable
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
DayNumber    DN 0000001
CommonEra    CE 0001-01-01
Julian       JD 0001-01-03
IsoDate      ID 0001-01-01
Hebrew       AM 3761-10-18
Islamic      AH 0000-00-00

DayNumber    DN 0405733
CommonEra    CE 1111-11-11
Julian       JD 1111-11-04
IsoDate      ID 1111-45-06
Hebrew       AM 4872-09-02
Islamic      AH 0505-04-29

DayNumber    DN 0811256
CommonEra    CE 2222-02-22
Julian       JD 2222-02-07
IsoDate      ID 2222-08-05
Hebrew       AM 5982-12-10
Islamic      AH 1649-09-10

DayNumber    DN 0641027
CommonEra    CE 1756-01-27
Julian       JD 1756-01-16
IsoDate      ID 1756-05-02
Hebrew       AM 5516-11-25
Islamic      AH 1169-04-24

DayNumber    DN 1146990
CommonEra    CE 3141-05-09
Julian       JD 3141-04-17
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

    Dates = [ (22, 1, 1), (756, 1, 27), (949, 11, 29), (990, 10, 20), 
    (2022, 1, 1), (1756, 1, 27), (1949, 11, 29), (1990, 10, 20)]  

    @testset "DayOfYear2" begin
    for date in Dates
        ce = DayOfYear(CE, date)
        jd = DayOfYear(JD, date)
        ec = DayOfYear(EC, date)
        @test ce == jd
        @test ec == jd
        println(CDateStr(EC, date), " ::", lpad(DayOfYear(EC, date),  4, " "))
    end
    end
end

#=
EC-0800-12-25 -> DN-292192
292192 2013616 -386384
2013616 292192 292192

EC-0843-08-10 -> DN-307760
307760 2029184 -370816
2029184 307760 307760

EC-1204-04-12 -> DN-439496
439496 2160920 -239080
2160920 439496 439496

EC-1452-04-15 -> DN-530081
530081 2251505 -148495
2251505 530081 530081

EC-1666-09-02 -> DN-608374
608374 2329798 -70202
2329798 608374 608374

EC-1789-07-14 -> DN-653249
653249 2374673 -25327
2374673 653249 653249

EC-1906-04-28 -> DN-695904
695904 2417328 17328
2417328 695904 695904
=#

function TestJulianDayNumbers()
  
    test = [  # Note that we use EC, not CE dates!
    ((EC,800,12,25)::CDate, 292192, 2013616, -386384),  # Coronation of Carolus Magnus
    ((EC, 843,8,10)::CDate, 307760, 2029184, -370816),  # Treaty of Verdun
    ((EC,1204,4,12)::CDate, 439496, 2160920, -239080),  # Sack of Constantinople
    ((EC,1452,4,15)::CDate, 530081, 2251505, -148495),  # Birth of Leonardo da Vinci
    ((EC,1666,9, 2)::CDate, 608374, 2329798, -70202),   # Great Fire of London
    ((EC,1789,7,14)::CDate, 653249, 2374673, -25327),   # The Storming of the Bastille
    ((EC,1906,4,28)::CDate, 695904, 2417328, 17328)]    # Birth of Kurt Gödel

    @testset "JulianDayNumbers" begin
    for t in test
        println()
        rdn  = DayNumberFromDate(t[1], true)
        jdn  = ConvertOrdinalDate(rdn, DN, JN)
        @test jdn  == t[3]
        println(rdn, " ", jdn, " ")
        rdn  = ConvertOrdinalDate(jdn, JN, DN)
        @test rdn  == t[2]
        println(jdn, " ", rdn)
    end

    en = ConvertOrdinalDate(2440422, "JN", "EN") 
    jn = ConvertOrdinalDate(719000,  "EN", "JN") 
    @test en  == 719000
    @test jn  == 2440422
    end
end

function TestSaveCalendars()
    SaveEuropeanMonth(1, 1)
    SaveEuropeanMonth(1111, 11)
    SaveEuropeanMonth(1582, 10)
    SaveEuropeanMonth(9999, 12)
    PrintIsoWeek(1582, 41)
    PrintIsoWeek(2525, 25)
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
    println("\nMozart would be ", DayOfLife((EC, 1756, 1, 27)), " days old today.")
    println("\nToday on all calendars:\n")
    now = Dates.yearmonthday(Dates.now())
    date = ("EC", now[1], now[2], now[3])
    CalendarDates(date, true)
    doy = DayOfYear(date)
    println("\nThis is the $doy-th day of a EC-year.")
end

function TestAll()
    TestDateGregorian(); println() 
    TestDateJulian();    println()
    TestDateHebrew();    println()
    TestDateIslamic();   println()
    TestDateIso();       println()
    TestIso();           println()
    TestConversions();   println()
    TestDateTables();    println()
    TestDuration();      println()
    TestJulianDayNumbers(); println()
    TestDayOfYear();     println()
    ShowDayOfYear();     println()
    TestToday()
    # TestSaveCalendars()
end

TestAll()

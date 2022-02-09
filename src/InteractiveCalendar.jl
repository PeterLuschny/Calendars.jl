# This is part of Calendars.jl. See the copyright note there.
# =================== Interactive calendar ==================

# Interactively compute calendar dates in the REPL. 


using Dates

"""
Interactively query the dates for all calendars in the REPL.

```julia
julia> IDate()
```
"""
function IDate() 

    msg = "You should have entered a numeric value, bye ..."
    noi = "This was not a valid input! Try again ..."
    nod = "This was not a valid date! Try again ..."

    now = Dates.yearmonthday(Dates.now())
    cd = CalendarDates("EC", now, true)
    dy = DayOfYear("EC", now)
    wd = WeekDay(cd)
    println("\nIt's ", wd, ", the ", dy, "-th day of the EC-year.")
    println()

    while true
    @label start
        println("Enter a calendar specifier:")
        println("    EC => European")
        println("    CE => Common  ")
        println("    JD => Julian  ")
        println("    AM => Hebrew  ")
        println("    AH => Islamic ")
        println("    ID => IsoDate ")
        println("or choose a historical event:")
        println("    TV => Treaty of Verdun            ")
        println("    SC => Sack of Constantinople      ")
        println("    LV => Birth of Leonardo da Vinci  ")
        println("    SR => Start of the Reformation    ")
        println("    FL => Great Fire of London        ")
        println("    SB => The Storming of the Bastille")
        println("or Ctrl+C to quit.")
        println()

        ct = try
            readline()
        catch e
            println("... bye")
            return
        end

        if ct in ["EC", "CE", "JD", "AM", "AH", "ID"]
            cs = ct

            print("Enter year      (>0): ") 
            y = try
                parse(Int, readline())
            catch e
                println(msg)
                return
            end
            if cs == "ID"
                print("Enter week   (1..53): ") 
            else
                print("Enter month  (1..12): ") 
            end
            m = try
                parse(Int, readline())
            catch e
                println(msg)
                return
            end
            if cs == "ID"
                print("Enter day     (1..7): ") 
            else 
                print("Enter day    (1..31): ") 
            end
            d = try
                parse(Int, readline())
            catch e
                println(msg)
                return
            end
            println()
            date = (cs, y, m, d)

        elseif ct in ["TV", "SC", "LV", "SR", "FL", "SB"]
            ct == "TV" && (date = (EC, 843,8,10))  # Treaty of Verdun
            ct == "SC" && (date = (EC,1204,4,12))  # Sack of Constantinople
            ct == "LV" && (date = (EC,1452,4,15))  # Birth of Leonardo da Vinci
            ct == "SR" && (date = (EC,1517,10,31)) # Start of the Reformation
            ct == "FL" && (date = (EC,1666,9,2))   # Great Fire of London
            ct == "SB" && (date = (EC,1789,7,14))  # The Storming of the Bastille
            cs = "EC"
        else
            println(noi)
            @goto start
        end
        if ! isValidDate(date) 
           println(nod)
        else
            wd = " "
            try
                cd = CalendarDates(date, true)
                wd = WeekDay(cd)
            catch e
                println(e)
                return
            end
            println("\n", wd, "the ", 
                   DayOfYear(date), "-th day of the ", 
                   cs, "-year.")
        end
        println()
    end
end

# This is part of Calendars.jl. See the copyright note there.
# ======================= REPL calendar =====================

# This is an undocumented gadget for the Julia REPL.
# Might be removed in later versions without notice.

using Dates

# Interactively query the dates for all calendars in the REPL.
function IDate() 

    msg = "You should have entered a numeric value, bye ..."
    nov = " is not a valid date! Try again ..."
    csv = "The calendar specifier was not valid, using CE."

    now = Dates.yearmonthday(Dates.now())
    CalendarDates("CE", now, true)
    println()

    while true
        println("Enter a calendar specifier:")
        println("    EC => European")
        println("    CE => Common  ")
        println("    JD => Julian  ")
        println("    AM => Hebrew  ")
        println("    AH => Islamic ")
        println("    ID => IsoDate ")
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
        else
            cs = "CE"
            println(csv)
        end

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
        if ! isValidDate(date) 
            println(CDateStr(date), nov)
        else
            try
                CalendarDates(date, true)
            catch e
                println(e)
                return
            end
            println("The ", DayOfYear(date), "-th day of the $cs-year.")
        end
        println()
    end
end

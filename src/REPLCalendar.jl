# This is part of Calendars.jl. See the copyright note there.
# ======================= REPL calendar =====================

# This is an undocumented gadget for the Julia REPL.
# Might be removed in later versions without notice.

# Interactively query the dates for all calendars in the REPL.
function adate() 

    msg = "You should have entered a numeric value, bye ..."
    nov = " is not a valid date! Try again ..."

    while true
        print("Enter year      (>0): ") 
        y = try
            parse(Int, readline())
        catch e
            println(msg)
            return
        end
        print("Enter month  (1..12): ") 
        m = try
            parse(Int, readline())
        catch e
            println(msg)
            return
        end
        print("Enter day    (1..31): ") 
        d = try
            parse(Int, readline())
        catch e
            println(msg)
            return
        end
        println()
        if ! isValidDate(y, m, d, "CE") 
            println(DateStr(y, m, d) * nov)
        else
            try
                CalendarDates(y, m, d, "CE", true)
            catch e
                println(e)
                return
            end
        end
        println()
    end
end

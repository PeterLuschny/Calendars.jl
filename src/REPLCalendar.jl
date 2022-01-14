
# This is an undocumented gadget for the Julia REPL.
# First "using Calendars" and then "adate()".

# Interactively query the dates for all calendars in the REPL.
function adate() 

    msg = "You should have entered a numeric value, bye ..."

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
        print("Enter day    (1..30): ") 
        d = try
            parse(Int, readline())
        catch e
            println(msg)
            return
        end
        println()
        if !(y in 1:9999) || !(m in 1:12) || !(d in 1:30)
            println("$y-$m-$d is not a valid date! Try again ...")
        else
            try
                Calendars.CalendarDates(y, m, d, "CE", true)
            catch e
                println(e)
                return
            end
        end
        println()
    end
end

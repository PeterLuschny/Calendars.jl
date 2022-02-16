# This is part of Calendars.jl. See the copyright note there.
# ======================== DayNumbers =======================

# The fix day number of CE 1582-10-15.
const GregorysBreak = DPart(577736)
const JDN_DN  = DPart(1721425)
const DN_MJDN = DPart(678576)

# Days considered here start at midnight 00:00.

# Convert a fix day number to a Julian day number.
# If mod = true return the modified Julian day number.
# (which has epoch CE 1858-11-17, 00:00 UT).
function FixNumToJulianNum(rd::DPart, mod=false) 
    if mod 
        return rd - DN_MJDN
    else 
        return rd + JDN_DN
    end
end

# Convert a Julian day number to a fix day number.
# If mod = true assume a modified Julian day number.
function JulianNumToFixNum(jdn::DPart, mod=false) 
    if mod 
        return jdn + DN_MJDN
    else
        return jdn - JDN_DN
    end
end

# Convert a fix day number to an European day number.
FixNumToEuroNum(fn::DPart) = fn + 2

# Convert an European day number to a fix day number.
EuroNumToFixNum(en::DPart) = en - 2

"""
Convert a Julian day number to an European day number.
```julia
julia> JulianNumToEuroNum(2440422)
```
The European day number of the first crewed moon landing (Apollo 11) is EN#719000.
"""
JulianNumToEuroNum(jn::DPart) = jn - JDN_DN + 2


"""
Convert an European day number to an Julian day number.
```julia
julia> EuroNumToJulianNum(719000)
```
The Julian day number of the first crewed moon landing (Apollo 11) is JN#2440422.
"""
EuroNumToJulianNum(en::DPart) = en + JDN_DN - 2

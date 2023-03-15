# Salary requirements as of 2022-06-17 according to Gröna Riksavtalet after 2021-04-1 (valid 2020-11-01 -- 2023-03-31)
# Base hourly salary: 99.07 sek / hour
# Acceptable percentual vacation compensation: 12% (of monthly salary (effectively daily salary?))
# Uncomfortable working hours: weekdays 20:00 -- 06:00 (next day), Saturdays and holidays 16:00 -- 06:00 (next day), Sundays and "red days" 06:00 -- 06:00 (next day)
# Uncomfortable working hours compensation: 24.09 sek / hour
# Latest allowed working hour: 23:00
# Breaks: 30 minutes at 5 hours (not paid), 1 hour at 8 hours (not paid)

baseHourly              = 99.07 #sek
vacationCompensation    = 0 #%
uncomfHourly            = 24.09 #sek
uncomfLimWeekday        = 20 #hours since midnight
uncomfLimSat            = 16 #hours since midnight
breakTime               = 0.5 #hours

specialDay = "ja"
redDay = "ja"
uncomfTime = 0
uncomfPay = 0
breakMessage = ""
uncomfDay = ""

system("cls")

puts "Vilken veckodag jobbade du (svara på engelska)?"
day = gets.chomp.downcase

if day != "saturday"
    puts "Var dagen under jul, midsommar eller nyårsafton?"
    specialDay = gets.chomp.downcase

    if specialDay == "ja"
        uncomfDay == "under jul, midsommar eller nyårsafton"
        puts "uncomfDay == 'under jul, midsommar eller nyårsafton'"
    end
elsif day == "saturday"
    uncomfDay == "på lördagar"
    puts 'uncomfDay == "på lördagar"'
end

if day != "sunday"
    puts "Var dagen en röd dag?"
    redDay = gets.chomp.downcase

    if redDay == "ja"
        uncomfDay == "på röda dagar"
        puts 'uncomfDay == "på röda dagar"'
    end
elsif day == "sunday"
    uncomfDay == "på söndagar"
    puts 'uncomfDay == "på söndagar"'
end

puts "När började du jobba? (hh:mm)"
startTime = gets.chomp
puts "När slutade du jobba? (hh:mm)"
endTime = gets.chomp

formatedStartTime = startTime.split(":")
totalStartMinutes = (formatedStartTime[0].to_i * 60) + formatedStartTime[1].to_i
formatedEndTime = endTime.split(":")
totalEndMinutes = (formatedEndTime[0].to_i * 60) + formatedEndTime[1].to_i
totalWorkingMinutes = totalEndMinutes - totalStartMinutes
totalWorkingHours = totalWorkingMinutes / 60.0

if totalWorkingHours >= 5 and totalWorkingHours < 8
    puts "Du jobbade i #{totalWorkingHours} timmar. Tog du rasten du har rätt till (#{(breakTime * 60).round} minuter)?"
    breakYN = gets.chomp.downcase
    if breakYN == "ja"
        totalWorkingHours -= breakTime
        breakMessage = "(obetald rast på #{(breakTime * 60).round} minuter) "
    end
elsif totalWorkingHours >= 8
    puts "Du jobbade i #{totalWorkingHours} timmar. Tog du rasten du har rätt till (#{(breakTime * 2).round} timme)?"
    breakYN = gets.chomp.downcase
    if breakYN == "ja"
        totalWorkingHours -= (breakTime)
        breakMessage = "(obetald rast på #{(breakTime * 2).round} timme) "
    end
end

p day
p specialDay
p redDay

p uncomfDay

if day == "saturday" or specialDay == "ja"
    puts "day == 'saturday' or specialDay == 'ja'"
    if totalEndMinutes > uncomfLimSat * 60
        uncomfTime = totalEndMinutes - (uncomfLimSat * 60)
        uncomfPay = uncomfTime * (uncomfHourly / 60)
    end
    currentUncomfLim = (uncomfLimSat.to_s << ":00")
    uncomfMessage = "börjar #{currentUncomfLim} #{uncomfDay}"
    puts 'uncomfMessage = "börjar #{currentUncomfLim} #{uncomfDay}"'
elsif day == "sunday" or redDay == "ja"
    uncomfPay = totalWorkingHours * uncomfHourly
    currentUncomfLim = startTime
    uncomfMessage = "gäller hela dagen #{uncomfDay}"
    puts 'uncomfMessage = "gäller hela dagen #{uncomfDay}"'
else
    if totalEndMinutes > uncomfLimWeekday * 60
        uncomfTime = totalEndMinutes - (uncomfLimWeekday * 60)
        uncomfPay = uncomfTime * (uncomfHourly / 60)
    end
    currentUncomfLim = (uncomfLimWeekday.to_s << ":00")
    uncomfMessage = "börjar #{currentUncomfLim} på vardagar"
    puts 'uncomfMessage = "börjar #{currentUncomfLim} på vardagar"'
end

totalDailySalary = (((totalWorkingHours * baseHourly) + uncomfPay) * ((vacationCompensation / 100.0) + 1))
vacationDiff = totalDailySalary - ((totalWorkingHours * baseHourly) + uncomfPay)

# system("cls")

puts "Du tjänade totalt #{totalDailySalary.round(2)} kr."
puts "(+ #{(totalWorkingHours * baseHourly).round(2)} kr) Du jobbade totalt i #{totalWorkingHours} timmar #{breakMessage}med en timlön på #{baseHourly} kr/timme."

if uncomfTime > 0
    puts "(+ #{uncomfPay.round(2)} kr) Du jobbade #{uncomfTime / 60.0} timmar under Obekväm Arbetstid (#{currentUncomfLim} - #{endTime}, Obekväm Arbetstid #{uncomfMessage}) med en ersättning på #{uncomfHourly} kr/timme."
end

puts "(+ #{vacationDiff.round(2)} kr) Du jobbade under sommaren och fick därför ytterligare #{vacationCompensation}% av din lön i semesterlön."

if totalWorkingHours > 8
    puts "Du jobbade längre än 8 timmar. Du får inte jobba längre än 40 timmar per vecka eller med ett dagsgenomsnitt på över 8 timmar."
end

gets
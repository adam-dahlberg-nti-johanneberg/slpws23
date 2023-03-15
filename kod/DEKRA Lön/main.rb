#Måndag - Fredag 18-24: +29%
#Måndag - Fredag 00-07: +29%
#Lördag - Söndag: +58%
#Timlön: 120.00kr

require "date"
require "securerandom"

def main()

    overtimeLimit = 18
    hourlyPay = 120
    overtimeMultiplier = 0.29
    redDayMultiplier = 0.58
    overtimePay = 0
    redDayPay = 0
    totalOvertime = 0
    totalHours = 0
    totalMoney = 0

    file = File.open("Lön (maskininläsning).txt")
    fileData = file.readlines
    fileLength = fileData.length - 1
    file.close

    i = 1

    while i <= fileLength
        totalHours += fileData[i].split(",")[3].to_f
        totalMoney += fileData[i].split(",")[4].to_f

        i += 1
    end

    file = File.open("Lön.txt")
    fileData = file.readlines
    file.close

    puts ""
    puts "Välkommen!"
    puts ""
    puts "Här är din nuvarande lista med datum, tider, timmar och lön:"

    puts ""
    puts fileData
    puts ""

    puts "Antal arbetspass loggade: #{fileLength}" 
    puts "Antal timmar loggade: #{totalHours.round(2)}h"
    puts "Total lön loggad: #{totalMoney.round(2)}kr"

    puts ""
    
    puts "Genomsnittlig timlön: #{(totalMoney/totalHours).round(2)}kr/h"
    puts "Genomsnittlig tid per pass: #{(totalHours/fileLength).round(2)}h/pass"

    puts ""
    puts "Vänligen ange start- och sluttid (hhmmhhmm):"

    startFinish = gets.chomp

    puts "Vad är dagens datum (ååmmdd)?"

    inputDate = gets.chomp

    year = ("20" + inputDate[0] + inputDate[1]).to_i
    month = (inputDate[2] + inputDate[3]).to_i
    day = (inputDate[4] + inputDate[5]).to_i

    date = Date.new(year,month,day)

    if date.saturday?
        redDay = true
        workDay = "Lördag"
        explanatoryPay = "varav OB (helg/röd dag):"
    elsif date.sunday?
        redDay = true
        workDay = "Söndag"
        explanatoryPay = "varav OB (helg/röd dag):"
    else
        redDay = false
        workDay = "Vardag"
        explanatoryPay = "varav OB (kväll):"
    end

    if redDay == true || redDay == false
        puts ""
        puts "Tack! Beräknar lön..."
    end

    startHours = (startFinish[0] + startFinish[1]).to_i
    startMinutes = (startFinish[2] + startFinish[3]).to_i

    finishHours = (startFinish[4] + startFinish[5]).to_i
    finishMinutes = (startFinish[6] + startFinish[7]).to_i

    totalTime = (finishHours + (finishMinutes.to_f / 60)) - (startHours + (startMinutes.to_f / 60))

    if finishHours >= overtimeLimit && redDay == false
        overtimeHours = finishHours - overtimeLimit
        overtimeMinutes = finishMinutes - 0

        totalOvertime = overtimeHours + (overtimeMinutes.to_f / 60)
        overtimePay = (totalOvertime * hourlyPay * overtimeMultiplier).round(2)

    elsif redDay == true
        redDayPay = (totalTime * hourlyPay * redDayMultiplier).round(2)
    else
        explanatoryPay = "ingen OB:"
    end

    totalPay = ((totalTime * hourlyPay) + overtimePay + redDayPay).round(2)

    totalExtraPay = overtimePay + redDayPay

    puts "Total lön för passet: #{totalPay}kr, varav OB (kväll): #{overtimePay}kr; varav OB (helg/röd dag): #{redDayPay}kr."
    puts ""
    puts "Ska informationen skrivas till lönedokumentet (j/n)?"

    printPay = gets.chomp

    if printPay == "j"
        File.write("Lön.txt", "#{date}, #{workDay}, #{totalPay}kr lön, #{explanatoryPay} #{totalExtraPay}kr. \n", mode: "a")
        File.write("Lön (maskininläsning).txt", "#{SecureRandom.uuid},#{date},#{workDay},#{totalTime},#{totalPay},#{redDay},#{totalOvertime},#{totalExtraPay},#{startHours},#{startMinutes},#{finishHours},#{finishMinutes},#{fileLength},#{overtimeLimit},#{hourlyPay},#{overtimeMultiplier},#{overtimeLimit},#{redDayMultiplier}\n", mode: "a")
        puts ""
        puts "Data sparad!"
    else
        puts "Ingen data sparad."
    end

    puts "Tryck ENTER för att köra programmet igen."
    gets
    main
end

main
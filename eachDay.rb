####
## eachDay.rb -- slr nov 2013
## this creates the JSON files 
## to be consumed by highstock/compare 
## with the REPORTED temps for each day
####

require 'sqlite3'
require 'json'
require 'pp'
require 'fileutils'

date = Time.now.strftime("%Y-%m-%d")

# open db connection
db = SQLite3::Database.new("..\\sqlite3\\weather.db")

site = ['forecast','noaa']
range = ['min', 'max']
daysOut = ['reported', 'tomorrow', '2 days out', '3 days out', '4 days out', '5 days out', '6 days out']

## set Data Directory
dataDir = "C:\\Sites\\ruby\\data\\"
Dir.foreach(dataDir) { |of| fn = File.join(dataDir, of); FileUtils.rm_f File.join(dataDir, of) if of != '.' && of != '..'}

## create one array per site/range/days out combination
site.each do |s|
	range.each do |r|
		table_name=r+'_temp_'+s
		daysOut.each_index do |i|
			t = s + '.' + r + '.' + daysOut[i].to_s()
			## query database
			query = db.execute("select dt, dt#{i} from #{table_name}");
			## write to faux json file
			outFile=dataDir+t+".json"
			## create new files
			File.open(outFile, "a") do |f|
				f.write '['
				

			## each row from the db has one human readable date stamp
			## YYYY-MM-DD, converted to unix time (to_time.to_i)...
			## since we are computing days in advance, we add the number of
			## seconds in a day (86400)*(number of days) to the date
			## finally, multiply by 1000 to make it JS friendly time
			query.each_with_index do |day, index|
				if (day[0]) != date
					day[0]=((DateTime.parse(day[0]).to_time.to_i)+(86400*i))*1000
					n = '[' + day[0].to_s() + ',' + day[1].to_s() + '],'
				#	puts "#{n}"
					f.puts "#{n}"

				elsif (day[0]) == date
					day[0]=((DateTime.parse(day[0]).to_time.to_i)+(86400*i))*1000
					n = '[' + day[0].to_s() + ',' + day[1].to_s() + ']'
				#	puts "#{n}"
					f.puts "#{n}"
				end
			end
				f.write ']'
			end
		end
	end
end

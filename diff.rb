####
## diff.rb slr nov 2013
## creates the JSON files for PREDICTED temps
## for consumption by hightstock/compare graphs
## 

require 'sqlite3'
require 'json'
require 'pp'
require 'fileutils'

date = Time.now.strftime("%Y-%m-%d")
pp date
#uts = Time.strftime('%s', date)

# open db connection
db = SQLite3::Database.new("C:\\Sites\\sqlite3\\weather.db")

site = ['forecast','noaa']
range = ['min', 'max']
daysOut = ['reported','tomorrow', '2 days out', '3 days out', '4 days out', '5 days out', '6 days out']

## set Data Directory and remove any files
dataDir = "C:\\Sites\\ruby\\diff\\"
Dir.foreach(dataDir) { |of| fn = File.join(dataDir, of); FileUtils.rm_f File.join(dataDir, of) if of != '.' && of != '..'}

## create one array per site/range/days out combination
site.each do |s|
	range.each do |r|
		table_name=r+'_temp_'+s
		daysOut.each_index do |i|
			t = s + '.' + r + '.' + daysOut[i].to_s()
			## query database
			## pull unix date stamp (dt), and then subtract forecasted temp (dt[1-6]) from reported temp(dt0)
			query = db.execute("select b.dt, strftime('%s', b.dt), a.dt#{i}, b.dt0, (a.dt#{i}-b.dt0) from #{table_name} a inner join #{table_name} b where strftime(date(a.dt)) = strftime(date(b.dt, '-#{i} day'));")

			## write to json file
			outFile=dataDir+t+"_diff.json"

			## create new files
			File.open(outFile, "a") do |f|
				f.write '['

			## each row from the db has one human readable date stamp
			## YYYY-MM-DD, converted to unix time (to_time.to_i)...
			## since we are computing days in advance, we add the number of
			## seconds in a day (86400)*(number of days) to the date
			## finally, multiply by 1000 to make it JS friendly time
			#query.each_with_index do |day, index|
			
				query.each do |day|
			
				## convert to JS friendly time	
				day[1]=(day[1].to_i)*1000
					## date is a varialbe here, holding a YYYY-MM-DD formatted string -- will get the Unix time to match midnight... 
					if (day[0]) != date
					#	day[0]=((DateTime.parse(day[0]).to_time.to_i)+(86400*i))*1000
					
						n = '[' + day[1].to_s() + ',' + day[4].to_s() + '],'
					#	puts "#{n}"
						f.puts "#{n}"

					elsif (day[0]) == date

						n = '[' + day[1].to_s() + ',' + day[4].to_s() + ']'
					#	puts "#{n}"
						f.puts "#{n}"

				end

			end
	#		puts "select b.dt, strftime('%s', b.dt), a.dt#{i}, b.dt0, (a.dt#{i}-b.dt0) from #{table_name} a inner join #{table_name} b where strftime(date(a.dt)) = strftime(date(b.dt, '-#{i} day'));"	
				f.write ']'
			end
		end
	end
end

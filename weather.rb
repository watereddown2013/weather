require 'sqlite3'
require 'rest-client'
require 'json'
require 'crack'
require 'pp'
require 'nokogiri'

date = Time.now.strftime("%Y-%m-%d")

site = ['forecast','noaa']
range = ['min', 'max']


	## open db connection to store the hi and lo temps.
	def db_trans(table_name, t)	
 		puts '###############################################'
		puts table_name + ":::" + t.to_s
 		puts '###############################################'


				begin
				db = SQLite3::Database.open "C:\\Sites\\sqlite3\\weatherIN.db"
				puts db.get_first_value 'SELECT SQLITE_VERSION()'

		
				## create database table if it doesn't exist
				db.execute "CREATE TABLE IF NOT EXISTS #{table_name}(Id INTEGER PRIMARY KEY AUTOINCREMENT, dt date default current_date, dt0 int, dt1 int, dt2 int, dt3 int, dt4 int, dt5 int, dt6 int)"

				# insert temps into DB
				insert = "INSERT INTO #{table_name} values (NULL, date(), #{t[0]}, #{t[1]}, #{t[2]}, #{t[3]}, #{t[4]}, #{t[5]}, #{t[6]})" 
				puts insert
				db.execute(insert)

				# verify your lo_temp_f data got stored
				puts ""
				puts "values from the #{table_name} table: "
				pp db.execute "select * from #{table_name}"

			end
	end

## create one array per site/range combination
site.each do |s|
	range.each do |r|
				
		puts s +' :: ' + r
		t = s + '.' + r
		table_name=r+'_temp_'+s
		puts "table_name is: " + table_name
		

		#########################################################	
		## first get data from forecast.io and populate tables ##	
		#########################################################
	
		## fetch data from forecast.io and store in array week.
		if s == 'forecast'

			url_f = 'https://api.forecast.io/forecast/50b4441c0427316a64137eec10dabd77/45.5381938,-122.6000136?daily'
			jsonData =Crack::JSON.parse(RestClient.get(url_f))
	
			@daily = jsonData["daily"]["data"]
			temp = "temperature"+(r.capitalize)
				## initialize array to hold each day of the week
				t = []		
				## iterate over data to insert	
				@daily.each do |dt|
					tmp = dt[temp].round
					# PUSH each element into a single array
					t = t.push(tmp)
				end	

		db_trans(table_name, t)

	puts ''
	puts '####################################'
	puts '####################################'
	puts ''
		
		
		#########################################################	
		#### next get data from noaa.gov and populate tables ####	
		#########################################################

		elsif s == 'noaa'
			url_n = 'http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?zipCodeList=97213&maxt=maxt&mint=mint'
			xmlDoc = Nokogiri::XML(RestClient.get(url_n))	
				
			temp = '//temperature[name="Daily ' + (r.capitalize) + 'imum Temperature"]/value/text()'
			## get temps	
			daily = xmlDoc.xpath(temp)

			## create array with only text from XML
			t = daily.map(&:text)
			
			db_trans(table_name, t)

		end

	end



end


require 'Soundcloud'
require 'rest-client'
require 'json'
require 'pry'
require 'chronic_duration'

class CommentFinder
	attr accessor :track_url, :comments_temp[], :comments[], :user_time

	def initalize
		@client = Soundcloud.new(:client_id => '558fadac3dfac9262ef377f5844d0c0b')
	end


	def start 
		puts "Welcome to the Soundcloud comment sorter \n\n"

		puts "Enter a track URL to to search within the comments:\n"
		@track_url = gets.chomp 

		@track = client.get('/resolve', :url => track_url)

		pull_comments

	end 

	def pull_comments

		@comments_temp = client.get("/tracks/#{track.id}/comments", :limit => 200, :offset => 0)

	end

	def comments_to_array_convert  (x)

		while comments_temp.any? == true 

			offset = 0 

			comments_temp.each do |comment| 

				comments << {:time => comment.timestamp.to_i/1000, :comment => comment.body}
			end

			comments_temp = client.get("/tracks/#{track.id}/comments", :limit => 200, :offset => offset)

			offset += 200
		end
	end	

	def clean_comments

		comments.compact

		comments.each{|comment|comment[:time] ||= 0}
	end

	def sort_comments
		comments.sort_by!{|comment|comment[:time]}

	end


	def check_user_time

		@user_time = nil 

		while @user_time != 'exit'
		puts "Enter a time to jump to within the track or type exit to end the program:\n"

		@user_time = gets.chomp
		if @user_time == 'exit'
			break
		else

		#convert to a real time
		@user_time = ChronicDuration.parse(user_time)

		plus_five = user_time + 300

		comments.each do |comment|
			if comment[:time].between?(user_time, plus_five)

				chrono = ChronicDuration.output(comment[:time], :format => :chrono)

				puts "Time: #{chrono} \n Comment: #{comment[:comment]} \n\n"
				
			else
			end
		end
	end
end

puts "Welcome to the Soundcloud comment sorter \n\n"

puts "Enter a track URL to to search within the comments:\n"
		@track_url = gets.chomp 


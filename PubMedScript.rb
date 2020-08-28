#!/usr/bin/ruby
require 'HTTParty'
require 'pry'

size = 100
headers = ["Title","Author", "Affiliation","Email"]
date = DateTime.now.strftime("%Y%m%dT%H%M")
verbose = true

puts "What is page number to start the data extraction?"
start_pag = gets.chomp.to_i
puts "What is page number to finish the data extraction?"
end_pag = gets.chomp.to_i

csv_name = "./results/PubMedFinalList-Page#{start_pag}toPage#{end_pag}-#{date}.csv"

puts "Starting PubMed extration."
puts "Creating CSV file..."

CSV.open(csv_name, "a+") do |csv|
	puts "CSV file named #{csv_name} created..."
	csv << headers

	while start_pag <= end_pag do
		puts "Initiating extraction of page #{start_pag}..."

		response = HTTParty.get("https://pubmed.ncbi.nlm.nih.gov/?term=RNA&filter=datesearch.y_5&format=abstract&size=#{size}&page=#{start_pag}").body
		response = response.gsub("\"","\'").gsub(/\n|\t/,"")

		response.scan(/class='full-view'(.*?)class='short-view'/).each do |article|
			article = article[0].to_s
			article = article.gsub(/\s(\S+@\S+).?<\/li>/,'<email>\1</email></li>').gsub(/[Ee]lectronic\s+[Aa]ddress:?/,'').gsub(/<\/?i>/,"")

			title = article.scan(/class='heading-title'>[^>]*>\s+(.*?)\s+<\/a>[^<]*<\/h1>/)
			authors = article.scan(/<[^>]*action='author_link'[^>]*>([^<]*)<\/a>.*?class='affiliation-link'[^>]*>[^\d]*(\d+)[^<]*<\/a>/)
			affiliation = article.scan(/data-affiliation-id=[^>]*>[^<]*<[^>]*>[^\d]*(\d+)[^<]*<\/sup>([^<]*?)(?:<email>(.*?)<\/email>)?<\/li>/)

			authors.each do |author|
				aff_index = affiliation.find_index{ |x| x[0] == author[1] }
				puts "#{title[0][0]}, #{author[0]}, #{affiliation[aff_index][1]}, #{affiliation[aff_index][2]}" if verbose
				csv << [title[0][0], author[0], affiliation[aff_index][1], affiliation[aff_index][2]]
			end
		end
		puts "Page #{start_pag} extraction finished successfully..."
		puts "---------------------------------------------------------------------"
		start_pag+=1
	end
end

puts "PubMedFinalList.csv Updated! \n \n"
puts "Ending Script \n \n"

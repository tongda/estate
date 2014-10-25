require 'nokogiri'

# File.open('output.csv','w') do |out|
#   File.open('test.html', 'r:UTF-8') do |file|
#     file.each_line do |line|
#       cities = line.scan(/>城市：([\p{Han}\(\)]+)</u)
#       # cities = line.scan(/>(\d+\.?\d*|-)</u)
#       out.puts cities.join(",")
#     end
#   end
# end

File.open('output.csv','w') do |out|
  File.open('page.html', 'r:utf-8') do |page|
    doc = Nokogiri::HTML(page)
    doc.css("#MyTable_tableLayout tbody > tr").each do |row|
      items = []
      row.css("td").each do |item|
        items.push item
      end
      out.puts(items.join(','))
    end
  end
end

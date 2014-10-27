require 'nokogiri'
require 'spreadsheet'

# File.open('output.csv','w') do |out|
#   File.open('test.html', 'r:UTF-8') do |file|
#     file.each_line do |line|
#       cities = line.scan(/>城市：([\p{Han}\(\)]+)</u)
#       # cities = line.scan(/>(\d+\.?\d*|-)</u)
#       out.puts cities.join(",")
#     end
#   end
# end

Spreadsheet.client_encoding = 'UTF-8'

book = Spreadsheet::Workbook.new
Dir.glob('pages/*.html').each do |fn|
  sheet = book.create_worksheet :name => fn[7..-6]
  File.open(fn, 'r:utf-8') do |page|
    puts "processing #{fn}"
    doc = Nokogiri::HTML(page, nil, 'utf-8')

    doc.css("#MyTable_tableLayout thead tr th")[0..21].each do |th|
      sheet.row(0).push th.text
    end
    doc.css("#MyTable_tableLayout tbody > tr").each do |row|
      idx = sheet.last_row_index + 1
      row.css("td").each do |item|
        sheet.row(idx).push item.text
      end
    end
  end
end
book.write('cities.xls')

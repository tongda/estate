require 'watir'
require 'redis'
require 'spreadsheet'

browser = Watir::Browser.new

browser.goto "http://newhouse.cd.fang.com/house/s/"
book = Spreadsheet::Workbook.new
sheet  = book.create_worksheet :name => 'cd'

def parse_links(browser)
  redis = Redis.new
  browser.div(:class => 'sslist').when_present do
    browser.uls(:class => 'sslainfor').each do |info|
      redis.sadd(:fang_links_cd, info.link(:class => 'snblue').href)
      puts info.link(:class => 'snblue').text
    end
  end

  if browser.li(:class => 'pagearrowright').present?
    browser.li(:class => 'pagearrowright').link.click
    parse_links(browser)
  end
end

def parse_page(browser, link, sheet)
  browser.goto link
  browser.div(:class => 'firstright').when_present do |firstright|
    sheet.row(sheet.last_row_index + 1).push(
      browser.div(:class => 'sftitle').h1.text,
      firstright.div(:class => 'information_li').div(:class => 'inf_left').text,
      firstright.divs(:class => 'information_li')[1].text,
      firstright.divs(:class => 'information_li')[4].text,
      )
    puts "#{browser.div(:class => 'sftitle').h1.text} - #{firstright.div(:class => 'information_li').div(:class => 'inf_left').text}"
  end
end

parse_links(browser)

redis = Redis.new
begin
  redis.smembers(:fang_links_cd).each do |link|
    parse_page(browser, link, sheet)
  end
rescue
  puts "something went wrong"
end
book.write "temp.xls"

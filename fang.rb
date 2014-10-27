require 'watir'

browser = Watir::Browser.new

browser.goto "http://newhouse.cd.fang.com/house/s/"

while true
  browser.li(:class => 'pagearrowright').link.when_present.click
end

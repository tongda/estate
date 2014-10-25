require 'watir'

def login(browser)
  browser.goto 'http://fdc.soufun.com/creisdata'
  browser.text_field(:id => 'user_creisdata').set('sy-songjian')
  browser.text_field(:id => 'password_creisdata').set('123456')
  browser.text_field(:id => 'tb_U_creisdata').set('7757')
  browser.select_list(:id => 'select').select('宏观版')
  browser.image(:id => 'btn_creisdata').click
end

def cities(browser)
  browser.select_list(:id => 'cityname').options
end

browser = Watir::Browser.new

login(browser)

browser.li(:id => 'Header1_deal').when_present.link.click
browser.div(:id => 'userguidance').when_present.image.click
browser.label(:id => 'beginTime').when_present.click
browser.link(:id => '2000-1').when_present.click

indexes = browser.select_list(:id => 'allLowIndex').options
indexes.each do |index|
  if index.text.start_with? '商品'
    index.select
  end
end
browser.div(:class => 'linadd').image.click
cities(browser).each do |city|
  puts city.text

  if File.exist?("#{city.text}.html")
    next
  end

  city.select
  browser.link(:id => 'AddCity').click

  browser.div(:id => 'titleName').div(:class => 'left3').image.click
  browser.td(:text => '正在为您加载数据...').wait_while_present

  File.open("#{city.text}.html", 'w:UTF-8') do |file|
    file.write(browser.html)
  end

  browser.div(:id => 'selectcity').links[0].click
  city.clear
end

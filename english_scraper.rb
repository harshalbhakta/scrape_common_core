require 'nokogiri'
require 'open-uri'
require 'spreadsheet'

urls = [
  "http://www.corestandards.org/ELA-Literacy/RL/1/",
  "http://www.corestandards.org/ELA-Literacy/RL/2/",
  "http://www.corestandards.org/ELA-Literacy/RL/3/",
  "http://www.corestandards.org/ELA-Literacy/RL/4/",
  "http://www.corestandards.org/ELA-Literacy/RL/5/",
  "http://www.corestandards.org/ELA-Literacy/RL/6/",
  "http://www.corestandards.org/ELA-Literacy/RL/7/",
  "http://www.corestandards.org/ELA-Literacy/RL/8/",
  "http://www.corestandards.org/ELA-Literacy/RL/9-10/",
  "http://www.corestandards.org/ELA-Literacy/RL/11-12/",

  "http://www.corestandards.org/ELA-Literacy/RI/1/",
  "http://www.corestandards.org/ELA-Literacy/RI/2/",
  "http://www.corestandards.org/ELA-Literacy/RI/3/",
  "http://www.corestandards.org/ELA-Literacy/RI/4/",
  "http://www.corestandards.org/ELA-Literacy/RI/5/",
  "http://www.corestandards.org/ELA-Literacy/RI/6/",
  "http://www.corestandards.org/ELA-Literacy/RI/7/",
  "http://www.corestandards.org/ELA-Literacy/RI/8/",
  "http://www.corestandards.org/ELA-Literacy/RI/9-10/",
  "http://www.corestandards.org/ELA-Literacy/RI/11-12/",

  "http://www.corestandards.org/ELA-Literacy/RF/1/",
  "http://www.corestandards.org/ELA-Literacy/RF/2/",
  "http://www.corestandards.org/ELA-Literacy/RF/3/",
  "http://www.corestandards.org/ELA-Literacy/RF/4/",
  "http://www.corestandards.org/ELA-Literacy/RF/5/",

  "http://www.corestandards.org/ELA-Literacy/W/1/",
  "http://www.corestandards.org/ELA-Literacy/W/2/",
  "http://www.corestandards.org/ELA-Literacy/W/3/",
  "http://www.corestandards.org/ELA-Literacy/W/4/",
  "http://www.corestandards.org/ELA-Literacy/W/5/",
  "http://www.corestandards.org/ELA-Literacy/W/6/",
  "http://www.corestandards.org/ELA-Literacy/W/7/",
  "http://www.corestandards.org/ELA-Literacy/W/8/",
  "http://www.corestandards.org/ELA-Literacy/W/9-10/",
  "http://www.corestandards.org/ELA-Literacy/W/11-12/",

  "http://www.corestandards.org/ELA-Literacy/SL/1/",
  "http://www.corestandards.org/ELA-Literacy/SL/2/",
  "http://www.corestandards.org/ELA-Literacy/SL/3/",
  "http://www.corestandards.org/ELA-Literacy/SL/4/",
  "http://www.corestandards.org/ELA-Literacy/SL/5/",
  "http://www.corestandards.org/ELA-Literacy/SL/6/",
  "http://www.corestandards.org/ELA-Literacy/SL/7/",
  "http://www.corestandards.org/ELA-Literacy/SL/8/",
  "http://www.corestandards.org/ELA-Literacy/SL/9-10/",
  "http://www.corestandards.org/ELA-Literacy/SL/11-12/",

  "http://www.corestandards.org/ELA-Literacy/L/1/",
  "http://www.corestandards.org/ELA-Literacy/L/2/",
  "http://www.corestandards.org/ELA-Literacy/L/3/",
  "http://www.corestandards.org/ELA-Literacy/L/4/",
  "http://www.corestandards.org/ELA-Literacy/L/5/",
  "http://www.corestandards.org/ELA-Literacy/L/6/",
  "http://www.corestandards.org/ELA-Literacy/L/7/",
  "http://www.corestandards.org/ELA-Literacy/L/8/",
  "http://www.corestandards.org/ELA-Literacy/L/9-10/",
  "http://www.corestandards.org/ELA-Literacy/L/11-12/",

  "http://www.corestandards.org/ELA-Literacy/RH/6-8/",
  "http://www.corestandards.org/ELA-Literacy/RH/9-10/",
  "http://www.corestandards.org/ELA-Literacy/RH/11-12/",

  "http://www.corestandards.org/ELA-Literacy/RST/6-8/",
  "http://www.corestandards.org/ELA-Literacy/RST/9-10/",
  "http://www.corestandards.org/ELA-Literacy/RST/11-12/",

  "http://www.corestandards.org/ELA-Literacy/WHST/6-8/",
  "http://www.corestandards.org/ELA-Literacy/WHST/9-10/",
  "http://www.corestandards.org/ELA-Literacy/WHST/11-12/"
]

anchor_urls = [
  "http://www.corestandards.org/ELA-Literacy/CCRA/R/",
  "http://www.corestandards.org/ELA-Literacy/CCRA/W/",
  "http://www.corestandards.org/ELA-Literacy/CCRA/SL/",
  "http://www.corestandards.org/ELA-Literacy/CCRA/L/"
]

def self.scrape_url(url)
  doc = Nokogiri::HTML(open(url))

  # Fetch type, category & title.
  split_array = doc.xpath('//*[@id="main"]/article/header/h1').text.split("»")
  type = split_array[0].strip.gsub(" Standards", "")
  category = split_array[1].strip
  grade = split_array[2].strip

  # Fetch standards data.
  h4_tags = doc.xpath('//*[@id="main"]/article/section/h4')
  h4_tags.each do |h4|
    next_element = h4
    while next_element != nil
      next_element = next_element.next_element
      break if next_element == nil || next_element.name == "h4"
      standard_name = next_element.children[0]['name']
      description = next_element.children[2]

      if standard_name != nil && standard_name.to_s.strip != ""
        @sheet.update_row @index, url, type, category, grade, h4.text[0..-2], standard_name, description.text.to_s
        @index += 1
      end
    end
  end
end

book = Spreadsheet::Workbook.new
@sheet = book.create_worksheet
@sheet.update_row 0, "Link", "Type", "Category", "Grade", "Sub Category", "Standard", "Description"
@index = 1

urls.each do |url|
  scrape_url(url)
end

book.write 'common-core-english-grade-standards.xls'

# Anchor standards.
book = Spreadsheet::Workbook.new
@sheet = book.create_worksheet
@sheet.update_row 0, "Link", "Type", "Category", "Grade", "Sub Category", "Standard", "Description"
@index = 1

anchor_urls.each do |url|
  scrape_url(url)
end

book.write 'common-core-english-anchor-standards.xls'
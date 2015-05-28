require 'nokogiri'
require 'open-uri'
require 'spreadsheet'

urls = [
  "http://www.corestandards.org/Math/Content/1/OA/",
  "http://www.corestandards.org/Math/Content/1/NBT/",
  "http://www.corestandards.org/Math/Content/1/MD/",
  "http://www.corestandards.org/Math/Content/1/G/",

  "http://www.corestandards.org/Math/Content/2/OA/",
  "http://www.corestandards.org/Math/Content/2/NBT/",
  "http://www.corestandards.org/Math/Content/2/MD/",
  "http://www.corestandards.org/Math/Content/2/G/",

  "http://www.corestandards.org/Math/Content/3/OA/",
  "http://www.corestandards.org/Math/Content/3/NBT/",
  "http://www.corestandards.org/Math/Content/3/NF/",
  "http://www.corestandards.org/Math/Content/3/MD/",
  "http://www.corestandards.org/Math/Content/3/G/",

  "http://www.corestandards.org/Math/Content/4/OA/",
  "http://www.corestandards.org/Math/Content/4/NBT/",
  "http://www.corestandards.org/Math/Content/4/NF/",
  "http://www.corestandards.org/Math/Content/4/MD/",
  "http://www.corestandards.org/Math/Content/4/G/",

  "http://www.corestandards.org/Math/Content/5/OA/",
  "http://www.corestandards.org/Math/Content/5/NBT/",
  "http://www.corestandards.org/Math/Content/5/NF/",
  "http://www.corestandards.org/Math/Content/5/MD/",
  "http://www.corestandards.org/Math/Content/5/G/",

  "http://www.corestandards.org/Math/Content/6/RP/",
  "http://www.corestandards.org/Math/Content/6/NS/",
  "http://www.corestandards.org/Math/Content/6/EE/",
  "http://www.corestandards.org/Math/Content/6/G/",
  "http://www.corestandards.org/Math/Content/6/SP/",

  "http://www.corestandards.org/Math/Content/7/RP/",
  "http://www.corestandards.org/Math/Content/7/NS/",
  "http://www.corestandards.org/Math/Content/7/EE/",
  "http://www.corestandards.org/Math/Content/7/G/",
  "http://www.corestandards.org/Math/Content/7/SP/",

  "http://www.corestandards.org/Math/Content/8/NS/",
  "http://www.corestandards.org/Math/Content/8/EE/",
  "http://www.corestandards.org/Math/Content/8/F/",
  "http://www.corestandards.org/Math/Content/8/G/",
  "http://www.corestandards.org/Math/Content/8/SP/"

]

high_school_urls = [

  "http://www.corestandards.org/Math/Content/HSN/RN/",
  "http://www.corestandards.org/Math/Content/HSN/Q/",
  "http://www.corestandards.org/Math/Content/HSN/CN/",
  "http://www.corestandards.org/Math/Content/HSN/VM/",

  "http://www.corestandards.org/Math/Content/HSA/SSE/",
  "http://www.corestandards.org/Math/Content/HSA/APR/",
  "http://www.corestandards.org/Math/Content/HSA/CED/",
  "http://www.corestandards.org/Math/Content/HSA/REI/",

  "http://www.corestandards.org/Math/Content/HSF/IF/",
  "http://www.corestandards.org/Math/Content/HSF/BF/",
  "http://www.corestandards.org/Math/Content/HSF/LE/",
  "http://www.corestandards.org/Math/Content/HSF/TF/",

  "http://www.corestandards.org/Math/Content/HSG/CO/",
  "http://www.corestandards.org/Math/Content/HSG/SRT/",
  "http://www.corestandards.org/Math/Content/HSG/C/",
  "http://www.corestandards.org/Math/Content/HSG/GPE/",
  "http://www.corestandards.org/Math/Content/HSG/GMD/",
  "http://www.corestandards.org/Math/Content/HSG/MG/",

  "http://www.corestandards.org/Math/Content/HSS/ID/",
  "http://www.corestandards.org/Math/Content/HSS/IC/",
  "http://www.corestandards.org/Math/Content/HSS/CP/",
"http://www.corestandards.org/Math/Content/HSS/MD/"

]

def self.scrape_url(url)
  doc = Nokogiri::HTML(open(url))

  # Fetch type, category & title.
  split_array = doc.xpath('//*[@id="main"]/article/header/h1').text.split("»")
  type = "Mathematics Standards"
  grade = split_array[0].strip
  category = split_array[1].strip

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

book.write 'common-core-maths-grade-standards.xls'

book = Spreadsheet::Workbook.new
@sheet = book.create_worksheet
@sheet.update_row 0, "Link", "Type", "Category", "Grade", "Sub Category", "Standard", "Description"
@index = 1

high_school_urls.each do |url|
  scrape_url(url)
end

book.write 'common-core-maths-high-school-standards.xls'
#!/usr/bin/ruby

require 'nokogiri'

products = Nokogiri::XML(File.open('mini.xml'))

query = "//artikel[./Namn = 'North British' and (number(substring(./Saljstart/text(),1,4)) < 2015 or (number(substring(./Saljstart/text(),1,4)) = 2015 and number(substring(./Saljstart/text(),6,2)) < 10) or (number(substring(./Saljstart/text(),1,4)) = 2015 and number(substring(./Saljstart/text(),6,2)) = 10 and number(substring(./Saljstart/text(),9,2)) <= 29))]"
artikelNoder = products.xpath(query)
puts(artikelNoder)

# and (
#   number(substring(./Saljstart/text(),1,4)) < 2015 or
#   (
#     number(substring(./Saljstart/text(),1,4)) = 2015 and
#     number(substring(./Saljstart/text(),6,2)) < 10
#   ) or
#   (
#     number(substring(./Saljstart/text(),1,4)) = 2015 and
#     number(substring(./Saljstart/text(),6,2)) = 10 and
#     number(substring(./Saljstart/text(),9,2)) <= 29
#   )
# )

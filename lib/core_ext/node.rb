require 'nokogiri'

class Nokogiri::XML::Node
  def get_childnode_text(childNodeName)
    self.>(childNodeName).text
  end
end

require 'open-uri'

class XMLHämtare

  def initialize(url)
    @url = url
  end

  def hämta_xml()
    content = ''
    open(@url) do |io|
      content = io.read()
    end
    return content
  end

end

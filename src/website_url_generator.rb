class WebsiteURLGenerator

  def generera(artikel)
    bas = "http://www.systembolaget.se/dryck/ol/"
    ersattNamn = ersättUrl(artikel.namn.dup)
    return bas + ersattNamn + "-#{artikel.nr}"
  end

  private

    def ersättUrl(text)
      ersättningar = {
        'å' => 'a',
        'Å' => 'a',
        'ä' => 'a',
        'Ä' => 'a',
        'á' => 'a',
        'Á' => 'a',
        'à' => 'a',
        'À' => 'a',
        'ö' => 'o',
        'Ö' => 'o',
        'ø' => 'o',
        'Ø' => 'o',
        'ó' => 'o',
        'Ó' => 'o',
        'ò' => 'o',
        'Ò' => 'o',
        'è' => 'e',
        'È' => 'e',
        'é' => 'e',
        'É' => 'e',
        'ë' => 'e',
        'Ë' => 'e',
        ' &' => '',
        "'" => '',
        "´" => '',
        "`" => '',
        ":" => '',
        "." => '',
        "!" => '',
        "/" => '',
        ' ' => '-'
      }
      ersättningar.each do |key, value|
        text.gsub!(key, value)
      end
      text.downcase!
      return text
    end

end

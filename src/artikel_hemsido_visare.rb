class ArtikelHemsidoVisare

  def initialize(websiteURLGenerator)
    @websiteURLGenerator = websiteURLGenerator
  end

  def visa(artikel)
    link = @websiteURLGenerator.generera(artikel)
    hostOS = RbConfig::CONFIG['host_os']
    if hostOS =~ /mswin|mingw|cygwin/
      system "start #{link} >NULL 2>&1"
    elsif hostOS =~ /darwin/
      system "open #{link}"
    elsif hostOS =~ /linux|bsd/
      system "xdg-open #{link} >/dev/null 2>&1"
    end
  end

end

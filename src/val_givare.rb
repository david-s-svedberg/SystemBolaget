class ValGivare

  def initialize()

    @visaFramtidaSäljstart = false
    @visaTidigareTillagda = false
    @visaArtiklarMedKollikrav = false
    @visaArtiklarSomEjGårAttBeställa = false
    @visaArtiklarSomÄrTillfälligtSlut = false
    @oönskadeSortiment = []
    @varugrupper = []

    OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options]"

      opts.on('-ss', '--säljstart', 'Visa artiklar med framtida säljstart') { @visaFramtidaSäljstart = true }
      opts.on('-ut', '--utesluttillagda', 'Visa ej artiklar som lagts till tidigare') { @visaTidigareTillagda = true }
      opts.on('-kk', '--kollikrav', 'Visa artiklar som har ett kollikrav ') { @visaArtiklarMedKollikrav = true }
      opts.on('-eb', '--ejbeställlbara', 'Visa artiklar som ej går att beställa då de bara får säljas till ett systembolag ') { @visaArtiklarSomEjGårAttBeställa = true }
      opts.on('-ts', '--tillfälligtslut', 'Visa artiklar som är tillfälligt slut') { @visaArtiklarSomÄrTillfälligtSlut = true }
      opts.on('--oönskadeSortiment x,y,y', 'Lista av sortiment som inte är önskvärda') { |oönskadeSortiment| @oönskadeSortiment = oönskadeSortiment }
      opts.on('--varugrupper x,y,y', 'Lista av varugrupper som ska visas') { |varugrupper| @varugrupper = varugrupper }

    end.parse!

  end

  def valda_varugrupper()
    return @varugrupper
  end

  def visa_artiklar_med_framtida_säljstart?()
    return @visaArtiklarMedFramtidaSäljstart
  end

  def begränsa_sortimen?()
    return oönskadeSortiment.empty?
  end

  def oönskade_sortiment()
    return @oönskadeSortiment
  end

  def uteslut_tidigare_tillagda_artiklar?
    return @utesluttillagda
  end

  def visa_artiklar_med_kollikrav?
    return @visaArtiklarMedKollikrav
  end

  def visa_artiklar_som_ej_går_att_beställa?
    return @visaArtiklarSomEjGårAttBeställa
  end

  def visa_artiklar_som_är_tillfälligt_slut?
    return @visaArtiklarSomÄrTillfälligtSlut
  end



end

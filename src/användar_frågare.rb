require 'io/console'

class AnvändarFrågare

  def begär_val_för_visad_artikel()
    puts("Välj mellan: [L]ägg till, [S]kippa, [U]teslut, [Ö]ppna hemsida eller [A]vbryt.")
    ret = nil

    while(ret == nil)
      val = STDIN.getch.downcase!
      case val
      when 'l'
        ret = :lägg_till
      when 'ö'
        ret = :öppna_hemsida
      when 'u'
        ret = :uteslut
      when 's'
        ret = :skippa
      when 'a'
        ret = :avsluta
      end
    end

    return ret
  end

  def begär_val_för_felaktig_hemsida()
    puts("Välj mellan: [V]isa artikel, [S]kippa, [U]teslut eller [A]vbryt.")
    ret = nil
    while(ret == nil)
      val = STDIN.getch.downcase!
      case val
      when 'v'
        ret = :visa_artikel
      when 'u'
        ret = :uteslut
      when 's'
        ret = :skippa
      when 'a'
        ret = :avsluta
      end
    end

    return ret
  end

end

require 'io/console'

class AnvändarFrågare

  def begär_val_för_visad_artikel()
    ret = nil

    while(ret == nil)
      val = STDIN.getch
      val.downcase!
      case val
      when 'l', 'ö', 'u', 's', 'a'
        ret = val
      end
    end

    return ret
  end

  def begär_val_för_felaktig_hemsida()
    ret = nil

    while(ret == nil)
      val = STDIN.getch
      val.downcase!
      case val
      when 'v', 'u', 's', 'a'
        ret = val
      end
    end

    return ret
  end

end

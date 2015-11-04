class AnvändarFrågare

  def begär_val_för_visad_artikel()
    puts("Välj mellan: [L]ägg till, [S]kippa, [U]teslut, [Ö]ppna hemsida eller [A]vbryt.")
    ret = nil

    while(ret == nil)
      val = STDIN.getch
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

end

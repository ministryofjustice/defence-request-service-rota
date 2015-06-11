module RotaHelper
  def present_organisations(organisations)
    tags = organisations.map do |org|
      org_colour = organisation_colour(org)

      content_tag(:span, org.name,
                  class: "rota-slot-organisation",
                  style: "background-color: ##{org_colour}; color: #{organisation_text_colour(org_colour)};")
    end

    tags.join("</br>").html_safe
  end

  def organisation_colour(org)
    org.uid.first(6)
  end

  def organisation_text_colour(org_colour)
    if luminance(org_colour) > 50
      return "#000"
    else
      return "#fff"
    end
  end

  # Calculates the luminance of the provided colour
  # in order to work out whether to put white or
  # black text over it. Calculation from
  # http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  def luminance(colour)
    red = component(colour[0..1].to_i(16))
    blue = component(colour[2..3].to_i(16))
    green = component(colour[4..5].to_i(16))

    21.26 * red + 71.52 * green + 7.22 * blue
  end

  def component(colour)
    colour /= 255.0

    if colour < 0.03928
      colour / 12.92
    else
      (((colour + 0.055) / 1.055)**2.4)
    end
  end
end

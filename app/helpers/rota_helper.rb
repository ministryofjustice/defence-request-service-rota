module RotaHelper
  def present_organisations(organisations_with_solicitors)
    tags = organisations_with_solicitors.map do |org_hsh|
      org_colour = organisation_colour(org_hsh[:organisation_uid])

      content_tag(:span, org_and_solicitor(org_hsh),
                  class: "rota-slot-organisation #{organisation_text_class(org_colour)}",
                  style: "background-color: ##{org_colour};")
    end

    tags.join("</br>").html_safe
  end

  def org_and_solicitor(org_hsh)
    str = org_hsh[:organisation_name].dup

    str << " - #{org_hsh[:solicitor_name]}" if org_hsh[:solicitor_name].present?

    str
  end

  def organisation_colour(org_uid)
    org_uid.first(6)
  end

  def organisation_text_class(org_colour)
    if luminance(org_colour) > 50
      return "dark_text"
    else
      return "light_text"
    end
  end

  def format_date(date)
    str = date.strftime("%A, %-d %b %Y")
    str << " (Bank Holiday)" if date.is_bank_holiday?
    str
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

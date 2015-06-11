module RotaHelper
  def select_allocated_organisations(rota, shift, slots)
    organisation_uids = slots.select { |s| s.shift_id == shift.id }.map(&:organisation_uid)

    organisations = @rota.organisations_with_uids(organisation_uids)

    organisations.map do |org|
      org_colour = organisation_colour(org)

      content_tag(:span, org.name, class: "rota-slot-organisation", style: "background-color: ##{org_colour}; color: #{organisation_text_colour(org_colour)};")
    end.join("</br>").html_safe
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

  def luminance(colour)
    red = component(colour[0..1].to_i(16))
    blue = component(colour[2..3].to_i(16))
    green = component(colour[4..5].to_i(16))

    21.26 * red + 71.52 * green + 7.22 * blue
  end

  def component(colour)
    colour /= 255.0
    return colour < 0.03928 ? colour / 12.92 : (((colour + 0.055)/1.055) ** 2.4);
  end
end

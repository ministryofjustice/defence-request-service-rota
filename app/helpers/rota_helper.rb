module RotaHelper
  def select_allocated_organisations(rota, shift, slots)
    organisation_uids = slots.select { |s| s.shift_id == shift.id }.map(&:organisation_uid)

    organisations = @rota.organisations_with_uids(organisation_uids)

    organisations.map(&:name).join("</br></br>").html_safe
  end

end

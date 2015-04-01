class Dashboard
  def solicitors
    Solicitor.all
  end

  def organisations
    data_api.organisations[:organisations].map do |organisation_attrs|
      Organisation.build_from(organisation_attrs)
    end
  end
end

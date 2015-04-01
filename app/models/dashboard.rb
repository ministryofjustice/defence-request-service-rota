class Dashboard

  def solicitors
    DefenceRequestServiceRota.service(:auth_api).solicitors[:profiles].map { |attrs| Solicitor.build_from(attrs) }
  end

end

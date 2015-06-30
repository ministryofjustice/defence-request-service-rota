require "rails_helper"

RSpec.describe OrganisationsController do
  before do
    sign_in(create(:admin_user))
  end

  describe "POST create" do
    it "saves the organisation and redirects to index" do
      stub_organisation method: :save, return_value: true

      post :create, organisation: organisation_params

      expect(response).to redirect_to organisations_path
    end

    it "redirects to new if the organisation could not be created" do
      stub_organisation method: :save, return_value: false

      post :create, organisation: { name: "" }

      expect(response).to render_template :new
    end
  end

  describe "PATCH update" do
    it "updates the organisation and redirects to index" do
      stub_organisation_lookup
      stub_organisation method: :update_attributes, return_value: true

      patch :update, { id: "1", organisation: organisation_params }

      expect(response).to redirect_to organisations_path
    end

    it "redirects to edit if the organisation could not be updated" do
      stub_organisation_lookup
      stub_organisation method: :update_attributes, return_value: false

      patch :update, { id: "1", organisation: organisation_params }

      expect(response).to render_template :edit
    end
  end

  def stub_organisation(method:, return_value:)
    allow(mock_organisation).to receive(method).and_return(return_value)
  end

  def mock_organisation
    @_mock ||= double(:mock_organisation)
  end

  def stub_organisation_lookup
    allow(Organisation).to receive(:find).
      and_return(mock_organisation)
  end

  def organisation_params
    attributes_for(:organisation)
  end
end

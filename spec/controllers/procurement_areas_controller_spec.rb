require "rails_helper"

RSpec.describe ProcurementAreasController do
  describe "POST create" do
    it "saves the procurement area and redirects to index" do
      stub_signed_in_user
      stub_procurement_area method: :save, return_value: true

      post :create, procurement_area: procurement_area_params

      expect(response).to redirect_to procurement_areas_path
    end

    it "redirects to new if the procurement area could not be created" do
      stub_signed_in_user
      stub_procurement_area method: :save, return_value: false

      post :create, procurement_area: { name: "" }

      expect(response).to render_template :new
    end
  end

  describe "PATCH update" do
    it "updates the procurement area and redirects to index" do
      stub_signed_in_user
      stub_procurement_area_lookup
      stub_procurement_area method: :update_attributes, return_value: true

      patch :update, { id: "1", procurement_area: procurement_area_params }

      expect(response).to redirect_to procurement_areas_path
    end

    it "redirects to new if the procurement area could not be update" do
      stub_signed_in_user
      stub_procurement_area_lookup
      stub_procurement_area method: :update_attributes, return_value: false

      patch :update, { id: "1", procurement_area: procurement_area_params }

      expect(response).to render_template :edit
    end
  end

  def stub_signed_in_user
    allow_any_instance_of(ProcurementAreasController).
      to receive(:current_user).and_return(double(:mock_user))
  end

  def stub_procurement_area(method:, return_value:)
    allow(mock_procurement_area).to receive(method).and_return(return_value)
  end

  def mock_procurement_area
    @_mock ||= double(:mock_procurement_area)
  end

  def stub_procurement_area_lookup
    allow(ProcurementArea).to receive(:find).
      and_return(mock_procurement_area)
  end

  def procurement_area_params
    attributes_for(:procurement_area)
  end
end

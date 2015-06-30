class OrganisationsController < ApplicationController
  def index
    @organisations = Organisation.all
  end

  def show
    @organisation = organisation
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(organisation_params)

    if @organisation.save
      redirect_to organisations_path
    else
      render :new
    end
  end

  def edit
    @organisation = organisation
  end

  def update
    @organisation = organisation

    if @organisation.update_attributes(organisation_params)
      redirect_to organisations_path
    else
      render :edit
    end
  end

  def destroy
    organisation.destroy

    redirect_to organisations_path
  end

  private

  def organisation
    Organisation.find(params[:id])
  end

  def organisation_params
    params.require(:organisation).permit(:name,
                                             :organisation_type,
                                             :tel,
                                             :address,
                                             :postcode,
                                             :email,
                                             :mobile)
  end
end

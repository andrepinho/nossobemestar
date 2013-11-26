class PasswordsController < Devise::PasswordsController

  def create
    if user = User.find_by_email(resource_params[:email])
      user.update_attribute :region, current_region
    end
    super
  end

end

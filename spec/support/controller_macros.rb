module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create :admin
      admin.confirm # Only necessary if you are using the "confirmable" module
      sign_in admin
    end
  end

   def login_user
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create :user
      user.confirm # Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authorize!
    unless current_neo_user.present?
      render json: { error: "Invalid JWT token" }
    end
  end

  def jwt_user
    @jwt_user ||= Satellite::JWTUserDecoder.new(Satellite::UserCookie.new(cookies).to_cookie)
  end

  def current_neo_user
    @current_neo_user ||= User.find_by(uid: jwt_user.user_uid)
  end
end

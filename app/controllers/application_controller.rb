class ApplicationController < ActionController::Base
  before_action :authenticate_user! # Solamentelos usuarios registrados pueden ingresar al index de la pag

  before_action :set_locale # Lenguaje en español

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_path
  end

  def set_locale
    I18n.locale = 'es'
  end
end

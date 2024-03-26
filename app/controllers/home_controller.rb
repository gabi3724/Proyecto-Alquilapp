class HomeController < ApplicationController
  #before_action :verificar_logueado

  def index
    @autos = Auto.all
  end

  def unauthorized
  end
end

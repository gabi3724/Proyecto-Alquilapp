class AutosController < ApplicationController
  before_action :verificar_logueado
  before_action :verificar_autorizacion_admin, only: [:new, :create]
  include HTTParty
  
  def new
    @auto= Auto.new
  end

  def create
    @auto= Auto.new(auto_params)
    x=rand(-34.943789..-34.897041)
    y=rand(-57.973537..-57.933111)
    @auto.ubicacion=x.to_s+","+y.to_s
    @auto.porcentaje_tanque=rand(30..100)
    if @auto.save
      redirect_to auto_path(@auto)
    else
      render :new, status: :see_other
    end
  end

  def show
    @auto = Auto.find(params[:id])
  end

  def index
    @autos = Auto.all
  end

  def actualizar_datos
    @auto = Auto.find(params[:auto_id])
    response = HTTParty.post('https://alquilapp.is.k-pb.com.ar/grupo03/api/vehicle-status', body: JSON.generate({ vehicle_id: @auto.patente }), basic_auth: {username: 'g3', password: '58orq2'}, headers: { 'Content-Type' => 'application/json' })
    datos = response.parsed_response
    if (datos["status"]["engine"] == "on")
      @auto.encendido = true
    elsif (datos["status"]["engine"] == "off")
      @auto.encendido = false
    end
    @auto.porcentaje_tanque = datos["status"]["fuel_level"]
    @auto.ubicacion.x = datos["status"]["location"]["lat"]
    @auto.ubicacion.y = datos["status"]["location"]["lon"]
    @auto.save
  end

  def confirmar
    @auto= Auto.find(params[:id])
  end

  def destroy
    @auto= Auto.find(params[:id])
    if !@auto.alquilado
      if @auto.destroy
        redirect_to root_path
      else
        redirect_to auto_path(@auto), alert: "Hubo un error al eliminar el auto"
      end
    else
      redirect_to auto_path(@auto), alert: "El auto está siendo alquilado actualmente"
    end
  end

  def editar
    @auto= Auto.find(params[:id])
  end

  def preview
    @auto= Auto.find(params[:id])
    @cambios=true
    if(@auto.patente==params[:patente] && @auto.marca==params[:marca] && @auto.modelo==params[:modelo] && @auto.color==params[:color] && 
      @auto.tipo_de_caja==params[:tipo_de_caja] && @auto.tipo_de_motor==params[:tipo_de_motor] && @auto.autonomia==params[:autonomia] &&
      @auto.como_cargar==params[:como_cargar])
        @cambios=false
    end
  end

  def update
    @auto= Auto.find(params[:id])
    if @auto.update(auto_params)
      redirect_to auto_path(@auto), notice:"Edición exitosa de información"
    else
      render :editar, status: :see_other
    end
  end

  def editar_foto
    @auto= Auto.find(params[:id])
  end

  def update_foto
    @auto= Auto.find(params[:id])
    if @auto.update(auto_params)
      redirect_to auto_path(@auto), notice:"Foto editada correctamente"
    else
      render :editar_foto, status: :see_other
    end
  end

  private

  def auto_params
    params.require(:auto).permit(:patente,:marca,:modelo,:color,:tipo_de_caja,:tipo_de_motor,:autonomia,:como_cargar,:foto)
  end
end

VALOR = Costo.first.combustible
class AlquilersController < ApplicationController
  before_action :alquilando?

  def index
  end

  def licencia
    usuario = Usuario.find_by(global_id: session[:global_id])
    @alquiler = Alquiler.find_by(usuario_id: usuario.id)
  end
  
  def alquilando?
    usuario = Usuario.find_by(global_id: session[:global_id])
    alquiler = Alquiler.find_by(usuario_id: usuario.id)
    if alquiler.nil?
      redirect_to root_path
    end
    return true
  end
  
  def show
    @alquiler = Alquiler.find_by(id: params[:id])
    @usuario = Usuario.find_by(global_id: session[:global_id])
  end

  def destroy
    @alquiler = Alquiler.find_by(id: params[:id])
    motorEncendido = @alquiler.auto.encendido
    #motorEncendido = false
    if motorEncendido
      redirect_to @alquiler, notice: "El motor debe estar apagado para terminar el alquiler"
    else
      #probablemente pude haber usado lo siguiente pero no me di cuenta
      #if (window.location == "http://localhost:3000/advertencia")...
      #por eso tengo el def de eliminar
      x = @alquiler.auto.ubicacion.x
      y = @alquiler.auto.ubicacion.y
      if Auto.where("ubicacion <@ polygon(path '(-34.922962, -57.993537), (-34.887041, -57.954186), (-34.917492, -57.913111), (-34.953789, -57.951881)')").where(id: @alquiler.auto_id).size == 0
        redirect_to(advertencia_path)
      else
        if @alquiler.porcentaje_tanque_inicial > @alquiler.auto.porcentaje_tanque
          cred_final = @alquiler.usuario.creditos - (@alquiler.porcentaje_tanque_inicial - @alquiler.auto.porcentaje_tanque)*VALOR
          @alquiler.usuario.update(creditos:cred_final)
        end
        @alquiler.usuario.update(fecha_ultimo_alquiler:DateTime.now)
        @alquiler.auto.update(alquilado:false)
        @alquiler.destroy
        redirect_to root_path
      end
    end
  end

  def aviso
    usuario = Usuario.find_by(global_id: session[:global_id])
    @alquiler = Alquiler.find_by(usuario_id: usuario.id)
    motorEncendido = @alquiler.auto.encendido
    if motorEncendido
      redirect_to @alquiler, notice: "El motor debe estar apagado para terminar el alquiler"
    else
      x = @alquiler.auto.ubicacion.x
      y = @alquiler.auto.ubicacion.y
      if Auto.where("ubicacion <@ polygon(path '(-34.922962, -57.993537), (-34.887041, -57.954186), (-34.917492, -57.913111), (-34.953789, -57.951881)')").where(id: @alquiler.auto_id).size == 0
        redirect_to(advertencia_path)
      end
    end
  end

  #Nota: La diferencia entre destroy y eliminar es que llegamos a eliminar si es que decidimos
  #terminar el alquiler aunque estemos fuera de La Plata, por eso es que acá no verificamos
  #donde estamos.
  def eliminar
    usuario = Usuario.find_by(global_id: session[:global_id])
    @alquiler = Alquiler.find_by(usuario_id: usuario.id)
    motorEncendido = @alquiler.auto.encendido
    if motorEncendido
      redirect_to @alquiler, notice: "El motor debe estar apagado para terminar el alquiler"
    else
      if @alquiler.porcentaje_tanque_inicial > @alquiler.auto.porcentaje_tanque
        cred_final = @alquiler.usuario.creditos - (@alquiler.porcentaje_tanque_inicial - @alquiler.auto.porcentaje_tanque)*VALOR
        @alquiler.usuario.update(creditos:cred_final)
      end
      @alquiler.usuario.update(fecha_ultimo_alquiler:DateTime.now)
      @alquiler.auto.update(alquilado:false)
      @alquiler.destroy
      redirect_to root_path
    end
  end

  def advertencia
    usuario = Usuario.find_by(global_id: session[:global_id])
    @alquiler = Alquiler.find_by(usuario_id: usuario.id)
  end

  def update
    @usuario = Usuario.find(params[:usuario_id])
    @alquiler = Alquiler.find(params[:alquiler_id])
    @horas = params[:horas].to_i
    @costo = params[:costo].to_i
    @usuario.creditos = (@usuario.creditos-@costo)
    @usuario.save
    @alquiler.horas = @alquiler.horas + @horas
    @alquiler.costo = @alquiler.costo + @costo
    @alquiler.save
    redirect_to @alquiler, notice:"Tiempo de alquiler extendido"
  end

end
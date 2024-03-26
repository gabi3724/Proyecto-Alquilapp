class AlquilerController < ApplicationController
    before_action :usuario_logueado?
    before_action :verificar_documentos_usuario, only: [:create]

    def index

    end
  
    def show

    end

    def confirmarAlquiler
      @horas = params[:horas]
      @usuario = Usuario.find(usuario_actual.id)
      @auto = Auto.find(params[:auto_id])
      @tarifa = Costo.first.alquiler
      @costo = @horas.to_i*@tarifa
    end

    def confirmarExtenderAlquiler
      @horas = params[:horas]
      @usuario = Usuario.find(usuario_actual.id)
      @alquiler = Alquiler.find(params[:alquiler_id])
      @tarifa = Costo.first.alquiler
      @costo = @horas.to_i*@tarifa
    end

    def alquilerActual
      @alquiler= Alquiler.find_by(usuario_id:usuario_actual.id)
      if !@alquiler
        redirect_to usuarios_path, alert:"Usted no está alquilando ningún vehículo"
      end
    end

    def cancelarAlquiler
      @alquiler= Alquiler.find(params[:alquiler_id])
    end

    def cancelacion
      alquiler= Alquiler.find(params[:alquiler_id])
      descripcion = params[:descripcion]
      Cancelado.create(motivo: descripcion, patente: alquiler.auto.patente, usuario_id: alquiler.usuario_id)
      alquiler.usuario.creditos = alquiler.usuario.creditos + alquiler.costo
      alquiler.usuario.fecha_ultimo_alquiler= DateTime.now
      alquiler.usuario.save
      alquiler.auto.alquilado = false
      alquiler.auto.save
      alquiler.destroy
      redirect_to root_path
    end
  
    def create
      @auto = Auto.find(params[:auto_id])
      if !@auto.alquilado
        @usuario = Usuario.find(params[:usuario_id])
        @horas = params[:horas]
        @costo = params[:costo].to_i
        @auto.update(alquilado:true)
        @usuario.creditos = (@usuario.creditos-@costo)
        @usuario.auto_id= @auto.id
        @usuario.fecha_ultimo_alquiler= DateTime.now
        @usuario.save
        @alquiler = Alquiler.create(usuario: @usuario, auto: @auto, costo:@costo, horas: @horas, porcentaje_tanque_inicial:@auto.porcentaje_tanque)
        Thread.new{sleep ((@alquiler.created_at.to_i + @alquiler.horas.to_i * 3600)-DateTime.now.to_i); time_out}
        redirect_to @alquiler
      else
        redirect_to @auto, alert:"Este auto está siendo alquilado actualmente"
      end
    end

    def time_out
      usuario = Usuario.find_by(global_id: session[:global_id])
      alquiler = Alquiler.find_by(usuario_id: usuario.id)
      if alquiler
        tiempoFinal = (alquiler.created_at.to_i + alquiler.horas.to_i * 3600)
        while !Alquiler.find_by(usuario_id: usuario.id).nil? do
          if alquiler.auto.encendido && tiempoFinal >=  DateTime.now.to_i
            sleep (1.minutes.from_now.to_i - DateTime.now.to_i)
          else
            tiempoFinal = (alquiler.created_at.to_i + alquiler.horas.to_i * 3600)
            puts tiempoFinal
            if tiempoFinal > DateTime.now.to_i
              sleep (tiempoFinal - DateTime.now.to_i)
            else
              if alquiler.porcentaje_tanque_inicial > alquiler.auto.porcentaje_tanque
                alquiler.usuario.creditos = alquiler.usuario.creditos - (alquiler.porcentaje_tanque_inicial - alquiler.auto.porcentaje_tanque)*10
                alquiler.usuario.save
              end
              alquiler.usuario.update(fecha_ultimo_alquiler:DateTime.now)
              alquiler.auto.alquilado = false
              alquiler.auto.save
              alquiler.destroy
              break
            end
          end
        end
      end
    end

  end
class SupsController < ApplicationController
  #before_action :verificar_autorizacion_sup, only: [:index]
  before_action :verificar_autorizacion_admin, only: [:new,:create]
  before_action :verificar_autorizacion_sup_admin, only: [:show]

  def new
    @sup= Sup.new
  end

  def create
    @sup= Sup.new(sup_params)
    x=rand(-34.943789..-34.897041)
    y=rand(-57.973537..-57.933111)
    @sup.ubicacion=x.to_s+","+y.to_s
    @sup.global_id="S"+@sup.dni
    if @sup.save
      redirect_to sups_path, notice:"Registro exitoso de supervisor"
    else
      render :new, status: :see_other
    end
  end

  def show
    @sup = Sup.find(params[:id])
  end

  def index
    @sups = Sup.all
  end

  def listaValidacion
    @usuarios = Usuario.where(en_revision: true)
  end

  def darAlta
    if (params[:tipo] == "alta")
      Usuario.find(params[:id]).update(validado: true, en_revision: false)
      redirect_to '/listaValidacion'
    elsif (params[:tipo] == "rechazo")
      Usuario.find(params[:id]).update(validado: false, en_revision: false)
      redirect_to '/listaValidacion'
    end
  end

  def verDni
    @usuario = Usuario.find(params[:id]) 
  end

  def verLicencia
    @usuario = Usuario.find(params[:id]) 
  end

  def actualizarDocumentos
    usuario = Usuario.find(params[:id])

    if (params[:tipo] == "aprobarDni")
      usuario.doc.aceptado!
      usuario.doc.vencimiento = params[:vencimiento]
      usuario.doc.save
      redirect_to controller: 'sups', action: 'verDni', id: usuario.id

    elsif (params[:tipo] == "rechazarDni")
      usuario.doc.rechazado!
      usuario.doc.descripcion = params[:descripcion]
      usuario.doc.save
      redirect_to controller: 'sups', action: 'verDni', id: usuario.id

    elsif (params[:tipo] == "reevaluarDni")
      usuario.doc.en_revision!
      redirect_to controller: 'sups', action: 'verDni', id: usuario.id

    elsif (params[:tipo] == "aprobarLic")
      usuario.lic.aceptado!
      usuario.lic.vencimiento = params[:vencimiento]
      usuario.lic.save
      redirect_to controller: 'sups', action: 'verLicencia', id: usuario.id

    elsif (params[:tipo] == "rechazarLic")
      usuario.lic.rechazado!
      usuario.lic.descripcion = params[:descripcion]
      usuario.lic.save
      redirect_to controller: 'sups', action: 'verLicencia', id: usuario.id

    elsif (params[:tipo] == "reevaluarLic")
      usuario.lic.en_revision!
      redirect_to controller: 'sups', action: 'verLicencia', id: usuario.id
    end
  end

  def edit
    @sup= Sup.find(params[:id])
  end

  def update
    @sup= Sup.find(params[:id])
    viejo_dni= @sup.dni
    if @sup.update(sup_params)
      control(viejo_dni)
      redirect_to sup_path(@sup), notice:"Edición exitosa de información"
    else
      render :edit, status: :see_other
    end
  end

  def control(viejo_dni)
    if (viejo_dni != @sup.dni)
      global_id= "S"+@sup.dni
      @sup.update(global_id:global_id)
      session[:global_id]= global_id
    end
  end

  def confirmar
    @sup= Sup.find(params[:id])
    if !@sup.problema.nil?
      redirect_to sups_path, alert: "El supervisor "+@sup.dni+" está solucionando el problema de un cliente"
    end
  end

  def destroy
    @sup= Sup.find(params[:id])
    if @sup.problema.nil?
      if @sup.destroy
        redirect_to sups_path, alert: "Supervisor eliminado"
      else
        redirect_to sups_path, alert: "Hubo un error al eliminar el supervisor"
      end
    else
      redirect_to sups_path, alert: "El supervisor está solucionando el problema de un cliente"
    end
  end

  private

  def sup_params
    params.require(:sup).permit(:dni,:password,:fecha_nacimiento)
  end
end

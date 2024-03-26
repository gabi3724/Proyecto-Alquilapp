class UsuariosController < ApplicationController

  def index
  end

  def show
    @usuario = Usuario.find(params[:id])
  end

  def new
    @usuario= Usuario.new
  end

  def create
    @usuario= Usuario.new(usuario_params)
    @usuario.global_id="C"+@usuario.dni
    @usuario.creditos= 0
    if @usuario.save
      session[:global_id]=@usuario.global_id
      #redirect_to usuarios_path
      redirect_to root_path
    else
      render :new, status: :see_other
    end
  end

  def edit
    @usuario= Usuario.find(params[:id])
  end

  def update
    @usuario= Usuario.find(params[:id])
    viejo_dni= @usuario.dni
    if @usuario.update(usuario_params)
      control(viejo_dni)
      redirect_to usuario_path(@usuario), notice:"Edición exitosa de información"
    else
      render :edit, status: :see_other
    end
  end

  def control(viejo_dni)
    if (viejo_dni != @usuario.dni)
      global_id= "C"+@usuario.dni
      @usuario.update(global_id:global_id)
      session[:global_id]= global_id
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:dni,:password,:fecha_nacimiento)
  end

end

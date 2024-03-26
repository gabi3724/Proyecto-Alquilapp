class AdminsController < ApplicationController
  before_action :verificar_autorizacion_admin, only: [:index,:show]

  def new
  end

  def create
  end

  def show
    @admin= Admin.find(params[:id])
  end

  def index
  end

  def edit
    @admin= Admin.find(params[:id])
  end

  def update
    @admin= Admin.find(params[:id])
    viejo_dni= @admin.dni
    if @admin.update(admin_params)
      control(viejo_dni)
      redirect_to admin_path(@admin), notice:"Edición exitosa de información"
    else
      render :edit, status: :see_other
    end
  end

  def control(viejo_dni)
    if (viejo_dni != @admin.dni)
      global_id= "A"+@admin.dni
      @admin.update(global_id:global_id)
      session[:global_id]= global_id
    end
  end

  private
  
  def admin_params
    params.require(:admin).permit(:dni,:password,:fecha_nacimiento)
  end
end

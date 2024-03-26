class IncidencesController < ApplicationController
  before_action :crear_sesion_auto, only: [:new]

  def index
    @incidences = Incidence.all
  end

  def show
    @incidence= Incidence.find(params[:id])
  end

  def crear_sesion_auto
    if session[:auto_id] == nil || session[:auto_id] != params[:auto_id]
      session[:auto_id]= params[:auto_id]
    end
  end

  def new
    @auto_id= session[:auto_id]
    @incidence = Incidence.new
  end

  def create
    @incidence = Incidence.new(incidence_params)
    @incidence.auto_id=session[:auto_id]
    if @incidence.save
      session[:auto_id]=nil
      redirect_to auto_path(@incidence.auto_id), notice:"Incidencia agregada exitosamente"
    else
      render :new, status: :see_other
    end
  end

  def confirmacion
    @incidence= Incidence.find(params[:id])
  end

  def destroy
    @incidence = Incidence.find(params[:id])
    auto_id= @incidence.auto_id
    if @incidence.destroy
      redirect_to auto_path(auto_id), notice: "Incidencia eliminada exitosamente"
    else
      redirect_to auto_path(auto_id), alert: "Hubo un error al eliminar la incidencia"
    end
  end
  

  private

    # Only allow a list of trusted parameters through.
    def incidence_params
      params.require(:incidence).permit(:foto,:descripcion)
    end
end

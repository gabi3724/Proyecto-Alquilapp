class LicsController < ApplicationController
  
  def show
  end

  def new
    @lic = Lic.new
  end

  def create
    if !usuario_actual.lic.nil?
      usuario_actual.lic.destroy
    end
    @lic= Lic.new(lic_params)
    @lic.estado= "en_revision"
    if (!usuario_actual.doc.nil?)
      usuario_actual.update(en_revision: true)  
    end
    if @lic.save
      redirect_to usuario_path(usuario_actual), notice:"Carga exitosa"
    else
      render :new, status: :see_other
    end
  end

  private
    
    def lic_params
      params.require(:lic).permit(:foto,:descripcion, :estado, :usuario_id)
    end
end

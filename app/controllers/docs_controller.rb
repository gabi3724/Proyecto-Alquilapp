class DocsController < ApplicationController


  def show
  end

  def new
    @doc = Doc.new
  end

  def create
    if !usuario_actual.doc.nil?
      usuario_actual.doc.destroy
    end
    @doc= Doc.new(doc_params)
    @doc.estado= "en_revision"
    if (!usuario_actual.lic.nil?)
      usuario_actual.update(en_revision: true)  
    end
    if @doc.save
      redirect_to usuario_path(usuario_actual), notice:"Carga exitosa"
    else
      render :new, status: :see_other
    end
  end

  private

    def doc_params
      params.require(:doc).permit(:foto, :descripcion, :estado, :usuario_id)
    end
end

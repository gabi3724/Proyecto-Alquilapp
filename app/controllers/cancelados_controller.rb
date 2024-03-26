class CanceladosController < ApplicationController

    def show
        
    end

    def new
        @cancleado = Cancelado.new
    end

    def create
        @cancleado = Cancelado.new(cancelar_params)
    end

    def index
        @autos = Auto.all
        @cancelados = Cancelado.all
    end

    private

    def cancelar_params
      params.require(:cancelado).permit(:motivo, :patente, :usuario_id)
    end

end
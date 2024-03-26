class CostosController < ApplicationController
    before_action :verificar_autorizacion_admin
    before_action :formato_alquiler, only: [:confirmarCostoAlquiler]
    before_action :formato_combustible, only: [:confirmarCostoCombustible]

    def costoAlquiler
        @viejo_costo= Costo.first.alquiler
    end

    def costoCombustible
    end

    def confirmarCostoAlquiler
        @viejo_costo= Costo.first.alquiler
        @nuevo_costo= params[:monto].to_i
        if @viejo_costo == @nuevo_costo
            redirect_to costo_alquiler_path
        end
    end

    def cambiarCostoAlquiler
        costo=Costo.first
        costo.alquiler = params[:monto].to_i
        costo.save
        redirect_to costo_alquiler_path, notice:"Se ha cambiado la tarifa de alquiler"
    end

    def confirmarCostoCombustible
        costo=Costo.first
        costo.combustible = params[:monto].to_i
        costo.save
        redirect_to root_path
    end

    def formato_alquiler
        monto= params[:monto]
        ok=true
        if monto.blank?
            flash.alert="Este campo no puede estar vacío"
            ok=false
        else
            if !(monto=~/\A\d+\Z/)
                flash.alert="El valor debe consistir de números"
                ok=false
            #elsif (monto.to_i <= 0)
            #    flash.alert="El costo a debe ser mayor a 0"
            #    ok=false
            end
        end
        if !ok
            redirect_to costo_alquiler_path
        end
    end

    def formato_combustible
        monto= params[:monto]
        ok=true
        if monto.blank?
            flash.alert="Este campo no puede estar vacío"
            ok=false
        else
            if !(monto=~/\A\d+\Z/)
                flash.alert="El valor debe consistir de números"
                ok=false
            elsif (monto.to_i <= 0)
                flash.alert="El costo a debe ser mayor a 0"
                ok=false
            end
        end
        if !ok
            redirect_to costo_combustible_path
        end
    end
    
end
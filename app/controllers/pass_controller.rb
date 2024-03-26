class PassController < ApplicationController
    before_action :validar, only: [:update_pass]

    def identificar
        if usuario_logueado?
            @editor= usuario_actual
        elsif sup_logueado?
            @editor= sup_actual
        elsif admin_logueado?
            @editor= admin_actual
        end
    end

    def edit_pass
        identificar
    end

    def update_pass
        identificar
        #validar
        if @editor.update(password:params[:new_pass])
            redirect_to @editor, notice:"Edición exitosa de contraseña"
        else
            redirect_to @editor, notice:"Error al editar la contraseña"
        end
    end

    def validar
        identificar
        act= params[:act_pass]
        nueva= params[:new_pass]
        confirmacion= params[:confirmation_pass]
        ok=true
        if (act.blank? || nueva.blank? || confirmacion.blank?)
            flash.alert="No puede dejar campos vacíos"
            ok=false
        else
            if (act.length < 8 || nueva.length < 8 || confirmacion.length < 8)
                flash.alert="La contraseña debe tener un mínimo de 8 caracteres"
                ok=false
            else
                if (act != @editor.password)
                    flash.alert="La contraseña actual es incorrecta"
                    ok=false
                elsif (nueva != confirmacion)
                    flash.alert="La nueva contraseña y la de confirmación no coinciden"
                    ok=false
                end
            end
        end
        if !ok
            redirect_to edit_pass_path
        end
    end
end

class EditionController < ApplicationController
    before_action :validar_formatos, only: [:pedirPass]
    before_action :comprobar_pass, only: [:update]

    def identificar
        if usuario_logueado?
            @editor= usuario_actual
        elsif sup_logueado?
            @editor= sup_actual
        elsif admin_logueado?
            @editor= admin_actual
        end
    end

    def edit
        identificar
    end

    def validar_formatos
       dni= params[:dni]
       fecha= params[:fecha_nacimiento]
       ok=true
       if dni.blank?
           flash.notice="El DNI no puede estar vacío"
           ok=false
       else
           ok= dni=~/\A\d+\Z/
           if !(dni.length >=7 && dni.length <=8 && !ok.nil?)
               flash.notice="El DNI debe estar compuesto por 7 u 8 números"
               ok=false
           else
                identificar
                if !(Usuario.where(dni:dni).where.not(global_id:@editor.global_id).empty? && Sup.where(dni:dni).where.not(global_id:@editor.global_id).empty? && Admin.where(dni:dni).where.not(global_id:@editor.global_id).empty?)
                    flash.notice="El DNI ya se encuentra registrado en el sistema"
                    ok=false
                end
           end
       end
       if !fecha.present?
           flash.alert="La fecha no puede estar vacía"
           ok=false
       end
       if !ok
           redirect_to edit_perfil_path
       end
    end

    def pedirPass
        @dni= params[:dni]
        @fecha= params[:fecha_nacimiento]
        identificar
        @editor.dni= @dni
        @editor.fecha_nacimiento= @fecha
        if !@editor.changed?
            redirect_to @editor
        end
    end

    def comprobar_pass
        identificar
        pass= params[:password]
        ok=true
        if pass.blank?
            flash.alert="La contraseña no puede estar vacía"
            ok=false
        else
            if pass.length < 8
                flash.alert="La contraseña debe tener un mínimo de 8 caracteres"
                ok=false
            else
                if @editor.password != pass
                    flash.alert="La contraseña es incorrecta"
                    ok=false
                end
            end
        end
        
        if !ok
            @dni= params[:dni]
            @fecha= params[:fecha_nacimiento]
            render :pedirPass, status: :see_other
        end
    end

    def update
        if usuario_logueado?
            @usuario= usuario_actual
            viejo_dni= @usuario.dni
            if @usuario.update(dni:params[:dni],fecha_nacimiento:params[:fecha_nacimiento])
                if (viejo_dni != @usuario.dni)
                    global_id= "C"+@usuario.dni
                    @usuario.update(global_id:global_id)
                    session[:global_id]= global_id
                  end
                redirect_to @usuario, notice:"Edición exitosa de información"
            else
                redirect_to @usuario, alert: "Error al editar la información"
            end
        elsif sup_logueado?
            @sup= sup_actual
            viejo_dni= @sup.dni
            if @sup.update(dni:params[:dni],fecha_nacimiento:params[:fecha_nacimiento])
                if (viejo_dni != @sup.dni)
                    global_id= "S"+@sup.dni
                    @sup.update(global_id:global_id)
                    session[:global_id]= global_id
                  end
                redirect_to @sup, notice:"Edición exitosa de información"
            else
                redirect_to @sup, alert: "Error al editar la información"
            end
        elsif admin_logueado?
            @admin= admin_actual
            viejo_dni= @admin.dni
            if @admin.update(dni:params[:dni],fecha_nacimiento:params[:fecha_nacimiento])
                if (viejo_dni != @admin.dni)
                    global_id= "A"+@admin.dni
                    @admin.update(global_id:global_id)
                    session[:global_id]= global_id
                  end
                redirect_to @admin, notice:"Edición exitosa de información"
            else
                redirect_to @admin, alert: "Error al editar la información"
            end
        end
    end
end

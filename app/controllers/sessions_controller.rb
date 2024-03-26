class SessionsController < ApplicationController
    before_action :validar_campos, only: [:create]

    def new
    end

    def create
        dni= params[:dni]
        if Usuario.find_by(dni:dni)
            create_usuario
        elsif Sup.find_by(dni:dni)
            create_supervisor
        elsif Admin.find_by(dni:dni)
            create_administrador
        else
            redirect_to login_path, alert:"El DNI no se encuentra registrado en el sistema"
        end
    end

    def create_usuario
        @usuario= Usuario.find_by(dni:params[:dni])
        if @usuario.password==params[:password]
            session[:global_id]=@usuario.global_id
            #redirect_to usuarios_path
            redirect_to root_path
        else
            redirect_to login_path, alert:"El DNI y la contraseña no coinciden"
        end
    end
    

    def create_supervisor
        @sup= Sup.find_by(dni:params[:dni])
        if @sup.password==params[:password]
            session[:global_id]=@sup.global_id
            #redirect_to sups_path
            redirect_to root_path
        else
            redirect_to login_path, alert:"El DNI y la contraseña no coinciden"
        end
    end

    def create_administrador
        @admin= Admin.find_by(dni:params[:dni])
        if @admin.password==params[:password]
            session[:global_id]=@admin.global_id
            #redirect_to admins_path
            redirect_to root_path
        else
            redirect_to login_path, alert:"El DNI y la contraseña no coinciden"
        end
    end

    def validar_campos
        dni= params[:dni]
        password= params[:password]
        ok=true
        if dni.blank?
            flash.notice="El DNI no puede estar vacío"
            ok=false
        else
            ok= dni=~/\A\d+\Z/
            if !(dni.length >=7 && dni.length <=8 && !ok.nil?)
                flash.notice="El DNI debe estar compuesto por 7 u 8 números"
                ok=false
            end
        end
        if password.blank?
            flash.alert="La contraseña no puede estar vacía"
            ok=false
        else
            if password.length < 8
                flash.alert="La contraseña debe tener un mínimo de 8 caracteres"
                ok=false
            end
        end
        if !ok
            redirect_to login_path
        end
    end

    def destroy
        session[:global_id]=nil
        if session[:auto_id] != nil
            session[:auto_id]=nil
        end
        redirect_to login_path
    end
end
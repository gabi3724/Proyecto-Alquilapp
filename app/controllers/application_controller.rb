class ApplicationController < ActionController::Base
    helper_method :usuario_actual
    helper_method :usuario_logueado?
    helper_method :alquiler_actual
    helper_method :alquilando?
    helper_method :sup_actual
    helper_method :sup_logueado?
    helper_method :admin_actual
    helper_method :admin_logueado?
    helper_method :vencio_tarjeta
    helper_method :vencio_documento
    helper_method :vencio_licencia
    helper_method :verificar_documentos_usuario
    
    def usuario_actual
        Usuario.find_by(global_id: session[:global_id])
    end

    def usuario_logueado?   
        !usuario_actual.nil?
    end

    def alquiler_actual
        Alquiler.find_by(usuario_id: usuario_actual.id)
    end

    def alquilando?
        if usuario_logueado?
            !usuario_actual.alquiler.nil?
        end
    end

    def sup_actual
        Sup.find_by(global_id: session[:global_id])
    end

    def sup_logueado?
        !sup_actual.nil?
    end

    def admin_actual
        Admin.find_by(global_id: session[:global_id])
    end

    def admin_logueado?
        !admin_actual.nil?
    end

    def verificar_logueado
        if !(usuario_logueado? || sup_logueado? || admin_logueado?)
            redirect_to login_path
        end
    end

    def verificar_autorizacion_admin
        if !admin_logueado?
            redirect_to unauthorized_path
        end
    end

    def verificar_autorizacion_sup
        if !sup_logueado?
            redirect_to unauthorized_path
        end
    end

    def verificar_autorizacion_usuario
        if !usuario_logueado?
            redirect_to unauthorized_path
        end
    end

    def verificar_autorizacion_sup_admin
        if !(sup_logueado? || admin_logueado?)
            redirect_to unauthorized_path
        end
    end

    def vencio_tarjeta(usuario)
        usuario.card.fecha_vencimiento < Date.today
    end

    def vencio_documento(usuario)
        usuario.doc.vencimiento < Date.today
    end

    def vencio_licencia(usuario)
        usuario.lic.vencimiento < Date.today
    end

    def verificar_documentos_usuario
        if usuario_logueado?
            usuario= usuario_actual
            if vencio_documento(usuario) || vencio_licencia(usuario)
                usuario.update(validado:false)
                redirect_to usuario_path(usuario),notice:"Vencieron uno o ambos de tus documentos necesarios para alquilar"
            end
        end
    end
end
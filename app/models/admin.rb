class Admin < ApplicationRecord
    validate :existencia_longitud_formato_dni
    validate :unicidad_dni , on: :create
    validate :unicidad_dni_actualizar, on: :update
    validates_presence_of :fecha_nacimiento, message: "La fecha de nacimiento no puede estar vacía"
    validate :existencia_longitud_password

    def existencia_longitud_formato_dni
        if dni.blank?
            errors.add(:dni, message:"El DNI no puede estar vacío")
        else
            ok= dni=~/\A\d+\Z/
            if !(dni.length >=7 && dni.length <=8 && !ok.nil?)
                errors.add(:dni, message:"El DNI debe estar compuesto por 7 u 8 números")
            end
        end
    end

    def existencia_longitud_password
        if password.blank?
            errors.add(:password, message:"La contraseña no puede estar vacía")
        else
            if password.length < 8
                errors.add(:password, message: "La contraseña debe tener un mínimo de 8 caracteres")
            end
        end
    end
    
    def unicidad_dni
        if Usuario.find_by(dni:dni) || Sup.find_by(dni:dni) || Admin.find_by(dni:dni)
            errors.add(:dni, message: "El DNI ya se encuentra registrado en el sistema")
        end
    end

    def unicidad_dni_actualizar
        if !(Usuario.where(dni:dni).where.not(global_id:global_id).where.not(id:id).empty? && Sup.where(dni:dni).where.not(global_id:global_id).where.not(id:id).empty? && Admin.where(dni:dni).where.not(global_id:global_id).where.not(id:id).empty?)
            errors.add(:dni, message: "El DNI ya se encuentra registrado en el sistema")
        end
    end
end

class Problema < ApplicationRecord
    has_one_attached :foto
    belongs_to :auto, optional:true
    belongs_to :sup, optional:true

    validate :descripcion_presente
    validate :foto_presente
    validates :foto, content_type: ['image/png','image/jpeg']

    def descripcion_presente
        if descripcion.blank?
            errors.add(:base, message: "Debe explicar el problema que tuvo")
        end
    end

    def foto_presente
        if !foto.attached?
            errors.add(:foto, message: "Debe subir una foto del problema")
        end       
    end

end

class Auto < ApplicationRecord
    has_one_attached :foto
    has_one :alquiler
    has_many :incidences, dependent: :destroy
    has_many :problemas, dependent: :destroy

    validate :formato_patente
    validates_uniqueness_of :patente, message:"La patente ya se encuentra registrada en el sistema"
    validate :campos_presentes
    validate :foto_presente
    validates :foto, content_type: ['image/png','image/jpeg']
    validate :autonomia_formato

    def campos_presentes
        if patente.blank? || marca.blank? || modelo.blank? || color.blank? || autonomia.blank? || como_cargar.blank?
            errors.add(:base, message: "No pueden haber campos sin completar")
        end
    end

    def foto_presente
        if !foto.attached?
            errors.add(:foto, message: "Debe subir una foto del auto")
        end       
    end

    def formato_patente
        if !patente.blank?
            if !(patente=~/\A[A-Z]{2}\d{3}[A-Z]{2}\Z/)
                errors.add(:patente, message:"Patente con formato erróneo")
            end
        end
    end

    def autonomia_formato
        if !autonomia.blank?
            if !(autonomia=~/\A\d+\Z/)
                errors.add(:autonomia,message:"La autonomía debe ser un número")
            else
                if (autonomia.to_i == 0)
                    errors.add(:autonomia,message:"La autonomía no puede ser cero")
                end
            end
        end
    end
end

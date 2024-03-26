class Doc < ApplicationRecord
    has_one_attached :foto

    belongs_to :usuario

    enum :estado, [:en_revision, :rechazado, :aceptado]

    validate :foto_presente
    validates :foto, content_type: ['image/png','image/jpeg']

    def foto_presente
        if !foto.attached?
            errors.add(:foto, message: "Debe subir una imagen")
        end       
    end
end

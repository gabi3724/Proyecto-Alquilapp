class Incidence < ApplicationRecord
  has_one_attached :foto
  belongs_to :auto

  validate :foto_presente
  validate :descripcion_presente
  validates :foto, content_type: ['image/png','image/jpeg']

  def foto_presente
    if !foto.attached?
        errors.add(:foto, message: "Debe subir una foto del auto")
    end       
  end

  def descripcion_presente
    if descripcion.blank?
      errors.add(:descripcion, message: "La descripción no puede estar vacía")
    end
  end

end

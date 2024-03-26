class Alquiler < ApplicationRecord
    belongs_to :usuario
    belongs_to :auto
end
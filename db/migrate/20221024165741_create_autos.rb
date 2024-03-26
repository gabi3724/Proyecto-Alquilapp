class CreateAutos < ActiveRecord::Migration[7.0]
  def change
    create_table :autos do |t|
      t.string :patente
      t.string :marca
      t.string :modelo
      t.string :color
      t.string :tipo_de_caja
      t.string :tipo_de_motor
      t.string :autonomia
      t.text :como_cargar
      t.integer :porcentaje_tanque
      t.boolean :encendido, default: false
      t.boolean :alquilado, default: false
      t.point :ubicacion

      t.timestamps
    end
  end
end

class CreateSups < ActiveRecord::Migration[7.0]
  def change
    create_table :sups do |t|
      t.string :global_id
      t.string :dni
      t.datetime :fecha_nacimiento
      t.string :password
      t.integer :auto_id
      t.string :nombre_completo
      t.point :ubicacion

      t.timestamps
    end
  end
end

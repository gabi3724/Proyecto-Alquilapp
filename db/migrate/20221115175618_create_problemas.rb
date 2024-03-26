class CreateProblemas < ActiveRecord::Migration[7.0]
  def change
    create_table :problemas do |t|
      t.text :descripcion
      t.integer :auto_id
      t.integer :sup_id
      t.string :sup_dni
      t.boolean :resuelto, default: false

      t.timestamps
    end
  end
end

class CreateAlquilers < ActiveRecord::Migration[7.0]
  def change
    create_table :alquilers do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :auto, null: false, foreign_key: true
      t.decimal :costo
      t.integer :horas

      t.timestamps
    end
  end
end

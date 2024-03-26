class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :numero
      t.string :codigo
      t.string :titular
      t.datetime :fecha_vencimiento
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateCancelados < ActiveRecord::Migration[7.0]
  def change
    create_table :cancelados do |t|
      t.string :motivo
      t.string :patente
      t.references :usuario, null: false

      t.timestamps
    end
  end
end

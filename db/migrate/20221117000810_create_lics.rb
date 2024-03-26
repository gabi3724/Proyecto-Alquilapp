class CreateLics < ActiveRecord::Migration[7.0]
  def change
    create_table :lics do |t|
      t.string :descripcion
      t.integer :estado
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :global_id
      t.string :dni
      t.datetime :fecha_nacimiento
      t.string :password
      t.integer :auto_id
      t.integer :creditos
      t.boolean :validado, default: false
      t.string :nombre_completo

      t.timestamps
    end
  end
end

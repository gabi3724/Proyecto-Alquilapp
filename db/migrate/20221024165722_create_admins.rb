class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :global_id
      t.string :dni
      t.datetime :fecha_nacimiento
      t.string :password

      t.timestamps
    end
  end
end

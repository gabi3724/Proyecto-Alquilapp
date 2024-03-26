class ChangeAlquilers < ActiveRecord::Migration[7.0]
  def change
    add_column :alquilers, :porcentaje_tanque_inicial, :integer
  end
end

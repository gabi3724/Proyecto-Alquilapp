class AgregarFueEncendidoAAlquilers < ActiveRecord::Migration[7.0]
  def change
    add_column :alquilers, :fue_encendido, :boolean
  end
end

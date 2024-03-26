class AgregarFechaUltimoAlquiler < ActiveRecord::Migration[7.0]
  def change
    add_column :usuarios, :fecha_ultimo_alquiler, :datetime
  end
end

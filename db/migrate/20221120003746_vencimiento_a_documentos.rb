class VencimientoADocumentos < ActiveRecord::Migration[7.0]
  def change
    add_column :lics, :vencimiento, :datetime
    add_column :docs, :vencimiento, :datetime
  end
end

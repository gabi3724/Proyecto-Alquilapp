class CambiosAUsuarios < ActiveRecord::Migration[7.0]
  def change
    add_column :usuarios, :en_revision, :boolean
  end
end

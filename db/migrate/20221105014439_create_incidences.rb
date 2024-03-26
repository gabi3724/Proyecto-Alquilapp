class CreateIncidences < ActiveRecord::Migration[7.0]
  def change
    create_table :incidences do |t|
      t.text :descripcion
      t.references :auto

      t.timestamps
    end
  end
end

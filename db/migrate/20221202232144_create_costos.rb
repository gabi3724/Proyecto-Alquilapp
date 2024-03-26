class CreateCostos < ActiveRecord::Migration[7.0]
  def change
    create_table :costos do |t|
      t.integer :combustible
      t.integer :alquiler

      t.timestamps
    end
  end
end

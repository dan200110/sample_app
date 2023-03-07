class CreateImportInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :import_inventories do |t|
      t.string :name
      t.float :price
      t.integer :quantity
      t.references :batch_inventory
      t.date :date
      t.string :import_inventory_code
      t.references :inventory
      t.references :supplier
      t.references :branch

      t.timestamps
    end
  end
end

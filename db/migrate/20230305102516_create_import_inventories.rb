class CreateImportInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :import_inventories do |t|
      t.string :name
      t.float :price
      t.integer :quantity
      t.integer :status
      t.date :date
      t.string :import_inventory_code
      t.references :batch_inventory
      t.references :inventory
      t.references :supplier
      t.references :branch

      t.timestamps
    end
  end
end

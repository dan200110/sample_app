class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string :name
      t.float :price
      t.integer :inventory_type
      t.integer :quantity
      t.references :category
      t.references :batch_inventory

      t.timestamps
    end
  end
end

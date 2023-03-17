class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string :name
      t.float :price
      t.integer :inventory_type, default: 0
      t.integer :quantity, default: 0
      t.string :inventory_code
      t.string :main_ingredient
      t.string :producer
      t.references :category
      t.references :batch_inventory
      t.references :supplier
      t.references :branch

      t.timestamps
    end
  end
end

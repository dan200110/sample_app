class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string :name
      t.float :price
      t.integer :inventory_type
      t.integer :quantity
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

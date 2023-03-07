class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.integer :total_quantity
      t.integer :status
      t.string :order_code
      t.date :date
      t.references :inventory
      t.references :branch
      t.timestamps
    end
  end
end

class CreateBatchInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :batch_inventories do |t|
      t.string :batch_code
      t.date :expired_date
      t.timestamps
    end
  end
end

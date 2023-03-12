class CreateSuppliers < ActiveRecord::Migration[6.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :contact
      t.string :email
      t.string :address
      t.timestamps
    end
  end
end

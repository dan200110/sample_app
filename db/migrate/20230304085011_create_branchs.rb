class CreateBranchs < ActiveRecord::Migration[6.1]
  def change
    create_table :branchs do |t|
      t.string :name
      t.string :address
      t.string :branch_code
      t.timestamps
    end
  end
end

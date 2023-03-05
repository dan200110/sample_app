class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password_digest
      t.timestamps
      t.string :remember_digest
      t.references :branch
    end
  end
end

class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password_digest
      t.timestamps
    end
  end
end

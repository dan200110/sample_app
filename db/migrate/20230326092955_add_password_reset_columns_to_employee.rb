class AddPasswordResetColumnsToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :reset_password_token, :string
    add_column :employees, :reset_password_sent_at, :datetime
  end
end

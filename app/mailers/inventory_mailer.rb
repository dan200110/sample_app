class InventoryMailer < ApplicationMailer
  def send_request_mail_to_supplier inventory
    @branch = inventory.branch
    @supplier = inventory.supplier
    @inventory = inventory
    mail to: @supplier.email, subject: "need more inventory"
  end
end

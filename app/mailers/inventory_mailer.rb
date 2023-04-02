class InventoryMailer < ApplicationMailer
  def send_request_mail_to_supplier inventory
    @branch = inventory.branch
    @supplier = inventory.supplier

    return unless @supplier&.email.present?
    @inventory = inventory
    mail to: @supplier.email, from: @branch.email, subject: "need more inventory"
  end
end

class BranchMailer < ApplicationMailer
  def send_daily_expired(branch, inventories)
    @branch = branch
    @inventories = inventories

    return unless @branch&.email.present?
    mail to: @branch.email, subject: "send daily expired mail to branch"
  end

  def send_daily_out_of_stock(branch, inventories)
    @branch = branch
    @inventories = inventories

    return unless @branch&.email.present?
    mail to: @branch.email, subject: "send daily out of stock mail to branch"
  end
end

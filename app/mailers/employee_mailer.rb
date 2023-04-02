class EmployeeMailer < ApplicationMailer
  def password_reset employee
    @employee = employee
    mail to: employee.email, subject: "Password Reset"
  end
end

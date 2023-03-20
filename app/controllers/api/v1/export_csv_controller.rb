require "csv"

module Api
  module V1
    class ExportCsvController < Base
      def export_employee
        @employees = Employee.all
        header = ["Full Name", "Email", "Branch"]

        result = CSV.generate do |csv|
          csv << header
          @employees.each do |employee|
            csv << [employee.name, employee.email, employee.branch.name]
          end
        end

        send_data(result, filename: "employees.csv", type: "text/csv", disposition: 'attachment')
      end

      def export_inventory
        @inventories = Inventory.search_by_branch(params["branch_id"])
        header = ["Name", "inventory code", "quantity", "price", "inventory_type", "main_ingredient", "producer", "category", "batch inventory", "supplier", "branch"]

        result = CSV.generate do |csv|
          csv << header
          @inventories.each do |inventory|
            csv << [inventory.name, inventory.inventory_code, inventory.quantity, inventory.price, inventory.inventory_type,
                      inventory.main_ingredient, inventory.producer, inventory.category.name, inventory.batch_inventory.batch_code, inventory.supplier.name, inventory.branch.name]
          end
        end

        send_data(result, filename: "inventories.csv", type: "text/csv", disposition: 'attachment')
      end
    end
  end
end

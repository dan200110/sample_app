module Api
  module V1
    class EmployeesController < Base
      before_action :authenticate_employee!, except: %i(create)
      before_action :find_employee, except: %i(create index)
      before_action :correct_employee, only: %i(update)
      before_action :admin_employee, only: %i(destroy)

      def index
        @employees = Employee.all
        render json: {
          data: ActiveModelSerializers::SerializableResource.new(@employees, each_serializer: EmployeeSerializer),
          message: ["employee list fetched successfully"],
          status: 200,
          type: "Success",
        }
      end

      def show
        render json: @current_employee.as_json(
          except: :id,
          include: { branch: { except: %i[id] } }
        ), status: :ok
      end

      def update
        if @employee.update! employee_params
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@employee, serializer: EmployeeSerializer),
            message: ["employee update fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @employee, status: :updated, location: @employee
        end
      end

      def destroy
        if @employee.destroy!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@employee, serializer: EmployeeSerializer),
            message: ["employee destroy fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @employee, status: :deleted, location: @employee
        end
      end

      def create
        @employee = Employee.new employee_params
        if @employee.save!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@employee, serializer: EmployeeSerializer),
            message: ["employee create fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @employee, status: :created, location: @employee
        end
      end

      private

      def employee_params
        params.permit(Employee::EMPLOYEE_ATTRS)
      end

      def find_employee
        @employee = Employee.find_by! id: params[:id]
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end

      def correct_employee
        return if @current_employee == @employee

        render json: {
          message: ["Not correct employee"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end

      def admin_employee
        return if @current_employee.admin?

        render json: {
          message: ["Not admin"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end
    end
  end
end

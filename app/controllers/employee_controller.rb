class EmployeeController < ApplicationController
  protect_from_forgery except: :update_on_same_page
  def index
    @employees = get_all_employees
  end

  def update_on_same_page 
    employee_id = params[:id]
    @employee = get_employee_with_give_id(employee_id)
    @departments_name= get_all_departments_name
    respond_to do |format|
      format.js {render layout: false}
    end
  end  
  def edit_department
    # This method is not used and if we used then will get error as we converted view of this method to partial.
    employee_id = params[:id]
    if employee_id.present?
      begin
        @employee = get_employee_with_give_id(employee_id)
        @departments_name= get_all_departments_name
      rescue Exceptions::EmployeeNotFound => e
        # showing error with message
        @error_message = e.message
        render 'layouts/_errors'
      end 
      
    end  
  end

  def update_department
    employee_id = params[:employee_id]
    if employee_id.present?
      begin
        @employee = get_employee_with_give_id(employee_id)
        @employee.update_department(params[:department_name])
        @employee.save
        # return success notice    
        redirect_to root_path, flash: { message: "Department Updated sucessfully for Employee with ID #{ @employee.id } !"} 
      rescue Exceptions::DepartmentNotFound, Exceptions::EmployeeNotFound => e
        # showing error with message
        @error_message = e.message
        render 'layouts/_errors'
      end
    end  
  end


  private 

  def get_all_employees
    # Eager loading of department data to avoid N+1 query
    EmployeeM.includes(:department)
  end

  def get_employee_with_give_id(employee_id)
    # Return  employee with given id
    # find_by used inisted of find to avoid ActiveRecord::RecordNotFound exception
    employee = EmployeeM.find_by(id: employee_id)
    if employee.nil?
      raise Exceptions::EmployeeNotFound.new, "Employee with given ID #{employee_id} Not found."
    end
    employee
  end

  def get_all_departments_name
    # Return all departments information
    Department.all.map { |department| department.name }
  end
end

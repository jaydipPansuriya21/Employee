class EmployeeDepartment < ApplicationRecord
    belongs_to :employee_m
    belongs_to :department 
    
    # validations
    validates_presence_of :department_id, :employee_m_id
end

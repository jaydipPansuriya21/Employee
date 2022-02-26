class Department < ApplicationRecord
    has_many :employee_departments
    has_many :employee_ms, through: :employee_departments

    # validation
    validates_presence_of :name
end

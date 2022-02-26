class CreateEmployeeDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_departments do |t|
      t.integer :employee_m_id
      t.integer :department_id
      t.timestamps
    end
  end
end

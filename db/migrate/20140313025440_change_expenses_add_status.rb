class ChangeExpensesAddStatus < ActiveRecord::Migration
  def change
    add_column :expenses, :status, :string, :default => 'not reimbursed'
    remove_column :expenses, :is_reimbursed
  end
end

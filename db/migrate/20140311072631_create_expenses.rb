class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :user, index: true
      t.references :expense_type, index: true
      t.string :description
      t.date :date
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :currency
      t.boolean :is_reimbursed

      t.timestamps
    end
  end
end

class RemovePassDigestFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :pass_digest, :string
  end
end

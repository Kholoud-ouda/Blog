class RemoveUserToComments < ActiveRecord::Migration[5.1]
  def change
    remove_reference :comments, :user, index: true, foreign_key: true
  end
end

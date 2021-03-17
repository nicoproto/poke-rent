class UpdateChatroomAttributes < ActiveRecord::Migration[6.0]
  def change
    remove_column :chatrooms, :name
    add_reference :chatrooms, :booking, index: true
  end
end

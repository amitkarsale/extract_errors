class AddIndexToErrorMessage < ActiveRecord::Migration[5.0]
  def change
  	add_index :errors, :message, :length => 255
  end
end

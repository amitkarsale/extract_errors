class CreateError < ActiveRecord::Migration[5.0]
  def up
  	create_table :errors do |t|
  		t.text :message
  		t.datetime :occured_at
  		t.string :case_number
  		t.timestamps
  	end
  end

  def down
  	drop_table :errors
  end
end

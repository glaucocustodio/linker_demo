class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :district

      t.references :user, index: true
      
      t.timestamps
    end
  end
end

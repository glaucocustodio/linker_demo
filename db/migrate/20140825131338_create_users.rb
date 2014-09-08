class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.references :company, index: true
      t.references :my_family, index: true

      t.timestamps
    end
  end
end

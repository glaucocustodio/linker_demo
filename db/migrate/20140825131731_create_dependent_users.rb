class CreateDependentUsers < ActiveRecord::Migration
  def change
    create_table :dependent_users do |t|
      t.string :name
      t.date :date_birth
      t.references :user, index: true

      t.timestamps
    end
  end
end

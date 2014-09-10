class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :profile_type
      t.references :user, index: true

      t.timestamps
    end
  end
end

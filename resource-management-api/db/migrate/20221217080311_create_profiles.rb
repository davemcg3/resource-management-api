class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.references :workgroup, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end

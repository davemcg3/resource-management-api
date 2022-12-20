class CreateWorkgroups < ActiveRecord::Migration[7.0]
  def change
    create_table :workgroups do |t|
      t.string :name
    end
  end
end

class CreateJoinTableProfileUser < ActiveRecord::Migration[7.0]
  def change
    create_join_table :profiles, :users do |t|
      t.index [:profile_id, :user_id]
      t.index [:user_id, :profile_id]
    end
  end
end

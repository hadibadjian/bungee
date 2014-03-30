class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :release_note
      t.integer :user_id

      t.timestamps
    end
  end
end

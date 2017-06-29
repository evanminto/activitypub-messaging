class CreateUserSessions < ActiveRecord::Migration
  def self.change
    create_table :user_sessions do |t|
      t.string :session_id, null: false, index: true
      t.text :data
      t.timestamps
    end

    add_index :user_sessions, :updated_at
  end
end

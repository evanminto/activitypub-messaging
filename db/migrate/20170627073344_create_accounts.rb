class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username, index: true
      t.string :display_name
      t.string :activitystreams2_url, index: true
      t.string :profile_url
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end

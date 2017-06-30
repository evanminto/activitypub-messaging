class CreateMessageAddressees < ActiveRecord::Migration
  def change
    create_table :message_addressees do |t|
      t.belongs_to :message, index: true
      t.belongs_to :account, index: true
      t.string :target_type

      t.timestamps
    end
  end
end

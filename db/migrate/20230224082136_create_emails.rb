class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.bigint :server_id
      t.string :address

      t.timestamps null: false
    end
    add_index :emails, :server_id
  end
end

class CreateIpMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :ip_mappings do |t|
      t.integer :ip_id
      t.integer :server_id

      t.timestamps
    end
  end
end

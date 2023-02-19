class AddLocationToIps < ActiveRecord::Migration[7.0]
  def change
    add_column :ips, :location, :text
  end
end

class AddPureIpToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :pure_ip, :string
  end
end

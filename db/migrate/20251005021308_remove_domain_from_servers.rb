class RemoveDomainFromServers < ActiveRecord::Migration[7.2]
  def change
    remove_column :servers, :domain
  end
end

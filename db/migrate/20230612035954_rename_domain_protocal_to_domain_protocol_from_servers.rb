class RenameDomainProtocalToDomainProtocolFromServers < ActiveRecord::Migration[7.0]
  def change
    rename_column :servers, :domain_protocal, :domain_protocol
  end
end

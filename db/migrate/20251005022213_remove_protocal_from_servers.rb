class RemoveProtocalFromServers < ActiveRecord::Migration[7.2]
  def change
    remove_column :servers, :protocal
  end
end

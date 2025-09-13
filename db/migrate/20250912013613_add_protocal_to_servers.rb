class AddProtocalToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :protocal, :string, default: nil, comment: "http 或者 https"
  end
end

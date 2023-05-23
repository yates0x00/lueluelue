class AddIsStaredToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_stared, :boolean, default: false
  end
end

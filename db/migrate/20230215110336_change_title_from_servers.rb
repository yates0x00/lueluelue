class ChangeTitleFromServers < ActiveRecord::Migration[7.0]
  def change
    change_column :servers, :title, :text
  end
end

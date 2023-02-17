class AddLevelToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :level, :integer, comment: 'level 0 is the most important'
  end
end

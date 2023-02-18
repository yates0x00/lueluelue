class AddTheHarvesterResultToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :the_harvester_result, :longtext
  end
end

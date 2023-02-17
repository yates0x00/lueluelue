class AddWappalyzerResultToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :wappalyzer_result, :text
  end
end

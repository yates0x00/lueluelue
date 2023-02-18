class AddNucleiResultsToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :nuclei_https_result, :longtext
    add_column :servers, :nuclei_http_result, :longtext
    add_column :servers, :nuclei_manual_result, :longtext
  end
end

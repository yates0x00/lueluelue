class ChangeWpsScanType < ActiveRecord::Migration[7.2]
  def change
    change_column :servers, :wpscan_result, :text, limit: 16.megabytes
  end
end

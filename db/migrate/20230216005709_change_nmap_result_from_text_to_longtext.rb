class ChangeNmapResultFromTextToLongtext < ActiveRecord::Migration[7.0]
  def change
    change_column :ips, :nmap_result, :longtext
  end
end

class AddIsDetectedByNmapToIps < ActiveRecord::Migration[7.2]
  def change
    add_column :ips, :is_detected_by_nmap, :boolean
  end
end

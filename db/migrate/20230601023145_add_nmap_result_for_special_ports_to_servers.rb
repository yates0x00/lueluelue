class AddNmapResultForSpecialPortsToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :nmap_result_for_special_ports, :text
  end
end

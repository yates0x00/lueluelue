class AddMaxServerityInNucleiResultToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :max_severity_in_nuclei_result, :integer, default: nil
  end
end

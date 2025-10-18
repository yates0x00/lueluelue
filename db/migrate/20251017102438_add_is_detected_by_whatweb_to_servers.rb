class AddIsDetectedByWhatwebToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_detected_by_whatweb, :boolean, comment: 'is detected by whatweb'
    add_index :servers, :is_detected_by_whatweb
  end
end

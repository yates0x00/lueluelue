class AddIsDetectedByDirsearchToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_detected_by_dirsearch, :boolean, default: false, comment: 'is detected by dirsearch'
    add_column :servers, :dirsearch_result, :text
  end
end

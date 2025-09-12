class AddNmapResultAndIsDetectedByNmapToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_detected_by_nmap, :boolean, default: false, comment: '是否被nmap檢測過'
    add_column :servers, :nmap_result, :text, comment: 'nmap掃描結果'
  end
end

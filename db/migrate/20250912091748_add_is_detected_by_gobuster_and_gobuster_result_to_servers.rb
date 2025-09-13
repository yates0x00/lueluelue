class AddIsDetectedByGobusterAndGobusterResultToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_detected_by_gobuster, :boolean, comment: '是否被gobuster检查过'
    add_column :servers, :gobuster_result, :text, comment: 'gobuster的结果'
  end
end

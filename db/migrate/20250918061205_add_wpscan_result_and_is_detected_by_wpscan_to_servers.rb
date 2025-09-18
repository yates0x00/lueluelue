class AddWpscanResultAndIsDetectedByWpscanToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_detected_by_wpscan, :boolean, comment: '是否被wpscan检测过'
    add_column :servers, :wpscan_result, :text, comment: 'wpscan结果'
  end
end

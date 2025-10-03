class AddIsDetectedByFofaToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_detected_by_fofa, :boolean, comment: '是否在fofa上检测了'
  end
end

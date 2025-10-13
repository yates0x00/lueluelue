class AddIsNeedToFetchFromFofaToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_need_to_fetch_from_fofa, :boolean, default: true, comment: '是否需要从fofa 手动抓取数据, 仅用于该数据量很大，或者已经抓取过了'
  end
end

class AddIsToQueryFofaByConditionsToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :is_to_query_fofa_by_main_domain, :boolean, default:true, comment: '是否查询 host="a.com"'
    add_column :servers, :is_to_query_fofa_by_base_name, :boolean, default:true, comment: '是否查询 host*="*.a.*"'
    add_column :servers, :is_to_query_fofa_by_icon_hash, :boolean, default:true, comment: '是否查询 icon_hash="1234"'

  end
end

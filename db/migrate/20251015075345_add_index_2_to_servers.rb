class AddIndex2ToServers < ActiveRecord::Migration[7.2]
  def change
    add_index :servers, :is_need_to_fetch_from_fofa
    add_index :servers, :is_to_query_fofa_by_main_domain
    add_index :servers, :is_to_query_fofa_by_base_name
    add_index :servers, :is_to_query_fofa_by_icon_hash
  end
end

class AddFaviconHashOfFofaToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :favicon_hash_of_fofa_result, :string
    add_column :servers, :is_detected_by_favihunter, :boolean
  end
end

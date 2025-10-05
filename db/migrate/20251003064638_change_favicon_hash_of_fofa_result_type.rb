class ChangeFaviconHashOfFofaResultType < ActiveRecord::Migration[7.2]
  def change
    change_column :servers, :favicon_hash_of_fofa_result, :text
  end
end

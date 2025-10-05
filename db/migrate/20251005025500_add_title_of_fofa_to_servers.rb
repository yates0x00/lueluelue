class AddTitleOfFofaToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :title_of_fofa, :text, comment: 'fofa的title'
  end
end

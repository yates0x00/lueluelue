class AddFaviconHashOfFofaAndFaviconUrlToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :favicon_hash_of_fofa, :string, comment: 'favicon_hash, of fofa, MMH3'
    add_column :servers, :favicon_url, :string, comment: 'favicon url, e.g. http://a.com/favicon.ico  http://b.com/logo.jpg'
  end
end

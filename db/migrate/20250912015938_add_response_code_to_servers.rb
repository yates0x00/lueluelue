class AddResponseCodeToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :response_code, :integer, default: nil , comment: '服务器返回码，200, 301, 404 ..'
  end
end

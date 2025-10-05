class AddWhatwebResultToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :whatweb_result, :text, comment: 'whatweb result'
  end
end

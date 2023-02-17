class AddTitleToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :title, :string
    add_column :servers, :os_type, :string
    add_column :servers, :web_server, :string
    add_column :servers, :web_framework, :string
    add_column :servers, :web_language, :string
    add_column :servers, :observer_ward_result, :text
    add_column :servers, :ehole_result, :text
  end
end

class AddIsServerMaybeDownToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_server_maybe_down, :boolean, default: false, comment: 'maybe this server is down? (80, 443 port closed? )'
  end
end

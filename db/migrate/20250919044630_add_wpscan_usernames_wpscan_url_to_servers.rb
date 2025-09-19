class AddWpscanUsernamesWpscanUrlToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :wpscan_usernames, :string, comment: 'wordpress用户名，给wpscan爆破用'
    add_column :servers, :wpscan_url, :string, comment: 'wpscan 最终探测的url'
  end
end

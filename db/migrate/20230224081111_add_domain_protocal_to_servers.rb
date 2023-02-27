class AddDomainProtocalToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :domain_protocal, :string, comment: '可以用的值: http/https', default: 'https'
  end
end

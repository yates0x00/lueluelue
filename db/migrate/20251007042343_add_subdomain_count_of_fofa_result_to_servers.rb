class AddSubdomainCountOfFofaResultToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :subdomain_count_main_domain_of_fofa_result, :integer, comment: 'fofa下查询到的子域名记录, 例如 a.com'
    add_column :servers, :subdomain_count_base_name_of_fofa_result, :integer, comment: 'fofa下查询到的子域名记录, 例如 domain*="*.a.*"'
    add_column :servers, :subdomain_count_favicon_of_fofa_result, :integer, comment: 'fofa下查询到的子域名记录, 例如： favicon=-11100011'

    add_index :servers, :subdomain_count_main_domain_of_fofa_result 
    add_index :servers, :subdomain_count_base_name_of_fofa_result
    add_index :servers, :subdomain_count_favicon_of_fofa_result
  end
end

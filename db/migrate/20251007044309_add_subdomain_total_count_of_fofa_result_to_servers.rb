class AddSubdomainTotalCountOfFofaResultToServers < ActiveRecord::Migration[7.2]
  def change
    add_column :servers, :subdomain_total_count_of_fofa_result, :integer
  end
end

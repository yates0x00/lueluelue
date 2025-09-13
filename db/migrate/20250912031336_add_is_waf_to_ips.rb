class AddIsWafToIps < ActiveRecord::Migration[7.2]
  def change
    add_column :ips, :is_waf, :boolean, comment: '该IP是否是WAF的ip，例如cloudflare, cloudfront 的。是的话就没必要扫描了'
  end
end

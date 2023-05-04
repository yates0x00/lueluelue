class AddMaxSecuritySeverityToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :max_security_severity, :float, default: 0
  end
end

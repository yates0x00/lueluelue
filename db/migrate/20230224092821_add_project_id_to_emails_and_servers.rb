class AddProjectIdToEmailsAndServers < ActiveRecord::Migration[7.0]
  def change
    add_column :emails, :project_id, :bigint
    add_column :servers, :project_id, :bigint
    add_index :emails, :project_id
    add_index :servers, :project_id
  end
end

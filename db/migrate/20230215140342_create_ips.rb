class CreateIps < ActiveRecord::Migration[7.0]
  def change
    create_table :ips do |t|
      t.string :ip
      t.text :nmap_result

      t.timestamps
    end
  end
end

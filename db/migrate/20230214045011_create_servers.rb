class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :domain
      t.text :comment
      t.text :wafwoof_result
      t.text :dig_result

      t.timestamps
    end
  end
end

class CreateConfigItems < ActiveRecord::Migration[7.0]
  def change
    create_table :config_items do |t|
      t.string :name
      t.string :value
      t.string :comment

      t.timestamps
    end
  end
end

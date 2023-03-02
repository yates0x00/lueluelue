class CreateCClassNetworks < ActiveRecord::Migration[7.0]
  def change
    create_table :c_class_networks do |t|
      t.integer :project_id
      t.string :value
      t.text :shuize_result

      t.timestamps null: false
    end
    add_index :c_class_networks, :project_id
  end
end

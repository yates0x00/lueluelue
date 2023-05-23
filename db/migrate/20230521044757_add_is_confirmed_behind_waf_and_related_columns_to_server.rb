class AddIsConfirmedBehindWafAndRelatedColumnsToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_confirmed_behind_waf, :boolean
    add_column :servers, :is_confirmed_not_behind_waf, :boolean

    add_index :servers, :is_confirmed_behind_waf
    add_index :servers, :is_confirmed_not_behind_waf
  end
end

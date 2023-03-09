class AddIsDetectedByWafwoofResultAndOtherIsDetectedByColumnsToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_detected_by_wafwoof, :boolean, default: false
    add_column :servers, :is_detected_by_dig, :boolean, default: false
    add_column :servers, :is_detected_by_observer_ward, :boolean, default: false
    add_column :servers, :is_detected_by_ehole, :boolean, default: false
    add_column :servers, :is_detected_by_wappalyzer, :boolean, default: false
    add_column :servers, :is_detected_by_the_harvester, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_https, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_http, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_manual, :boolean, default: false
  end
end

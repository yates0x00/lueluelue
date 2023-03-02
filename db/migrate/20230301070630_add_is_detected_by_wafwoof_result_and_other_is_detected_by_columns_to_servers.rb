class AddIsDetectedByWafwoofResultAndOtherIsDetectedByColumnsToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :is_detected_by_wafwoof_result, :boolean, default: false
    add_column :servers, :is_detected_by_dig_result, :boolean, default: false
    add_column :servers, :is_detected_by_observer_ward_result, :boolean, default: false
    add_column :servers, :is_detected_by_ehole_result, :boolean, default: false
    add_column :servers, :is_detected_by_wappalyzer_result, :boolean, default: false
    add_column :servers, :is_detected_by_the_harvester_result, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_https_result, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_http_result, :boolean, default: false
    add_column :servers, :is_detected_by_nuclei_manual_result, :boolean, default: false
  end
end

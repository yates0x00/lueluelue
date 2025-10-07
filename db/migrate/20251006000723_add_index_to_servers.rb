class AddIndexToServers < ActiveRecord::Migration[7.2]
  def change
    add_index :servers, :name
    add_index :servers, :level
    add_index :servers, :domain_protocol
    add_index :servers, :is_detected_by_wafwoof 
    add_index :servers, :is_detected_by_dig 
    add_index :servers, :is_detected_by_observer_ward 
    add_index :servers, :is_detected_by_ehole 
    add_index :servers, :is_detected_by_wappalyzer 
    add_index :servers, :is_detected_by_the_harvester 
    add_index :servers, :is_detected_by_nuclei_https 
    add_index :servers, :is_detected_by_nuclei_http 
    add_index :servers, :is_detected_by_nuclei_manual 
    add_index :servers, :is_stared
    add_index :servers, :is_detected_by_dirsearch
    add_index :servers, :response_code
    add_index :servers, :is_detected_by_nmap
    add_index :servers, :is_detected_by_gobuster
    add_index :servers, :is_detected_by_wpscan
    add_index :servers, :is_detected_by_favihunter
    add_index :servers, :is_detected_by_fofa
  end
end

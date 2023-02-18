class Ip < ApplicationRecord
  has_many :ip_mappings
  has_many :servers, :through => :ip_mappings
end

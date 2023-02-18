class IpMapping < ApplicationRecord
  belongs_to :ip
  belongs_to :server
end

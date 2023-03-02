class Email < ApplicationRecord
  belongs_to :server
  belongs_to :project
end

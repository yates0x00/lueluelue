class Project < ApplicationRecord
  has_many :servers
  has_many :emails
end

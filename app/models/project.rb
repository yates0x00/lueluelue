class Project < ApplicationRecord
  has_many :servers
  has_many :emails
  has_many :c_class_network
end

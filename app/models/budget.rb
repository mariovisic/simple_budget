class Budget < ActiveRecord::Base
  has_many :transactions
end

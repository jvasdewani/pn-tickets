class ServiceAssignment < ActiveRecord::Base
  belongs_to :contract
  belongs_to :service
end

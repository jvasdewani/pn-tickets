class Contact < ActiveRecord::Base
  belongs_to :branch

  def full_name
    [forename, surname].join(' ')
  end
end

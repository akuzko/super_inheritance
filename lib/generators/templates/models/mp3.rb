class Mp3 < ActiveRecord::Base
  validates_numericality_of :ratio
  
  belongs_to :audio
end

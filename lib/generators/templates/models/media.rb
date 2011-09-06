class Media < ActiveRecord::Base
  acts_as_super
  
  belongs_to :user
  has_many :comments
  
  validates_presence_of :name, :user
  
  def foo
    :foo
  end
end

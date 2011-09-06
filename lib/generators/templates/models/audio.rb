class Audio < Media
  validates_presence_of :author
  
  has_many :mp3s
  
  def foo
    super.to_s
  end
  
  def bar
    :bar
  end
end

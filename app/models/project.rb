class Project
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name
  field :budget, type: Float, default: 0.0

  has_and_belongs_to_many :users
  has_many :epics


  def remove_user user
    self.users = (users - users.drop(users.index(user)))
    save
  end

  def stories
    epics.map(&:stories).
    flatten.
    compact
  end

  def spent
    stories.select {|story| story.status == 'completed'}.
    flatten.
    compact.
    map(&:estimate).
    sum
  end

  def points
    epics.map(&:points).compact.sum
  end
end

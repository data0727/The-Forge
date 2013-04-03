class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :user_nickname

  belongs_to :story
end

class Comment < ActiveRecord::Base
  attr_accessible :content, :repoid, :userid
  belongs_to :repo
end

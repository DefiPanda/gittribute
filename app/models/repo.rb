class Repo < ActiveRecord::Base
  attr_accessible :reponame, :userid, :repoid, :description
  belongs_to :user
  has_many :comments
end

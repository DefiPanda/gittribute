class AddRepoidAndDescriptionToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :repoid, :int
    add_column :repos, :description, :string
  end
end

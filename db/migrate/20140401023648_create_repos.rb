class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :userid
      t.string :reponame

      t.timestamps
    end
  end
end

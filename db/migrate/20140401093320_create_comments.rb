class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :repoid
      t.integer :userid

      t.timestamps
    end
  end
end

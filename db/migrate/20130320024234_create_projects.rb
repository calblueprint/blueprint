class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :client
      t.string :title
      t.text :description
      t.string :link
      t.attachment :image
    end
  end
end
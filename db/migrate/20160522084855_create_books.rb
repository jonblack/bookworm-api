class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.belongs_to :author, index: true
      t.string :title, null: false
      t.integer :year_published, null: false
      t.timestamps null: false
    end
  end
end

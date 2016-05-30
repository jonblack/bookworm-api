class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :book, index: true
      t.integer :score, null: false
      t.timestamps null: false
    end
  end
end

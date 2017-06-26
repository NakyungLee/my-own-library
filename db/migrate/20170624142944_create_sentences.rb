class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string :sentence
      t.integer :book_id
    end
  end
end

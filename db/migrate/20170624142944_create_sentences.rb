class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string :sentence
      t.string :book_id
    end
  end
end

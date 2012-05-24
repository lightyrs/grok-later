class CreateLinks < ActiveRecord::Migration

  def change
    create_table :links do |t|
      t.string     :href
      t.string     :title
      t.string     :titles
      t.string     :author
      t.string     :authors
      t.text       :lede
      t.text       :keywords
      t.text       :sentences
      t.text       :body
      t.text       :html_body
      t.string     :feed
      t.string     :feeds
      t.string     :favicon
      t.text       :description
      t.datetime   :analyzed_at
      t.timestamps
    end
  end
end

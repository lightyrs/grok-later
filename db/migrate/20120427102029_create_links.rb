class CreateLinks < ActiveRecord::Migration

  def change
    create_table :links do |t|
      t.string     :href, :null => false
      t.string     :title
      t.string     :domain
      t.text       :authors
      t.string     :favicon
      t.text       :lede
      t.text       :links
      t.text       :description
      t.text       :keywords
      t.text       :body_html
      t.text       :body_text
      t.string     :image
      t.text       :images
      t.string     :feed
      t.string     :og_title
      t.string     :og_image
      t.integer    :share_count
      t.datetime   :analyzed_at    
      t.timestamps
    end
    add_index :links, :href, :unique => true
  end
end

class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string    :uid
      t.string    :bio
      t.string    :username
      t.string    :provider
      t.string    :token
      t.string    :email
      t.string    :avatar
      t.string    :profile_url
      t.string    :location
      t.integer   :user_id
      t.integer   :login_count, :default => 0
      t.datetime  :logged_in_at
      t.timestamps
    end
    add_index :identities, [:uid, :provider], :unique => true
    add_index :identities, :user_id
  end
end

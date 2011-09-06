class CreateAudios < ActiveRecord::Migration
  def self.up
    create_table :audios do |t|
      t.integer :super_media_id
      t.string :author
    end
  end

  def self.down
    drop_table :audios
  end
end

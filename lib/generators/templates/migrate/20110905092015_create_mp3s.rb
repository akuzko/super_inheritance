class CreateMp3s < ActiveRecord::Migration
  def self.up
    create_table :mp3s do |t|
      t.integer :audio_id
      t.integer :ratio
    end
  end

  def self.down
    drop_table :mp3s
  end
end

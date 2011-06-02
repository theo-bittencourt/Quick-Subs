class CreateSubtitles < ActiveRecord::Migration
  def change
    create_table :subtitles do |t|

      t.timestamps
    end
  end
end

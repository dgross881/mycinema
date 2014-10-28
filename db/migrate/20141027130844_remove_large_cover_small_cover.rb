class RemoveLargeCoverSmallCover < ActiveRecord::Migration
  def change
    remove_column :videos, :large_cover, :string
    remove_column :videos, :small_cover, :string
  end
end

class AddCategoryIdRemoveCategory < ActiveRecord::Migration
  def change
  remove_column :videos, :category 
  add_column :videos, :category_id, :integer 
  end
end

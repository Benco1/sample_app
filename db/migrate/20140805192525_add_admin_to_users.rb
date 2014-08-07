class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false 
  end
end

# Default manually set to 'false'. Without this explicit arguement
# 'admin' would be 'nil', which is still 'false'. However, setting the 
# arguement to 'false' makes it clearer to both Rails and readers of the code.
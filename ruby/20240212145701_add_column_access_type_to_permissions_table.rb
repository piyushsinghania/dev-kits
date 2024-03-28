class AddColumnAccessTypeToPermissionsTable < ActiveRecord::Migration[7.0]
  def up
    add_column :topic_permission_users, :access_type, :string, default: 'r', null: false
    TopicPermissionUser.update_all("access_type = CASE WHEN writable = true THEN 'rw' ELSE 'r' END")

    add_column :topic_permission_teams, :access_type, :string, default: 'r', null: false
    TopicPermissionTeam.update_all("access_type = CASE WHEN writable = true THEN 'rw' ELSE 'r' END")

    add_column :seed_permission_users, :access_type, :string, default: 'r', null: false
    SeedPermissionUser.update_all("access_type = CASE WHEN writable = true THEN 'rw' ELSE 'r' END")

    add_column :seed_permission_teams, :access_type, :string, default: 'r', null: false
    SeedPermissionTeam.update_all("access_type = CASE WHEN writable = true THEN 'rw' ELSE 'r' END")
  end

  def down
    remove_column :topic_permission_users, :access_type, :string
    remove_column :topic_permission_teams, :access_type, :string
    remove_column :seed_permission_users, :access_type, :string
    remove_column :seed_permission_teams, :access_type, :string
  end
end

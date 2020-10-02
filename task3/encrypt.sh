ansible-vault encrypt_string --vault-password-file password 'password' --name 'mysql_root_password'
ansible-vault encrypt_string --vault-password-file password 'check-db' --name 'mysql_db_user_database'
ansible-vault encrypt_string --vault-password-file password 'check-user' --name 'mysql_user'
ansible-vault encrypt_string --vault-password-file password 'test' --name 'mysql_password'
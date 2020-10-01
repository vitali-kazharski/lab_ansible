ansible-vault encrypt_string --vault-id dev@.passwords 'Password12345' --name 'secret1' > vars.yaml
ansible-vault encrypt_string --vault-id test@.passwords 'Password3456' --name 'secret2' >> vars.yaml
ansible-vault encrypt_string --vault-id stage@.passwords 'phul3AiFai0Ebei5' --name 'secret3' >> vars.yaml
ansible-vault encrypt_string --vault-id prod@.passwords 'kah7ahLu Eed1ohch Sa0hoh1W' --name 'secret4' >> vars.yaml
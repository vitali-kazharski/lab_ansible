ansible localhost -m debug -a var="secret1" -e "@vars.yaml" --vault-id dev@.passwords
ansible localhost -m debug -a var="secret2" -e "@vars.yaml" --vault-id test@.passwords
ansible localhost -m debug -a var="secret3" -e "@vars.yaml" --vault-id stage@.passwords
ansible localhost -m debug -a var="secret4" -e "@vars.yaml" --vault-id prod@.passwords
# Generate registry keys

First run:

    sh ./generate-registry.sh

This will generate 'registry.crt' and 'registry.key' in the working directory.

Now edit the mail vault file:

    ansible-vault edit group_vars/all/vault --vault-password-file=...

And make sure `_vault_docker_registry_cert` and `_vault_docker_registry_key`
variables are initialized with the content of 'registry.crt' and 'registry.key'
respectively:

    _vault_docker_registry_cert: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----

    _vault_docker_registry_key: |
        -----BEGIN RSA PRIVATE KEY-----
        ...
        -----END RSA PRIVATE KEY-----

Finally copy 'registry.crt' to
'/etc/docker/certs.d/matteolandi.net:5000/ca.crt' to tell Docker to trust the
self signed certificate

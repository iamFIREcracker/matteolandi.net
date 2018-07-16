generate() {
    domain=$1
    shift

    openssl req \
        -newkey rsa:4096 -nodes -sha256 -keyout registry.key \
        -x509 -days 365 -out registry.crt \
        -subj "/C=/ST=/L=/O=/OU=/CN=$domain"
}

generate matteolandi.net

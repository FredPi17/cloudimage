update_version() {
    version=$(curl -fsS https://github.com/$1/releases/latest | grep -E -o '[0-9]+.[0-9]+.[0-9]+')
    echo "setting new version for $1: $version"
    sed -i "" "s/\(.*$2\)=.*/\1=\"$version\"/g" versions
}

update_version "hashicorp/terraform"   "TERRAFORM_VERSION"
update_version "kubernetes/kubernetes" "KUBE_VERSION"
update_version "digitalocean/doctl"    "DOCTL_VERSION"
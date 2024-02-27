# Generic dependencies we expect to have provisioned in each node.
# Primarily debugging tools and interactive tools for contest management.
# We could split those out and provision lighter images if necessary.
# Note that more specific dependencies exist in individual installation steps.

sudo apt-get update
sudo apt-get install -y \
    curl dns-tools htop net-tools postgresql-client \
    cloud-utils git patool subversion zip unzip 

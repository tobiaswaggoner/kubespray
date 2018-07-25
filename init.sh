#create us a new certificate so that ansible can access the vms
rm vagrant-boxes/cert -r -f
mkdir vagrant-boxes/cert
ssh-keygen -f vagrant-boxes/cert/id_rsa -N ''

# No Power up the the virtual machines
cd vagrant-boxes
vagrant up
cd ..

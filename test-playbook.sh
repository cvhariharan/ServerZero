# Generate keys
if [ ! -f ansible-test ]
then
    ssh-keygen -t rsa -f ./ansible-test
fi

# Add key to ssh agent
ssh-add ./ansible-test

# Build docker image
PASSWD=$(date | md5sum | cut -c1-10)
DOCKER_BUILDKIT=1 sudo docker build . -f Dockerfile.test --build-arg USER_ARG=$USER --build-arg PASS_ARG=$PASSWD -t ansible-machine

# Start docker containers
sudo docker run --rm -d ansible-machine
sudo docker run --rm -d ansible-machine

# Setup inventory file
if [ -f inventory-test.txt ]
then
    rm inventory-test.txt
fi

echo '[nodes]' >> inventory-test.txt
containers=($(sudo docker ps -q --filter ancestor=ansible-machine))
for i in ${containers[@]}; do
    echo $(sudo docker inspect $i -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}') >> inventory-test.txt
done

echo '[nodes:vars]' >> inventory-test.txt
echo "ansible_user=$USER" >> inventory-test.txt
echo "ansible_pass=$PASSWD" >> inventory-test.txt
echo "ansible_become_pass=$PASSWD" >> inventory-test.txt
echo 'ansible_ssh_private_key_file=./ansible-test' >> inventory-test.txt

# Run ansible
TEST_PLAYBOOK=True ansible-playbook -i inventory-test.txt site.yml

# Remove containers
sudo docker kill $(sudo docker ps -q --filter ancestor=ansible-machine)

# Remove key
ssh-add -d ./ansible-test
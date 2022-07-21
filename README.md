# AnsibleTest


# Description
The purpose of this repo is to create a project where I can run some simple ansible playbooks in an attempt to lean 
how to use AWX and how it can be useful to data ductus. I hope to configure a netsim using an ansible playbook and learn the ins and outs of
AWX

# Table of contents
1) <a href="#AWX Install">AWX Install</a>
2) <a href="#Steps to run hello world example">Steps to run hello world example</a>
3) <a href="#Other resources">Other resources</a>



## <div id="AWX Install">AWX Install</div>

If on mac can use the bash file locaed in `/install/installMac` Run this with `bash startAWX.sh`

AWX will be containerized in this repo soon but is not yet. Look to awx-operator to install in your spesific os:
https://github.com/ansible/awx-operator#purpose 

  
# Steps to run hello world example
 1. Login to AWX using the user name and password provided when installed. Default username is admin and password can be obtained by running the command 
 `kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode`
 
 2. Once in navigate to the oranizations tab and create a new organization. Give it a name and set the execution enviornment to latest

 3. Next, head over to the projects tab and give the project a name, set the oranization to the one just created, and the source control type to git. Set the URL to this repo. `Save` and click `sync`

 4. Create a new inventory with the oranization previouldy created and give it a name.
 
 5. Create a new host using the inventory that was already created and in the varibles section spesify `ansible_connection: local`

 6. Finally, create a new template. Use the inventory, project, and execution enviornment just created and set the type to run. Select the ansible playbook `helloWorld.yaml` hit `save` then `launch`. That playbook in this repo should execute and should print hello world and the pwd. If it looks like the tasks didnt run refresh the page. 

# Other resources  

The documentation for awx can be found - https://docs.ansible.com/ansible/latest/collections/awx/awx/index.html#

Ansible - https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/libssh_connection.html
  
Ansible galaxy -  https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#install-multiple-collections-with-a-requirements-file

Possible formating fix - https://github.com/ansible/ansible/pull/69154

Cisco iosxr moduals documentation - https://docs.ansible.com/ansible/latest/collections/cisco/iosxr/index.html

Minikube-in-docker https://github.com/microsoft/vscode-dev-containers/tree/main/containers/kubernetes-helm-minikube

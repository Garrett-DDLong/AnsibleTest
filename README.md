# AnsibleTest
Description:
The purpose of this repo is to create a project where I can run some simple ansible playbooks in an attempt to lean 
how to use AWX and how it can be useful to data ductus. I hope to configure a netsim and learn the ins and outs of
AWX


File contents:

Colletions - Collections is a required folder that contains requirements.yml

requirements.yml - This file contains dependances that need to be installed for the project to run in AWX
AWX will look for the directory collections/requirements.yml for this file. If this file does not work then
the project wont sync and nothing will work. Documentation for this format can be seen here: 
https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#install-multiple-collections-with-a-requirements-file



myPlaybooks - Contains playbooks that will be used. In awx a playbooks can be selected for each project to run.

helloWorld2.yaml - Contains 2 plays the first will do some simple things like printing the PWD. The second play 
is attempting to ssh and confgure a netsim.



Install:

AWX was installed useing https://github.com/ansible/awx-operator#purpose and the instructions on this page. 



The errors I keep on getting are:

ERROR! Neither the collection requirement entry key 'name', nor 'source' point to a concrete resolvable collection 
artifact. Also 'name' is not an FQCN. A valid collection name must be in the format <namespace>.<collection>. Please 
make sure that the namespace and the collection name  contain characters from [a-zA-Z0-9_] only.

Tip: Make sure you are pointing to the right subdirectory — 
  `/var/lib/awx/projects/.__awx_cache/_8__testproject/stage/tmp/ansible-local-
  11070hu3hvfh2/tmpv8s4bwl3/pylibsshoyxroiig`
looks like a directory but it is neither a collection, nor a namespace dir.

Useful links: 

The documentation for awx can be found at https://docs.ansible.com/ansible/latest/collections/awx/awx/index.html#

  https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/libssh_connection.html
  

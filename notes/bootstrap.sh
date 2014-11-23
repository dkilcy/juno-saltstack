salt-key -L
salt-key -A -y
sleep 5 
salt '*' test.ping
sleep 5
salt '*' test.ping
sleep 5

salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar

salt '*' state.sls users
salt '*' state.sls ipv6
salt '*' state.sls ntp
salt '*' cmd.run 'date'

sleep 5

#salt 'controller*' state.sls openstack.ipv4.controller
#salt 'network*' state.sls openstack.ipv4.network
#salt 'compute*' state.sls openstack.ipv4.compute
#salt 'block*' state.sls openstack.ipv4.block
#salt 'object*' state.sls openstack.ipv4.object


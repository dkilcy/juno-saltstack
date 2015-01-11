
mongodb-server:
  pkg.installed:
    - name: mongodb-server

mongodb:
  pkg.installed:
    - name: mongodb

###
# 3. Configure MongoDB to make it listen on the controller management IP address.  Edit the /etc/mongodb.conf file and modify the bind_ip key:
###

mongodb_conf_bindIp:
  file.replace:
    - name: /etc/mongodb.conf
    - path: /etc/mongodb.conf
    - pattern: 'bind_ip = 127.0.0.1'
    - repl: 'bind_ip = 0.0.0.0'

mongodb_service:
  service.running:
    - name: mongod
    - enable: True

# https://github.com/saltstack/salt/issues/8933



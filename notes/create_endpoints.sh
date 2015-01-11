
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ identity / {print $2}') \
  --publicurl http://controller1:5000/v2.0 \
  --internalurl http://controller1:5000/v2.0 \
  --adminurl http://controller1:35357/v2.0 \
  --region regionOne


keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ image / {print $2}') \
  --publicurl http://controller1:9292 \
  --internalurl http://controller1:9292 \
  --adminurl http://controller1:9292 \
  --region regionOne

keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ compute / {print $2}') \
  --publicurl http://controller1:8774/v2/%\(tenant_id\)s \
  --internalurl http://controller1:8774/v2/%\(tenant_id\)s \
  --adminurl http://controller1:8774/v2/%\(tenant_id\)s \
  --region regionOne

keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ network / {print $2}') \
  --publicurl http://controller1:9696 \
  --adminurl http://controller1:9696 \
  --internalurl http://controller1:9696 \
  --region regionOne

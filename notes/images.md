
#### Add Ubuntu Trusty 14.04 LTS AMD-64 image to Glance

```
[devops@workstation2 tmp]$ wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
--2014-12-06 13:14:15--  https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
Resolving cloud-images.ubuntu.com (cloud-images.ubuntu.com)... 91.189.88.141, 2001:67c:1360:8001:ffff:ffff:ffff:fffe
Connecting to cloud-images.ubuntu.com (cloud-images.ubuntu.com)|91.189.88.141|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 256180736 (244M) [application/octet-stream]
Saving to: ‘trusty-server-cloudimg-amd64-disk1.img.1’

100%[==============================================================================================>] 256,180,736 3.40MB/s   in 72s    

2014-12-06 13:15:27 (3.39 MB/s) - ‘trusty-server-cloudimg-amd64-disk1.img.1’ saved [256180736/256180736]

[devops@workstation2 Downloads]$ source ~/openstack/auth-openrc.sh 
[devops@workstation2 Downloads]$ source ~/openstack/admin-openrc.sh 
[devops@workstation2 Downloads]$ glance image-create --name "trusty-server-cloudimg-amd64-disk1" --file trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --is-public True --progress
[=============================>] 100%
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| checksum         | a297c290835094eed095696691793755     |
| container_format | bare                                 |
| created_at       | 2014-12-06T18:10:53                  |
| deleted          | False                                |
| deleted_at       | None                                 |
| disk_format      | qcow2                                |
| id               | 1668e2b3-faa1-4102-8dbe-7490ef3b4801 |
| is_public        | True                                 |
| min_disk         | 0                                    |
| min_ram          | 0                                    |
| name             | trusty-server-cloudimg-amd64-disk1   |
| owner            | 4f516f71efb94ca9aa85ea8b29b80226     |
| protected        | False                                |
| size             | 255918592                            |
| status           | active                               |
| updated_at       | 2014-12-06T18:10:57                  |
| virtual_size     | None                                 |
+------------------+--------------------------------------+
[devops@workstation2 Downloads]$ 
```


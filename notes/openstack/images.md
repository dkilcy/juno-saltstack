
#### Add Ubuntu Trusty 14.04 LTS AMD-64 image to Glance

```
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


### OpenStack Identity

#### Test connectivity
```
curl -ks http://controller-01:5000/v2.0 | python -mjson.tool
```

##### Response
```
{
    "version": {
        "id": "v2.0", 
        "links": [
            {
                "href": "http://controller-01:5000/v2.0/", 
                "rel": "self"
            }, 
            {
                "href": "http://docs.openstack.org/api/openstack-identity-service/2.0/content/", 
                "rel": "describedby", 
                "type": "text/html"
            }, 
            {
                "href": "http://docs.openstack.org/api/openstack-identity-service/2.0/identity-dev-guide-2.0.pdf", 
                "rel": "describedby", 
                "type": "application/pdf"
            }
        ], 
        "media-types": [
            {
                "base": "application/json", 
                "type": "application/vnd.openstack.identity-v2.0+json"
            }, 
            {
                "base": "application/xml", 
                "type": "application/vnd.openstack.identity-v2.0+xml"
            }
        ], 
        "status": "stable", 
        "updated": "2014-04-17T00:00:00Z"
    }
}
```

#### Authenticate and get token

```
curl -ks http://controller-01:5000/v2.0/tokens \
  -X 'POST' \
  -H 'Content-Type: application/json' \
  -d '{ "auth": { 
        "tenantName": "admin",
        "passwordCredentials": {
            "username": "admin",
            "password": "94bcee677185fee9c0bf" 
        }
      }
     }' | python -m json.tool
```

##### Response:
```
{
    "access": {
        "metadata": {
            "is_admin": 0, 
            "roles": [
                "7c3321288c4a4de4a4f65ab39fa1b185"
            ]
        }, 
        "serviceCatalog": [
            {
                "endpoints": [
                    {
                        "adminURL": "http://controller-01:9292", 
                        "id": "4d6eae6630b24e52bca75fca4eb98f93", 
                        "internalURL": "http://controller-01:9292", 
                        "publicURL": "http://controller-01:9292", 
                        "region": "regionOne"
                    }
                ], 
                "endpoints_links": [], 
                "name": "glance", 
                "type": "image"
            }, 
            {
                "endpoints": [
                    {
                        "adminURL": "http://controller-01:8774/v2/cd4594c024854fbbb283b83b26826506", 
                        "id": "2a0060b2c4a34f2abec447b300a6d85f", 
                        "internalURL": "http://controller-01:8774/v2/cd4594c024854fbbb283b83b26826506", 
                        "publicURL": "http://controller-01:8774/v2/cd4594c024854fbbb283b83b26826506", 
                        "region": "regionOne"
                    }
                ], 
                "endpoints_links": [], 
                "name": "nova", 
                "type": "compute"
            }, 
            {
                "endpoints": [
                    {
                        "adminURL": "http://controller-01:9696", 
                        "id": "20da62c4189149c4bdf54612bb7486f2", 
                        "internalURL": "http://controller-01:9696", 
                        "publicURL": "http://controller-01:9696", 
                        "region": "regionOne"
                    }
                ], 
                "endpoints_links": [], 
                "name": "neutron", 
                "type": "network"
            }, 
            {
                "endpoints": [
                    {
                        "adminURL": "http://controller-01:35357/v2.0", 
                        "id": "223dcbaa0d834815b04426971da3b553", 
                        "internalURL": "http://controller-01:5000/v2.0", 
                        "publicURL": "http://controller-01:5000/v2.0", 
                        "region": "regionOne"
                    }
                ], 
                "endpoints_links": [], 
                "name": "keystone", 
                "type": "identity"
            }, 
            {
                "endpoints": [
                    {
                        "adminURL": "http://controller-01:8777", 
                        "id": "2bbd3cef0342497c8cbecf27a568d107", 
                        "internalURL": "http://controller-01:8777", 
                        "publicURL": "http://controller-01:8777", 
                        "region": "RegionOne"
                    }
                ], 
                "endpoints_links": [], 
                "name": "ceilometer", 
                "type": "metering"
            }
        ], 
        "token": {
            "expires": "2014-10-17T19:28:41Z", 
            "id": "MIIJWwYJKoZIhvcNAQcCoIIJTDCCCUgCAQExCTAHBgUrDgMCGjCCB7EGCSqGSIb3DQEHAaCCB6IEggeeeyJhY2Nlc3MiOiB7InRva2VuIjogeyJpc3N1ZWRfYXQiOiAiMjAxNC0xMC0xN1QxODoyODo0MS4yMDMxMTkiLCAiZXhwaXJlcyI6ICIyMDE0LTEwLTE3VDE5OjI4OjQxWiIsICJpZCI6ICJwbGFjZWhvbGRlciIsICJ0ZW5hbnQiOiB7ImRlc2NyaXB0aW9uIjogbnVsbCwgImVuYWJsZWQiOiB0cnVlLCAiaWQiOiAiY2Q0NTk0YzAyNDg1NGZiYmIyODNiODNiMjY4MjY1MDYiLCAibmFtZSI6ICJhZG1pbiJ9fSwgInNlcnZpY2VDYXRhbG9nIjogW3siZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6OTI5MiIsICJyZWdpb24iOiAicmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly9jb250cm9sbGVyLTAxOjkyOTIiLCAiaWQiOiAiNGQ2ZWFlNjYzMGIyNGU1MmJjYTc1ZmNhNGViOThmOTMiLCAicHVibGljVVJMIjogImh0dHA6Ly9jb250cm9sbGVyLTAxOjkyOTIifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAiaW1hZ2UiLCAibmFtZSI6ICJnbGFuY2UifSwgeyJlbmRwb2ludHMiOiBbeyJhZG1pblVSTCI6ICJodHRwOi8vY29udHJvbGxlci0wMTo4Nzc0L3YyL2NkNDU5NGMwMjQ4NTRmYmJiMjgzYjgzYjI2ODI2NTA2IiwgInJlZ2lvbiI6ICJyZWdpb25PbmUiLCAiaW50ZXJuYWxVUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6ODc3NC92Mi9jZDQ1OTRjMDI0ODU0ZmJiYjI4M2I4M2IyNjgyNjUwNiIsICJpZCI6ICIyYTAwNjBiMmM0YTM0ZjJhYmVjNDQ3YjMwMGE2ZDg1ZiIsICJwdWJsaWNVUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6ODc3NC92Mi9jZDQ1OTRjMDI0ODU0ZmJiYjI4M2I4M2IyNjgyNjUwNiJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJjb21wdXRlIiwgIm5hbWUiOiAibm92YSJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly9jb250cm9sbGVyLTAxOjk2OTYiLCAicmVnaW9uIjogInJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vY29udHJvbGxlci0wMTo5Njk2IiwgImlkIjogIjIwZGE2MmM0MTg5MTQ5YzRiZGY1NDYxMmJiNzQ4NmYyIiwgInB1YmxpY1VSTCI6ICJodHRwOi8vY29udHJvbGxlci0wMTo5Njk2In1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogIm5ldHdvcmsiLCAibmFtZSI6ICJuZXV0cm9uIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6MzUzNTcvdjIuMCIsICJyZWdpb24iOiAicmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly9jb250cm9sbGVyLTAxOjUwMDAvdjIuMCIsICJpZCI6ICIyMjNkY2JhYTBkODM0ODE1YjA0NDI2OTcxZGEzYjU1MyIsICJwdWJsaWNVUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6NTAwMC92Mi4wIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogImlkZW50aXR5IiwgIm5hbWUiOiAia2V5c3RvbmUifSwgeyJlbmRwb2ludHMiOiBbeyJhZG1pblVSTCI6ICJodHRwOi8vY29udHJvbGxlci0wMTo4Nzc3IiwgInJlZ2lvbiI6ICJSZWdpb25PbmUiLCAiaW50ZXJuYWxVUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6ODc3NyIsICJpZCI6ICIyYmJkM2NlZjAzNDI0OTdjOGNiZWNmMjdhNTY4ZDEwNyIsICJwdWJsaWNVUkwiOiAiaHR0cDovL2NvbnRyb2xsZXItMDE6ODc3NyJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJtZXRlcmluZyIsICJuYW1lIjogImNlaWxvbWV0ZXIifV0sICJ1c2VyIjogeyJ1c2VybmFtZSI6ICJhZG1pbiIsICJyb2xlc19saW5rcyI6IFtdLCAiaWQiOiAiMjM0OWMwN2RiZDlhNGY3Yjg1ZWFiMzQxZjcwNzU3YmQiLCAicm9sZXMiOiBbeyJuYW1lIjogImFkbWluIn1dLCAibmFtZSI6ICJhZG1pbiJ9LCAibWV0YWRhdGEiOiB7ImlzX2FkbWluIjogMCwgInJvbGVzIjogWyI3YzMzMjEyODhjNGE0ZGU0YTRmNjVhYjM5ZmExYjE4NSJdfX19MYIBgTCCAX0CAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAcGBSsOAwIaMA0GCSqGSIb3DQEBAQUABIIBAHCN9YzgsDI1WiMIEK26tug3R2WfuXkPXgwNh491ojQUZLLFy8m1DRLwoArTeN+GX5RGAi1C7k89MlUchWSIX71A5Sr4rPO5lY12zMtWd8f6p1GHLPLuZn3pyk+EFA58oTGonhfUHr1rHkD6JzaIsaly5BO69721XEiXHBdQx6z81zLb0gNfj4mNgHJxLgFSw7h4cn7vVq9ZoTFdkKuv37Ch8bOLJ1TDt9Rwfgj1x0ToJ3AYNXJtkcYCUaGUUhz9mkVZdMgrpVPlzSsouU9Z4eSnBf1G7D+pJLASwAeTk73IF5OGX260eJN4gGWgjNqsM7BktmvvEfDdMf1q46I0Ul4=", 
            "issued_at": "2014-10-17T18:28:41.203119", 
            "tenant": {
                "description": null, 
                "enabled": true, 
                "id": "cd4594c024854fbbb283b83b26826506", 
                "name": "admin"
            }
        }, 
        "user": {
            "id": "2349c07dbd9a4f7b85eab341f70757bd", 
            "name": "admin", 
            "roles": [
                {
                    "name": "admin"
                }
            ], 
            "roles_links": [], 
            "username": "admin"
        }
    }
}

[devops@workstation-02 openstack]$ keystone tenant-list
+----------------------------------+---------+---------+
|                id                |   name  | enabled |
+----------------------------------+---------+---------+
| cd4594c024854fbbb283b83b26826506 |  admin  |   True  |
| 4a0604c0ead74c25af45d7f76aaaa117 |   demo  |   True  |
| d340cfa973844af7883c6b9696475ec4 | service |   True  |
+----------------------------------+---------+---------+

[devops@workstation-02 openstack]$ echo $OS_USERNAME
admin
[devops@workstation-02 openstack]$ curl -ks -H "X-Auth-Token: $OS_TOKEN"  http://controller-01.pub:5000/v2.0/tenants 
{"tenants_links": [], "tenants": [{"description": null, "enabled": true, "id": "cd4594c024854fbbb283b83b26826506", "name": "admin"}]}

[devops@workstation-02 openstack]$ curl -ks -H "X-Auth-Token: $OS_TOKEN"  http://controller-01.pub:8774/v2/cd4594c024854fbbb283b83b26826506/servers/detail | python -m json.tool
{
    "servers": [
        {
            "OS-DCF:diskConfig": "AUTO", 
            "OS-EXT-AZ:availability_zone": "nova", 
            "OS-EXT-SRV-ATTR:host": "compute-02.mgmt", 
            "OS-EXT-SRV-ATTR:hypervisor_hostname": "compute-02.mgmt", 
            "OS-EXT-SRV-ATTR:instance_name": "instance-0000000d", 
            "OS-EXT-STS:power_state": 1, 
            "OS-EXT-STS:task_state": null, 
            "OS-EXT-STS:vm_state": "active", 
            "OS-SRV-USG:launched_at": "2014-10-20T17:36:39.000000", 
            "OS-SRV-USG:terminated_at": null, 
            "accessIPv4": "", 
            "accessIPv6": "", 
            "addresses": {
                "ext-net": [
                    {
                        "OS-EXT-IPS-MAC:mac_addr": "fa:16:3e:10:06:3e", 
                        "OS-EXT-IPS:type": "fixed", 
                        "addr": "192.168.1.203", 
                        "version": 4
                    }
                ]
            }, 
            "config_drive": "", 
            "created": "2014-10-20T17:36:25Z", 
            "flavor": {
                "id": "1", 
                "links": [
                    {
                        "href": "http://controller-01.pub:8774/cd4594c024854fbbb283b83b26826506/flavors/1", 
                        "rel": "bookmark"
                    }
                ]
            }, 
            "hostId": "e74be2a964540a02c6c7d2b637fee387dd640486d4c75283d454e7e7", 
            "id": "a684adf0-ccb6-48eb-aff9-95d1812a4773", 
            "image": {
                "id": "13404424-93e0-41ff-9b78-2e056f231657", 
                "links": [
                    {
                        "href": "http://controller-01.pub:8774/cd4594c024854fbbb283b83b26826506/images/13404424-93e0-41ff-9b78-2e056f231657", 
                        "rel": "bookmark"
                    }
                ]
            }, 
            "key_name": null, 
            "links": [
                {
                    "href": "http://controller-01.pub:8774/v2/cd4594c024854fbbb283b83b26826506/servers/a684adf0-ccb6-48eb-aff9-95d1812a4773", 
                    "rel": "self"
                }, 
                {
                    "href": "http://controller-01.pub:8774/cd4594c024854fbbb283b83b26826506/servers/a684adf0-ccb6-48eb-aff9-95d1812a4773", 
                    "rel": "bookmark"
                }
            ], 
            "metadata": {}, 
            "name": "demo-instance3", 
            "os-extended-volumes:volumes_attached": [], 
            "progress": 0, 
            "security_groups": [
                {
                    "name": "default"
                }
            ], 
            "status": "ACTIVE", 
            "tenant_id": "cd4594c024854fbbb283b83b26826506", 
            "updated": "2014-10-20T17:36:40Z", 
            "user_id": "2349c07dbd9a4f7b85eab341f70757bd"
        }
    ]
}


[devops@workstation-02 openstack]$ curl -ks -H "X-Auth-Token: $OS_TOKEN"  http://controller-01.pub:8774/cd4594c024854fbbb283b83b26826506/flavors/1 | python -m json.tool
{
    "choices": [
        {
            "id": "v2.0", 
            "links": [
                {
                    "href": "http://controller-01.pub:8774/v2/cd4594c024854fbbb283b83b26826506/flavors/1", 
                    "rel": "self"
                }
            ], 
            "media-types": [
                {
                    "base": "application/xml", 
                    "type": "application/vnd.openstack.compute+xml;version=2"
                }, 
                {
                    "base": "application/json", 
                    "type": "application/vnd.openstack.compute+json;version=2"
                }
            ], 
            "status": "CURRENT"
        }
    ]
}

```

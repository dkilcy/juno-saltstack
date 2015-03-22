### Ceilometer

[http://developer.openstack.org/api-ref-telemetry-v2.html] [https://wiki.openstack.org/wiki/Ceilometer/ComplexFilterExpressionsInAPIQueries]

```
curl -ks -H "X-Auth-Token: $OS_TOKEN" http://controller-01:8777/v2/alarms | python -m json.tool curl -ks -H "X-Auth-Token: $OS_TOKEN" http://controller-01:8777/v2/meters | python -m json.tool curl -ks -H "X-Auth-Token: $OS_TOKEN" http://controller-01:8777/v2/resources | python -m json.tool

ceilometer query-samples -f '{"=": {"counter_name":"cpu_util"}}'

curl -ks -X POST -H "X-Auth-Token: $OS_TOKEN" -H 'Content-Type: application/json' http://controller-01:8777/v2/query/samples \ -d '{"filter": "{\"and\": [{\">\":{\"timestamp\":\"2014-10-17T15:00:00\"}},{\"<\":{\"timestamp\":\"2014-10-17T16:00:00\"}}]}"}'

curl -ks -X POST -H "X-Auth-Token: $OS_TOKEN" -H 'Content-Type: application/json' http://controller-01:8777/v2/query/samples \ -d '{"=": {"counter_name":"cpu_util"}}'

curl -ks -X POST -H "X-Auth-Token: $OS_TOKEN" -H 'Content-Type: application/json' http://controller-01:8777/v2/query/samples \ -d '{"filter": "{\"=\": {\"counter_name\":\"cpu_util\"} }"}'

```


## Swift - The Ring
[OpenStack Swift: The Ring][https://www.youtube.com/watch?v=LzaQKKp58JI]

#### Swift Basics
- Swift is an object store.  Objects consist of a sequence of bytes and associated metadata
- Store them in Swift and pull them out later
- RESTful API - GET PUT POST DELETE and common response codes

#### Swift Durability
- Objects go in and come out, even if hardware fails in the meantime
- Stores multiple replicas of the data, typically 3 is a good trade-off
- Objects have a checksum stored with the object (md5 checksum). 
- When you get an object you can test the bytes recieved with the checksum from the header 
- When you put an object into Swift you put the checksum in the header.  If the bytes do not match the checksum it throws them away
- protection against transmission errors
- 
#### Active Consistency Checking
Background runs a continuous integrity checks that read uplaoded objects off the disk to make sure their checksum matches.  If swift finds an object that is rotted it quarantines the object - takes it out from where it is and puts it in a quarantine directory for administrator to take a look at.

Active replication: for 3 replicas, each server that has a replica periodically asks the other 2 servers 'do you have a copy of this object'?
If server B lost the copy due to bit rot server A will push out a fresh copy, now back up to 3 replicas

#### Scalability
Linear scailability with no single point of failure.  
- Nodes can be added.  4x nodes = 4x capacity

#### Hashing
Now with all these servers and all this data, how does swift know where to find the data?
It uses a modified consistent hashing ring. 
Before talking about the modified consistent hashing ring, talk about the basic consistent hashing ring

##### Basic consistent hashing ring
that would work with md5 (128 bit output space): write it around in a circle, hence the name ring.  0,1,2,3 up to 2^128-1 go on this ring
then to add a node to the ring you hash the nodes name and place at appropriate location in the ring
if you want each node to be in more than 1 spot then append a suffix in some repeatable way
An example of 6 virtual nodes per real node. Node 1 is on there 6 times, node 2 is on there 6 times.
More than 6 to have even distribution 

When you make a change to the ring, say add a node, you get a small amount of your data moving

Contrast this with hash of the object name mod(n)
If you go from 99 nodes to 100 nodes and using hashmod(n)
went from hasmod(99) to hashmod(100) -  - just about all of the data has moved.

Q: how many nodes to create? 
A: How many virtual nodes per real node? Start adding until you get an even distribution of data but not overboard, because more memory is used. systems with 100 virtual nodes for each real node seems to be a good number.

Nice thing about consistent hashing ring is go from 100 servers to 101 servers. 1% on average of data will move.
If you were doing hashmod(n) all of your data, which is not a good characteristic of a storage system.

Time complexity in a sorted array is log(n) to find an items position in the ring
hash the objects name, find where it lands in the ring, and slide (binary search) 
big O log n

Swift hash function based on md5. Is an md5 of path plus secret-per-cluster suffix
so cluster users cannot create collisions deliberately.
if using plain md5 users can fill disk 

hash(path) = md5(path + per-cluster suffix)

part_power of 4 - top 4 bits of the hash to use in figuring out where things go
in real cluster, much larger than 4

2^part_power = number of partitions.
Immutable once chosen
At least 100 per disk

Rules of thumb for selecting part_power: 
At least 100 
Physical number that can be calculated

log2(number-of-disks * 100)
bigger part_power -> bigger rings -> more memory used (but lookups stay fast)
10's of MB
Err too big or too small? Err too big.  Better to trade off memory usage than to run with too few partions per disk. 

### Ring Internals
2 main data structures: 
- _devs: array of device dicts
- _replica2part2dev - array of array 

Using the ring to find where to put data
```
def get_nodes(self, account, container=None, obj=None):
    key = hash_path(account, container, obj, raw_digest=True)
    # self._part_shift is (32 - part_power)
    part = struct.unpack_from('>I',key)[0] >> self._part_shift
    seen_ids = set()
    return part, [self._devs[r[part]] for r in self._replica2part2dev_id
         if not r[[art] in seen_ids or seen_ids.add(r[part]))]
```

### Building the ring

The ring builder is something run offline.
Run a command called swift-ring-builder.  Give it a builder file and can do things to the ring like add device, delete device or rebalance - take data off from partitions that have more than they need and put them on partions that have fewer than they need.  Creates an object.ring.gz file and distribute out to the cluster nodes.  Swift daemons pick it up automatically.

How partitions are pl

Keeping the data available in case of a move.
If 1 replica gets moved, the others get locked down.
Ensure 2 replicas of the data are always available on the primary node even when the data is being moved around
min_part_hours

Replica placement. Algorithm Swift uses is to keep data as far apart as possible. In a 3 zone setup, each
replica goes to a zone.

Swift achieves durability and availability
expensive ring computations done offline, results distributed in a static file
replicas kept far apart for maximum durability
store copies on handoff nodes to make sure all the replicas are available.



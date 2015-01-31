
## Swift - The Ring

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
- 


#### Hashing
Now with all these servers and all this data, how does swift know where to find the data?
It uses a modified consistent hashing ring. 
Before talking about the modified hashing ring, talk about the basic consistent hashing ring


##### Basic consistent hashing ring
that would work with md5 (120 bit output space): write it around in a circle, hence the name ring.  0,1,2,3 up to 2^120 
hash the nodes name and place at the appropriate location in the ring.
if you want each node to be in more than 1 spot then append a suffix
An example of 6 virtual nodes per real node.

When you make a change to the ring say add a node you get a small amount of your data moving
Contrast with hash of the object name mod N
If you go from 99 to 100 nodes and using hashmod(n) - just about all of the data has moved.
went from hasmod(99) to hashmod(100) - 

how many nodes to create? How many virtual nodes per real node? Start adding until you get an even distribution of data but not overboard, because more memory is used.
100 virtual nodes for each real node.

time complexity in a sorted array is log(n) to find an items position in the ring
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


```
def get_nodes(self, account, container=None, obj=None):
    key = hash_path(account, container, obj, raw_digest=True)
    # self._part_shift is (32 - part_power)
    part = struct.unpack_from('>I',key)[0] >> self._part_shift
    seen_ids = set()
    return part, [self._devs[r[part]] for r in self._replica2part2dev_id
         if not r[[art] in seen_ids or seen_ids.add(r[part]))]
```

### Ring Internals
2 main data structures: devs: array of device dicts
_replica2part2dev - array of array 

 
#####References
  [OpenStack Swift: The Ring][https://www.youtube.com/watch?v=LzaQKKp58JI]
  

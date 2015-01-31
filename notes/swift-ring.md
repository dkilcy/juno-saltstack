
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

#### Active Consistency Checking
- Background runs a continuous integrity checks that read uplaoded objects off the disk to make sure their checksum matches.
If swift finds an object that is rotted it quarantines the object 
- Active replication: each server that has a replica asks the other 2 servers 'do you have a copy of this object'

- Linear scailability with no single point of failure

#### Hashing
How does swift know where to find the data?

- modified consistent hashing ring
- basic consistent hashing ring that would work with md5 (120 bit output space): 0,1,2,3 up to 2^120 
hash the nodes name and place at the appropriate location in the ring.
append a suffix

when you make a change say add a node you get a small amount of your data moving




 
#####References
  [OpenStack Swift: The Ring][https://www.youtube.com/watch?v=LzaQKKp58JI]
  

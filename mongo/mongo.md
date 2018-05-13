# install mongodb

* download and extract
* mkdir -p /data/db
* export PATH=/home/cmwin/software/mongodb/bin:$PATH
* mongod --dbpath=/data/db
* mongod --shutdown

## backup mongodb server(all database will be backuped)
 * mkdir ~/mongobak
 * cd ~/mongobak
 * ./mongodump
 ````
 execute above command, will create a directory and some backup file in ~/mongobak/dump
 ````

## backup single database
* ./mongodump -d database_name

## backup specified collection
* ./mongodump -d db_name -c collection_name


## restore backup database to server
   * cd ~/mongobak
   * mongorestore --drop

## restore single database or collection
* mongorestore -d db_name --drop
* mongorestore -d db_name -c collection_name --drop


## export data from mongodb
export -d test -c todo -q {} -f _id,name,address --csv > test.todo.csv

## import data into mongodb(csv, tsv, json etc)

# mongodb security sections



## spring-boot mongodb integration

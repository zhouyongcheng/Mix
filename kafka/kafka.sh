#/bin/bash

case $1 in
	"start") {

		for i in node21 node22 node23
		do
			echo "=============start $i=============="
			ssh $i "/data/soft/kafka/bin/kafka-server-start.sh -daemon /data/soft/kafka/config/server.properties"
		done
    };;

    "stop") {

		for i in node21 node22 node23
		do
			echo "=============stop $i=============="
			ssh $i "/data/soft/kafka/bin/kafka-server-stop.sh"
		done
    };;

esac
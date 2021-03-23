cherrytree


nohup /usr/local/java/bin/java -jar -Xmx2048m -Xms2048m -Dspring.profiles.active=qa -Dserver.port=8089 /home/mcqa/msgcenter-1.0.0.jar > /opt/log/msgcenter/msgcenter.log &


nohup java -jar -Xmx2048m -Xms2048m /home/app.jar /home/log/app.log &
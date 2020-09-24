#最后运行的tomcat的目录
TOMCAT_HOME="/var/lib/tomcat8"
#tomcat运行端口
TOMCAT_PORT=8080
#jenkins打包成war包之后存放的目录
JENKINS_TARGET_HOME="/usr/share/tomcat8/.jenkins/workspace/springbootdemo/target/"
#jenkins打包成war包的名字(这个war的名字和pom文件配置有关)
JENKINS_WAR_NAME="demo-0.0.1-SNAPSHOT.war"
#jenkins打包成war包的路径
JENKINS_WAR_HOME=$JENKINS_TARGET_HOME/$JENKINS_WAR_NAME
#tomcat下war最终运行的名字（可以不要，只是本人看着难受）
FINAL_WAR_NAME="demo.war"

echo "[step 1:]  kill tomcat process is start"

#获取指定运行的tomcat进程号
tomcat_pid=`ps -ef | grep $TOMCAT_HOME | grep -v grep | awk '{print $2}'`
#如果又进程就杀死

#这里的[ -n "$tomcat_pid" ]不能错，引号去掉判断不准，注意空格，这都是我踩过的坑啊
if [ -n "$tomcat_pid" ]
then 
      echo $tomcat_pid "tomcat process is starting========"
      kill -9 $tomcat_pid
      sleep 3
else
      echo "tomcat is shutdown........."
fi

#获取指定运行的tomcat进程号
#tomcat_pid=`ps -ef | grep $TOMECAT_HOME | grep -v grep | awk '{print $2}'`

#如果存在指定运行的tomcat进程，直接循环kill，直到没有
#while [ -n "$tomcat_pid" ]
#do
#   #statements
#   kill -9 $tomcat_pid
#   sleep 3
#   tomcat_pid=`ps -ef | grep $TOMECAT_HOME | grep -v grep | awk '{print $2}'`
#   echo "scan tomcat pid == " $tomcat_pid
#done

sleep 3
#输出语句而已
echo "[setp 2: ] cp " $JENKINS_WAR_HOME "to" $TOMCAT_HOME"/webapps/"

#将war包移动到tomcat的webapp目录下
yes|cp $JENKINS_WAR_HOME $TOMCAT_HOME/webapps/

cd $TOMCAT_HOME/webapps/

echo "[setp 3 ] prepare env....."

#将以前存在的war包删除（如果没有不会报错）
rm -rf $FINAL_WAR_NAME

#将war包重命名
mv $JENKINS_WAR_NAME  $FINAL_WAR_NAME

#将tomcat启动 的log日志清空（可以不要）
#echo "" > $TOMCAT_HOME/logs/catalina.out

echo "[setp 4::] start tomcat "
#在jenkins环境中一定要加这句话，否则这个脚本进程最后会被杀死，tomcat不起动，jenkins也不报错
export BUILD_ID=dontKillMe

#运行tomcat
#sh $TOMCAT_HOME/bin/startup.sh 
service tomcat8 start

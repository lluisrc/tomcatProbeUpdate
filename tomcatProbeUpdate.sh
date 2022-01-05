#!/bin/bash

endColour="\e[0m"
redColour="\e[0;31m"
greenColour="\e[0;32m"
yellowColour="\e[0;33m"
blueColour="\e[0;34m"
purpleColour="\e[0;35m"
cianColour="\e[0;36m"
greyColour="\e[0;37m"

echo "  _     _       _       _____                         _     _   _           _       _        "
echo " | |   | |_   _(_)___  |_   _|__  _ __ ___   ___ ____| |_  | | | |____   __| | __ _| |_ ___  "
echo " | |   | | | | | / __|   | |/ _ \|  _   _ \ / __/ _  | __| | | | |  _ \ / _  |/ _  | __/ _ \ "
echo " | |___| | |_| | \__ \   | | (_) | | | | | | (_| (_| | |_  | |_| | |_) | (_| | (_| | ||  __/ "
echo " |_____|_|\__,_|_|___/   |_|\___/|_| |_| |_|\___\__,_|\__|  \___/| .__/ \__,_|\__,_|\__\___| "
echo "                                                                 |_|                         "
echo "---------------------------------------------------------------------------------------------"
echo -e "${blueColour}[info] Bienvenido a mi programa para actualizar Tomcat, ¿que deseas hacer?${endColour}"
echo""

tomcatSource=""
probeSource=""
catalinaJarSource=""
# Dar permsos de exec al prove directory
actualizarTomcat () {
	echo "Actualizar Tomcat"

	# Definir CATALINA_HOME
	echo -e "${greenColour}[#] Defina el path completo de CATALINA_HOME${endColour}"
	read catalinaHome
	
	# Definir USUARIO
	echo -e "${greenColour}[#] Defina el usuario${endColour}"
	read usuario

	# Aviso BACKUP!
	echo -e "${yellowColour}[alert] Anes de continuar, asegurate de tener backup de ${catalinaHome}${endColour}"
	read -p "Pulsa [Enter] para continuar"
	
	# Si no existe el directorio tomcat-8.5.72.A.RELEASE lo copiamos del RedHat_Test.
	if [ -d "/opt/pivotal/pivotal-tc-server-standard/tomcat-8.5.72.A.RELEASE" ]; then
		echo -e "${blueColour}[info] Ya existe el directorio tomcat-8.5.72.A.RELEASE${endColour}"
	else
		scp -r opertec@192.168.252.180:/home/opertec/tomcat-8.5.72.A.RELEASE /opt/pivotal/pivotal-tc-server-standard/
		echo -e "${blueColour}[info] Copiando tomcat-8.5.72.A.RELEASE...${endColour}"
		
		chown root:pivotal -R /opt/pivotal/pivotal-tc-server-standard/tomcat-8.5.72.A.RELEASE
		echo -e "${blueColour}[info] Cambiando el propietario de tomcat-8.5.72.A.RELEASE${endColour}"
		
		chmod 775 /opt/pivotal/pivotal-tc-server-standard/tomcat-8.5.72.A.RELEASE/bin/*
		echo -e "${blueColour}[info] Cambiando los permisos de binarios tomcat-8.5.72.A.RELEASE${endColour}"
	fi
	
	# Editamos el archivo setenv.sh
	sed -i 's/JAVA_HOME=.*$/JAVA_HOME="\/usr\/java\/jre8"/1' ${catalinaHome}/bin/setenv.sh
	echo -e "${blueColour}[info] Editando el archivo setenv.sh${endColour}"
	
	# Exportamos la variable JAVA_HOME
	export JAVA_HOME="/usr/java/jre8"
	echo -e "${blueColour}[info] Exportando la variable JAVA_HOME${endColour}"
	
	# Actualizamos el tomcat definido en CATALINA_HOME
	echo -e "${blueColour}[info] Actualizando tomcat...${endColour}"
	/opt/pivotal/pivotal-tc-server-standard/tcruntime-instance.sh upgrade -v 8.5.72.A.RELEASE ${catalinaHome}
	
	
	# Si existe catalina.jar lo elimina y lo copia de RedHat_Test, sino existe lo copia del RedHat_Test
	if [ -d "${catalinaHome}/lib/catalina.jar" ]; then
        rm ${catalinaHome}/lib/catalina.jar
		scp opertec@192.168.252.180:/home/opertec/catalina.jar ${catalinaHome}/lib/
		echo -e "${blueColour}[info] Eliminando catalina.jar antiguo${endColour}"
	else
		scp opertec@192.168.252.180:/home/opertec/catalina.jar ${catalinaHome}/lib/
        echo -e "${blueColour}[info] Copiando catalina.jar"
		
		# Cambia el propietario del archivo
        chown ${usuario}: ${catalinaHome}/lib/catalina.jar # Añadir grupo
        echo -e "${blueColour}[info] Cambiamos propietario de catalina.jar"
	fi
	
	# Fin
	echo -e "${yellowColour}[alert] Necesitas reiniciar el servicio${endColour}"
	menu
}

actualizarProbe () {
	echo "Actualizar Probe"
	
	# Definir CATALINA_HOME
	echo -e "${greenColour}[#] Defina el path completo de CATALINA_HOME${endColour}"
	read catalinaHome
	
	# Definir USUARIO
    echo -e "${greenColour}[#] Defina el usuario${endColour}"
	read usuario

	# Aviso BACKUP!
	echo -e "${yellowColour}[alert] Anes de continuar, asegurate de tener backup de ${catalinaHome}/webapps/probe.war${endColour}"
	read -p "Pulsa [Enter] para continuar"

	# Si el directorio probe existe lo elimina
	if [ -d "${catalinaHome}/webapps/probe" ]; then
		echo -e "${blueColour}[info] Ya existe el directorio ${catalinaHome}/webapps/probe${endColour}"
		echo -e "${blueColour}[info] Eliminando...${endColour}"
		rm -rf ${catalinaHome}/webapps/probe
		rm -rf ${catalinaHome}/work/Catalina/localhost/probe
	fi

	# Si el archivo probe.war existe lo elimina
	if [ -d "${catalinaHome}/webapps/probe.war" ]; then
                echo -e "${blueColour}[info] Ya existe el archivo ${catalinaHome}/webapps/probe.war${endColour}"
                echo -e "${blueColour}[info] Eliminando...${endColour}"
                rm -rf ${catalinaHome}/webapps/probe.war
    fi

	# Copia el archivo probe.war de RedHat_Test
	scp opertec@192.168.252.180:/home/opertec/probe.war ${catalinaHome}/webapps/
	echo -e "${blueColour}[info] Copiando probe.war...${endColour}"
	
	# Cambia el propietario del archivo
    chown ${usuario}: ${catalinaHome}/webapps/probe.war # Añadir grupo
    echo -e "${blueColour}[info] Cambiamos propietario de probe.war${endColour}"

	# Si catalina.jar existe elimina y copia catalina.jar de RedHat_Test, si no existe copia catalina.jar de RedHat_Test
	if [ -d "${catalinaHome}/lib/catalina.jar" ]; then
                rm ${catalinaHome}/lib/catalina.jar
				echo -e "${blueColour}[info] Eliminando catalina.jar antiguo${endColour}"
				scp opertec@192.168.252.180:/home/opertec/catalina.jar ${catalinaHome}/lib/
				echo -e "${blueColour}[info] Copiando el catalina.jar${endColour}"
	else
		scp opertec@192.168.252.180:/home/opertec/catalina.jar ${catalinaHome}/lib/
        echo -e "${blueColour}[info] Copiando catalina.jar${endColour}"
        
		# Cambia el propietario del archivo
		chown ${usuario}: ${catalinaHome}/lib/catalina.jar # Añadir grupo
        echo -e "${blueColour}[info] Cambiamos propietario de catalina.jar${endColour}"
	fi
	
	# Fin
    echo -e "${yellowColour}[alert] Necesitas reiniciar el servicio${endColour}"
	menu
}

salir () {
	echo "Hasta luego!"
	exit 0
}

others () {
	echo -e "${yellowColour}[alert] La opcion seleccionada no es correcta${endColour}"
	menu
}

menu () {
	# Menú interactivo
echo "----------------------------------------------"
echo "| 1) Actualizar Tomcat a la version 8.5.72.A |"
echo "| 2) Actualizar Probe a la version 3.3.1     |"
echo "| 0) Salir                                   |"
echo "----------------------------------------------"
	read selector
	case $selector in
		1)   actualizarTomcat ;;
		2)   actualizarProbe ;;
		0)   salir ;;
		*)   others ;;
	esac
}

menu

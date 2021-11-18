#!/bin/bash
# holamundo
endColour="\e[0m"
redColour="\e[0;31m"
greenColour="\e[0;32m"
yellowColour="\e[0;33m"
blueColour="\e[0;34m"
purpleColour="\e[0;35m"
cianColour="\e[0;36m"
greyColour="\e[0;37m"

# echo, todo lo que esté "" lo trata strings
# echo -e, los \e y otros caracteres los trata como excepciones

echo "  _     _       _       _____                         _     _   _           _       _        "
echo " | |   | |_   _(_)___  |_   _|__  _ __ ___   ___ ____| |_  | | | |____   __| | __ _| |_ ___  "
echo " | |   | | | | | / __|   | |/ _ \|  _   _ \ / __/ _  | __| | | | |  _ \ / _  |/ _  | __/ _ \ "
echo " | |___| | |_| | \__ \   | | (_) | | | | | | (_| (_| | |_  | |_| | |_) | (_| | (_| | ||  __/ "
echo " |_____|_|\__,_|_|___/   |_|\___/|_| |_| |_|\___\__,_|\__|  \___/| .__/ \__,_|\__,_|\__\___| "
echo "                                                                 |_|                         "
echo "---------------------------------------------------------------------------------------------"
echo -e "${blueColour}[info] Bienvenido a mi programa para actualizar Tomcat, ¿que deseas hacer?${endColour}"
echo""
echo "----------------------------------------------"
echo "| 1) Actualizar Tomcat a la version 8.5.72.A |"
echo "| 2) Actualizar Probe a la version 3.3.1     |"
echo "| 0) Salir                                   |"
echo "----------------------------------------------"

tomcatSource=""
probeSource=""
catalinaJarSource=""



actualizarTomcat () {
	echo "La funcion funciona"
}

actualizarProbe () {
	# Los archivos que descargamos hay que ponerles el propietario y los permisos correctos.
	
	echo "Actualizar Probe"

	echo "${greenColour}Defina el path completo de CATALINA_HOME?${endColour}"
	read catalinaHome

	echo -e "${yellowColour}[alert] Anes de comenzar, asegurate de tener backup de ${catalinaHome}${endColour}"
	read -p "Pulsa [Enter] para continuar"

	if [ -d "${catalinaHome}/webapps/probe" ] then
		echo -e "${blueColour}[info] Ya existe el directorio ${catalinaHome}/webapps/probe"
		echo -e "${blueColour}[info] Eliminando..."
		rm -rf ${catalinaHome}/webapps/probe
		rm -rf ${catalinaHome}/work/localhost/probe
	fi

	if [ -d "${catalinaHome}/webapps/probe.war" ] then
                echo -e "${blueColour}[info] Ya existe el archivo ${catalinaHome}/webapps/probe.war"
                echo -e "${blueColour}[info] Eliminando..."
                rm -rf ${catalinaHome}/webapps/probe.war
        fi

	echo -e "${blueColour}[info] Descargando probe.war..."
	wget probeSource -P ${catalinaHome}/webapps/

	if [ -d "${catalinaHome}/lib/catalina.jar" ] then
                echo -e "${blueColour}[info] Ya existe el archivo ${catalinaHome}/lib/catalina.jar"
	else
		wget catalinaJarSource -P ${catalinaHome}/lib/
		echo -e "${blueColour}[info] Descargando catalina.jar"
	fi
	
}

salir () {
	echo "Hasta luego!"
	exit 0
}

others () {
	echo -e "${yellowColour}[alert] La opcion seleccionada no es correcta${endColour}"
}

read selector
case $selector in
	1)   actualizarTomcat ;;
	2)   actualizarProbe ;;
	0)   salir ;;
  	*)   others ;;
esac




#while [ $selector !eq 1 || !eq 2 || !q 0] do
#	read selector
#	case $selector in
#        	1)   echo "Esto es el 1" ;;
#        	2)   echo "Esto es el 2";;
#        	0)   echo "Esto es el 0" ;;
#        	*)   echo "Selecciona una opcion valida";;
#	esac
#done



#!/usr/bin/env bash


echo ">>> Installing pdflib TET 4.3"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [ -z PHP_IS_INSTALLED ]; then
	echo "!!! PHP is not installed"; 
	exit 1;
fi

#Check that the pdflib has support for the installed php version
php_version=$(php -v | egrep -o "[0-9].[0-9]*" | head -n1)

if [ $php_version != "5.3" ] && [ $php_version != "5.4" ] && [ $php_version != "5.5" ] && [ $php_version != "5.6"]; then
	echo "!!! PHP version $php_version is not supported"
	exit;
fi

#Find the php extension_dir, or abort if it's not found
php_extension_dir=$(php -i | grep  "^extension_dir" | egrep -o "\/([A-Za-z0-9_\.\-]*\/*)*" | head -n1)

if [ -z $php_extension_dir ]; then
	echo "!!! PHP extension_dir not found"
	exit 1;
fi

php_ini_dir=$(php -i | grep "^Scan this dir for additional .ini files" | egrep -o "\/([A-Za-z0-9_\.\-]*\/*)*" | head -n1)
if [ -z $php_extension_dir ]; then
	echo "!!! PHP .ini directory not found"
	exit 1;
fi;


#Find the correct installation based on the version number and server type 32bit or 64bit
server=$(uname -m)

if [ $server = "x86_64" ]; then
	url="http://www.pdflib.com/binaries/TET/430/TET-4.3p1-Linux-x86_64.tar.gz"
else
	url="http://www.pdflib.com/binaries/TET/430/TET-4.3p1-Linux.tar.gz"
fi

#Halt installation if a unknown pdflib version number has been provided as an argument
if [ -z "$url" ]; then
	echo "!!! Unknown pdflib version: $pdflib_version"
	exit 1;
fi


curl -L $url > pdflib_TET.tar.gz

if [ ! -d "./pdflib_TET" ]; then
	mkdir pdflib_TET
fi

tar zxf pdflib_TET.tar.gz -C ./pdflib_TET --strip-components 1

php_so_file="php_tet.so"

if [ $php_version = "5.3" ]; then
	php_tet_dir="php-530";
elif [ $php_version = "5.4" ]; then
	php_tet_dir="php-540";
elif [ $php_version = 5.5 ]; then
	php_tet_dir="php-550";
else
	php_tet_dir="php-560";
fi

cp ./pdflib_TET/bind/php/$php_tet_dir/$php_so_file $php_extension_dir

ini_file="$php_ini_dir/pdflib_tet.ini"
if [ ! -f $ini_file ]; then
	touch $ini_file;
fi

cat > $ini_file << EOF
	extension=$php_so_file
EOF

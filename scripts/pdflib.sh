#!/usr/bin/env bash

if [ -z "$1" ]; then
	pdflib_version="9.0.2"
else
	pdflib_version="$1"
fi

echo ">>> Installing pdflib $pdflib_version"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [ -z PHP_IS_INSTALLED ]; then
	echo "!!! PHP is not installed"; 
	exit 1;
fi

#Check that the pdflib has support for the installed php version
php_version=$(php -v | egrep -o "[0-9].[0-9]*" | head -n1)

if [ $php_version != "5.3" ] && [ $php_version != "5.4" ] && [ $php_version != "5.5" ]; then
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
	
	if [ $pdflib_version = "8" ] || [ $pdflib_version = "8.0.6" ]; then
		url="http://www.pdflib.com/binaries/PDFlib/806/PDFlib-8.0.6-Linux-x86_64-php.tar.gz"
	elif [ $pdflib_version = "9" ] || [ $pdflib_version = "9.0.2" ]; then
		url="http://www.pdflib.com/binaries/PDFlib/902/PDFlib-9.0.2-Linux-x86_64-php.tar.gz"
	fi

else

	if [ $pdflib_version = "8" ] || [ $pdflib_version = "8.0.6" ]; then
		url="http://www.pdflib.com/binaries/PDFlib/806/PDFlib-8.0.6-Linux-php.tar.gz"
	elif [ $pdflib_version = "9" ] || [ $pdflib_version = "9.0.2" ]; then
		url="http://www.pdflib.com/binaries/PDFlib/902/PDFlib-9.0.2-Linux-php.tar.gz"
	fi

fi

#Halt installation if a unknown pdflib version number has been provided as an argument
if [ -z "$url" ]; then
	echo "!!! Unknown pdflib version: $pdflib_version"
	exit 1;
fi


curl -L $url > pdflib.tar.gz

if [ ! -d "./pdflib" ]; then
	mkdir pdflib
fi

#tar xvf PDFlib-8.0.6-Linux-php.tar.gz
#tar xvf PDFlib-8.0.6-Linux-x86_64-php.tar.gz
#cp PDFlib-8.0.6-Linux-php/bind/php/php-530/libpdf_php.so /usr/lib/php5/20090626+lfs/
#cp PDFlib-8.0.6-Linux-x86_64-php/bind/php/php-530/libpdf_php.so /usr/lib/php5/20090626/
#echo "extension=libpdf_php.so" > /etc/php5/conf.d/libpdf.ini

tar zxf pdflib.tar.gz -C ./pdflib --strip-components 1

if [ $pdflib_version = "9" ]; then
	php_so_file="php_pdflib.so" 
else
	php_so_file="libpdf_php.so"
fi

if [ $php_version = "5.3" ]; then
	php_pdflib_dir="php-530";
elif [ $php_version = "5.4" ]; then
	php_pdflib_dir="php-540";
else
	php_pdflib_dir="php-550";
fi

cp ./pdflib/bind/php/$php_pdflib_dir/$php_so_file $php_extension_dir

ini_file="$php_ini_dir/pdflib.ini"
if [ ! -f $ini_file ]; then
	touch $ini_file;
fi

cat > $ini_file << EOF
	extension=php_pdflib.so
EOF

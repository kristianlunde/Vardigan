Vardigan
========

Vagrant bash scripts

This repository contains provision bash scripts. Each script can be used as a standalone component or as part of a Vagrant provsion setup. These scripts are inspired by the [Vaprobash](https://github.com/fideloper/Vaprobash) repository by @fideloper. 

## Scripts

### pdflib

[Pdflib](http://www.pdflib.com/) is a powerful PDF generation and editing library. This script installs pdflib for PHP. 
Both Pdflib 8.0.6 and 9.0.2 are supported for PHP 5.3.x, 5.4.x and 5.5.x. This installer also support both 32 and 64bit systems. 

**Vagrant**

```bash
#Install pdflib 8.0.6
config.vm.provision "shell", path: "scripts/pdflib.sh", args: ["8.0.6"] 
#or install pdflib 9.0.2
config.vm.provision "shell", path: "scripts/pdflib.sh"
````

**Standalone**

```bash
#Install pdflib 8.0.6
$ ./scripts/pdflib.sh 8.0.6 


#Install pdflib 9.0.2
$ ./scripts/pdflib.sh
```

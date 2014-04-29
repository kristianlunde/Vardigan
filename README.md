Vardigan
========

Vagrant bash scripts

This repository contains provision bash scripts. Each script can be used as a standalone component or as part of a Vagrant provsion setup. These scripts are inspired by the ([Vaprobash](https://github.com/fideloper/Vaprobash)) repository by @fideloper. 

## Scripts

### pdflib

**Vagrant**

````bash
#Install pdflib 8.0.6
config.vm.provision "shell", path: "scripts/pdflib.sh", args: ["8.0.6"] 
#or install pdflib 9.0.2
config.vm.provision "shell", path: "scripts/pdflib.sh"

**Standalone**

```bash
#Install pdflib 8.0.6
$ ./scripts/pdflib.sh 8.0.6 

````bash
#Install pdflib 9.0.2
$ ./scripts/pdflib.sh


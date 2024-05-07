# hepoco.sh
Hetzner Port Control

Ein Tool dass mit der Hetzner Cloud API spricht.

###
Das Tool hat folgende abhängigkeiten:

Für Ubuntu/Debian:
sudo apt install jq

Für Macs:
/bin/bash -c "$(curl -fsSL raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install jq
###

Das Script holt beim öffnen des Ports die öffentlichen IPs (v4+v6) des Clients, von dem es ausgeführt wird. Es nutzt dabei die API von ipify.org
Sollte keine v6 verfügbar sein wählt es nur die v4 aus.

Danach wird der Port 22 (ssh) über die Hetzner Cloud API geöffnet. Hierbei werden als Quelle die oben erwähnten IPs eingetragen.

Es muss der Cloud API-Key in der Section "open Port" UND "close Port" eingegeben werden. 

Den API Key kann man sich in der Hetzner Cloud-Console unter "Sicherheit", API-Tokens generieren lassen. 
Der API Token ist pro Cloud-Projekt einmalig.

Ebenso muss das Script ausführbar gemacht werden: chmod+x

Verknüpfung als Anwendung: 
Die Datei hepoco.desktop in das Verzeichnis ".local/share/applications/" kopieren und bearbeiten/anpassen.


#######

# hepoco.sh
Hetzner Port Control

A tool that speaks to the Hetzner Cloud API.

###
The tool has the following dependencies:

For Ubuntu/Debian:
sudo apt install jq

For Macs:
/bin/bash -c "$(curl -fsSL raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install jq
###

When the port is opened, the script fetches the public IPs (v4+v6) of the client from which it is executed. It uses the API from ipify.org
If v6 is not available, it will only choose v4.

Port 22 (ssh) is then opened via the Hetzner Cloud API. The IPs mentioned above are entered as the source.

The Cloud API key must be entered in the “open port” AND “close port” section.

The API key can be generated in the Hetzner Cloud Console under “Security”, API tokens.
The API token is unique per cloud project.

The script must also be made executable: chmod+x

Link as an application:
Copy the file hepoco.desktop to the ".local/share/applications/" directory and edit it.

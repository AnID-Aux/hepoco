#!/bin/bash

# Funktion zum Öffnen des Ports
open_port() {
    echo "open Port 22"
    #!/bin/bash

# Hetzner Cloud API-Token (ersetze 'YOUR_API_TOKEN' durch dein eigenes Token)
api_token="YOUR_API_TOKEN"

# Hetzner Cloud API-Endpunkt
api_endpoint="https://api.hetzner.cloud/v1"

# Funktion zur Ermittlung der Firewall-ID anhand ihres Namens
get_firewall_id() {
    firewall_name=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls" | jq -r ".firewalls[].name")
    echo "$firewall_name"
}

# Funktion zur Ermittlung der öffentlichen IPv4-Adresse über ipify.org
get_public_ipv4() {
    public_ipv4=$(curl -s4 https://api.ipify.org)
    echo "$public_ipv4"
}

# Funktion zur Ermittlung der öffentlichen IPv6-Adresse über ipify.org
get_public_ipv6() {
    public_ipv6=$(curl -s6 https://api64.ipify.org || echo "")
    echo "$public_ipv6"
}

# Variablen für die öffentlichen IPv4- und IPv6-Adressen im CIDR-Format
ipv4_cidr="$(get_public_ipv4)/32"
ipv6_cidr="$(get_public_ipv6)/128"

# Funktion zum Aktualisieren der Firewallregeln
update_firewall() {
    # Firewallname abrufen
    firewall_name=$(get_firewall_id)

    # Firewall-ID abrufen
    firewall_id=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls" | jq -r ".firewalls[] | select(.name == \"$firewall_name\") | .id")

    # IPv4-Adresse des Clients abrufen
    ipv4_address=$(get_public_ipv4)
    # IPv6-Adresse des Clients abrufen
    ipv6_address=$(get_public_ipv6)

    # Aktuelle Regeln abrufen
    current_rules=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls/$firewall_id" | jq -r '.firewall.rules')

    # Neue Regel für SSH mit IPv4 und IPv6 des Clients definieren
    if [ -n "$ipv6_address" ]; then
        new_rule='{"description":"SSH","direction":"in","port":"22","protocol":"tcp","source_ips":["'"$ipv4_address"'/32","'"$ipv6_address"'/128"]}'
        success_message="Firewall rule SSH (port 22) successfully created with your own public IPv4 and IPv6. Port 22 is open!"
    else
        new_rule='{"description":"SSH","direction":"in","port":"22","protocol":"tcp","source_ips":["'"$ipv4_address"'/32"]}'
        success_message="Firewall rule SSH (port 22) successfully created with your own public IPv4 (IPv6 was not available). Port 22 is open!"
    fi

    # Aktuelle Regeln beibehalten und neue Regel hinzufügen
    updated_rules=$(echo "$current_rules" | jq --argjson newRule "$new_rule" '. + [$newRule]')

    # Firewallregeln aktualisieren
    local response=$(curl -s -X POST \
        -H "Authorization: Bearer $api_token" \
        -H "Content-Type: application/json" \
        -d "{\"rules\":$updated_rules}" \
        "$api_endpoint/firewalls/$firewall_id/actions/set_rules")

    if [[ "$(echo "$response" | jq -r '.error')" == "null" ]]; then
        echo "$success_message"
    else
        echo "Failed to update firewall rules: $response"
    fi

}

# Aufruf der Funktion zum Aktualisieren der Firewallregeln
update_firewall

}

# Funktion zum Schließen des Ports
close_port() {
    echo "close Port 22"
    #!/bin/bash

# Hetzner Cloud API-Token (ersetze 'YOUR_API_TOKEN' durch dein eigenes Token)
api_token="YOUR_API_TOKEN"

# Hetzner Cloud API-Endpunkt
api_endpoint="https://api.hetzner.cloud/v1"

# Funktion zur Ermittlung der Firewall-ID anhand ihres Namens
get_firewall_id() {
    firewall_name=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls" | jq -r ".firewalls[].name")
    echo "$firewall_name"
}

# Funktion zum Entfernen der SSH-Regel aus der Firewall
remove_ssh_rule() {
    # Firewallname abrufen
    firewall_name=$(get_firewall_id)

    # Firewall-ID abrufen
    firewall_id=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls" | jq -r ".firewalls[] | select(.name == \"$firewall_name\") | .id")

    # Aktuelle Regeln abrufen
    current_rules=$(curl -s -H "Authorization: Bearer $api_token" "$api_endpoint/firewalls/$firewall_id" | jq -r '.firewall.rules')

    # Neue Regel für SSH mit IPv4 und IPv6 des Clients definieren
    new_rule='{"description":"SSH","direction":"in","port":"22","protocol":"tcp"}'

    # Aktuelle Regeln ohne die SSH-Regel filtern
    updated_rules=$(echo "$current_rules" | jq --argjson newRule "$new_rule" 'map(select(.description != "SSH"))')

    # Firewallregeln aktualisieren
    local response=$(curl -s -X POST \
        -H "Authorization: Bearer $api_token" \
        -H "Content-Type: application/json" \
        -d "{\"rules\":$updated_rules}" \
        "$api_endpoint/firewalls/$firewall_id/actions/set_rules")

    if [[ "$(echo "$response" | jq -r '.error')" == "null" ]]; then
        echo "Firewall rule SSH (port 22) with your own public IPs (v4+v6) successfully deleted. Port is closed!"
    else
        echo "Failed to update firewall rules: $response"
    fi

}

# Aufruf der Funktion zum Entfernen der SSH-Regel
remove_ssh_rule
}

# Nachricht über dem Menü
echo "V00D00s Hetzner Cloud SSH-Port-22 opener/closer, please choice:"
echo "1=open Port 22"
echo "2=close Port 22"

# Benutzereingabe lesen
read -p "Your Choice: " choice

# Fallunterscheidung basierend auf der Benutzerauswahl
case $choice in
    1) open_port ;;
    2) close_port ;;
    *) echo "invalid selection" ;;
esac

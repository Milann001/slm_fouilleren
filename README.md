Een lichtgewicht en realistische FiveM resource waarmee spelers elkaar kunnen fouilleren met toestemming. Dit script maakt gebruik van de populaire Overextended (OX) library en inventory.

🚀 Functies
Toestemmingssysteem: Spelers moeten eerst een verzoek accepteren voordat ze gefouilleerd kunnen worden.

Realistische Positie: De speler die fouilleert wordt automatisch recht achter het doelwit geplaatst.

Animatie & Progressbar: Bevat een 5-seconden durende fouilleer-animatie.

OX Inventory Integratie: Opent de daadwerkelijke inventory van de andere speler.

Afstandsbeveiliging: De inventory sluit automatisch zodra de speler wegloopt (anti-abuse).

🛠 Vereisten
Om deze resource te gebruiken, moet je de volgende scripts geïnstalleerd hebben:

ox_lib

ox_target

ox_inventory

📦 Installatie
Download de resource of kloon de repository naar je resources map.

Hernoem de map naar ox-playersearch.

Voeg ensure ox-playersearch toe aan je server.cfg.

📖 Gebruik
Loop naar een andere speler toe.

Houd je Alt toets ingedrukt (ox_target) en richt op de speler.

Selecteer de optie Fouilleren.

De andere speler krijgt een melding op het scherm om het verzoek te Accepteren of te Weigeren.

Bij acceptatie zal de fouilleer-animatie starten en opent de inventory na 5 seconden.

⚙️ Configuratie
Je kunt de afstanden en animatieduur eenvoudig aanpassen in de client.lua:

Afstand check: Pas dist > 2.5 aan om de sluitafstand te veranderen.

Duur: Pas duration = 5000 aan om de fouilleertijd te verlengen of te verkorten.

Zoals je misschien ook al aan het stukje tekst hierboven kan zien is deze resource volledig met AI gemaakt. Alles is getest en werkt ook zoals het hoort!

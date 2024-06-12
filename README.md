# StudyO Mobile App


StudyO je mobilna edukativna aplikacija za osnovnoškolce koja kroz igru i personalizaciju potiče učenje. Glavne značajke uključuju:

Personalizaciju: Korisnici kreiraju vlastite avatare i prilagođavaju kvizove koristeći AI na temelju bilješki s nastave.

Interaktivnost: Dnevni kviz izazovi s prijateljima i prilagođeni kvizovi po razredima potiču redovito učenje.

Inkluzivnost: Prilagodbe sadržaja omogućavaju pristupačnost djeci s posebnim potrebama.

Cilj Studyja je učiniti učenje zabavnim i dostupnim za svu djecu, potičući njihov razvoj i produktivnost kroz inovativne i korisnički prilagođene funkcije.

## Table of Contents
- [Introduction / Project Overview](#introduction--project-overview)
- [Visuals](#visuals)
- [Installation](#installation)
- [Usage](#usage)
- [Support](#support)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Authors and Acknowledgment](#authors-and-acknowledgment)
  


## Introduction / Project Overview

Dobrodošli u naš projekt! Ova aplikacija dizajnirana je sa ciljem da učenje učini zabavnim i produktivnim za djecu. Kombiniramo inovativne pedagoške pristupe s najnovijom tehnologijom kako bismo stvorili interaktivno okruženje koje potiče djecu na učenje kroz igru.

<a href="https://imgur.com/P1bdFHI"><img src="https://i.imgur.com/P1bdFHI.png" title="source: imgur.com" width="1000" /></a>

Na slici iznad možete vidjeti kako su organizirane ključne komponente našeg projekta. Slika pruža brz uvid u tehničku infrastrukturu i kako su pojedine faze i komponente projektirane da surađuju unutar projekta.


## Visuals

Prvi zaslon koji korisnici vide je naš splash screen, dostupan u obje teme - svijetloj i tamnoj. Ovo osigurava da aplikacija pruža ugodno iskustvo u različitim svjetlosnim uvjetima.

<a href="https://imgur.com/VFxggwt"><img src="https://i.imgur.com/VFxggwt.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/o1C5mjc"><img src="https://i.imgur.com/o1C5mjc.jpg" title="source: imgur.com" width="150"/></a>

Nakon uvodnog ekrana, korisnici su dočekani s glavnim sučeljem aplikacije, koje također podržava svijetlu i tamnu temu. U nastavku su prikazani glavni screenovi aplikacije u svijetloj temi.

<a href="https://imgur.com/Pg5CHeS"><img src="https://i.imgur.com/Pg5CHeS.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/YNLZ0Hl"><img src="https://i.imgur.com/YNLZ0Hl.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/lJ7avB3"><img src="https://i.imgur.com/lJ7avB3.jpg" title="source: imgur.com" width="150" /></a> <a href="https://imgur.com/9knqTCr"><img src="https://i.imgur.com/9knqTCr.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/rP1vBia"><img src="https://i.imgur.com/rP1vBia.jpg" title="source: imgur.com" width="150"/></a>


## Installation

### Instalacija Frontenda (Flutter)

Preduvjeti:
Instalirajte Flutter SDK. Posjetite https://docs.flutter.dev/get-started/install za detaljne upute ovisno o vašem operacijskom sustavu.

Ako koristite VS Code, Android Studio ili IntelliJ, provjerite da su instalirani Dart i Flutter pluginovi.
Kloniranje repozitorija:

```bash
  git clone [URL repozitorija]
  cd [ime repozitorija]
```
Instalacija dependencyja:

```bash
  flutter pub get
```
Pokretanje aplikacije:
```bash
  flutter run
```

### Dependencies - Flutter

- **intl**: Omogućava lakšu internacionalizaciju i lokalizaciju aplikacija.
- **cupertino_icons**: Standardni set ikona koji se koristi za iOS stil sučelja.
- **fluttermoji**: Omogućava korisnicima da kreiraju prilagođene avatare.
- **http**: Korišten za izradu HTTP zahtjeva za komunikaciju s backendom.
- **syncfusion_flutter_gauges**: Koristi se za prikaz mjerača i dashboarda unutar aplikacije.
- **google_fonts**: Omogućava korištenje raznovrsnih fontova direktno iz Google Fonts.
- **provider**: Biblioteka za upravljanje stanjem aplikacije, koristi se za efikasniju arhitekturu.
- **url_launcher**: Omogućava lansiranje URL-ova, korisno za otvaranje web stranica iz aplikacije.
- **flutter_dotenv**: Koristi za učitavanje konfiguracijskih postavki iz .env datoteka.
- **flutter_donation_buttons**: Koristi se za implementaciju gumbiju za donacije.
- **fl_chart**: Omogućava izradu kompleksnih grafikona unutar aplikacije.
- **shared_preferences**: Omogućava jednostavno spremanje i dohvaćanje podataka iz lokalne pohrane uređaja.
- **firebase_core**: Osnovna biblioteka Firebase SDK-a koja pruža osnovne funkcionalnosti za rad s Firebaseom u Flutter aplikacijama.
- **firebase_messaging**: Omogućava primanje push obavijesti (push notifikacija) u Flutter aplikacijama pomoću Firebase Cloud Messaginga.
- **flutter_local_notifications**: Omogućava prikaz lokalnih notifikacija unutar aplikacije.
- **flutter_timezone**: Pruža podršku za dobivanje informacija o vremenskoj zoni i manipulaciju vremenom unutar aplikacije.
- **rxdart**: Biblioteka za reaktivno programiranje u Dartu, omogućava lakše upravljanje podacima i stanjima aplikacije.
- **flutter_launcher_icons**: Omogućava generiranje ikona aplikacije za različite platforme i uređaje.
- **firebase_auth**: Omogućava integraciju s Firebase Authenticationom za autentikaciju korisnika unutar aplikacije.







### Backend Implementacija

Trenutno, backend za aplikaciju StudyO je u fazi usavršavanja i izrade te će biti implementiran u nadolazećoj fazi projekta. Detalji implementacije i specifikacije će biti objavljeni kako projekt napreduje. U međuvremenu, frontend aplikacija je funkcionalna i može se koristiti za pregled i testiranje osnovnih funkcionalnosti.


## Usage


### Prijava i registracija
- **Prijava:** Prijavite se unoseći svoje korisničke podatke na stranici za prijavu.
- **Registracija:** Ako nemate račun, registrirajte se popunjavanjem potrebnih informacija i odgovaranjem na dodatna pitanja nakon uspješne verifikacije mailom.

<a href="https://imgur.com/dzjqvqi"><img src="https://i.imgur.com/dzjqvqi.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/yKXLI6c"><img src="https://i.imgur.com/yKXLI6c.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/Bo9Qk2G"><img src="https://i.imgur.com/Bo9Qk2G.jpg" title="source: imgur.com" width="150"/></a>

### Homepage
- **Leaderboard:** Pregledajte leaderboard koji prikazuje korisnike s najviše bodova.
- **Aktivnosti:** Prikazuje vaše dnevne bodove, streak i broj riješenih kvizova.
- **Navigacija:** Koristite donji meni za navigaciju između različitih stranica.

<a href="https://imgur.com/Pg5CHeS"><img src="https://i.imgur.com/Pg5CHeS.jpg" title="source: imgur.com" width="150" /></a> <a href="https://imgur.com/bxNQR0O"><img src="https://i.imgur.com/bxNQR0O.jpg" title="source: imgur.com" width="150"/></a>

### Lista predmetnih izazova
- Pregledajte listu predmeta i odaberite željeni predmet te kliknite na njega prikaz dostupnih kvizova.
- Kliknite na kviz koji želite igrati i pratite upute na ekranu (točni odgovori prikazani su zelenom bojom, a netočni naranđastom). Na kraju kviza moći ćete provjeriti točne odgovore, a klikom na "OK!" vraćate se na homepage.
- Napomena kako su kvizovi pisani po školskom kurikulumu kako biste mogli riješavati kvizove o gradivu koje ste uistinu i radili u školi.

<a href="https://imgur.com/YNLZ0Hl"><img src="https://i.imgur.com/YNLZ0Hl.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/fmFUB4A"><img src="https://i.imgur.com/fmFUB4A.jpg" title="source: imgur.com" width="150"/></a> <a href="https://imgur.com/k9B3I1b"><img src="https://i.imgur.com/k9B3I1b.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/Yif1dv7"><img src="https://i.imgur.com/Yif1dv7.jpg" title="source: imgur.com" width="150" /></a> <a href="https://imgur.com/U5IfWgn"><img src="https://i.imgur.com/U5IfWgn.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/PcKK41a"><img src="https://i.imgur.com/PcKK41a.jpg" title="source: imgur.com"  width="150"/></a>

### Tvoj kviz
- Unesite gradivo ili bilješke s nastave i generirajte svoj AI kviz!
- Odaberite težinu pitanja pomoću slajdera (lagano, srednje, teško).
- Kliknite na "Generiraj kviz" za stvaranje kviza ili na "Zaigraj kviz" za povratak na stranicu s kvizovima.

<a href="https://imgur.com/jjUrpQO"><img src="https://i.imgur.com/jjUrpQO.jpg" title="source: imgur.com" width="150" /></a>

### Izazovi
- **Izazovi prijatelja:** Odaberite opciju za slanje izazova, izaberite prijatelja i kviz, zatim pošaljite izazov.
- **Igraj izazove:** Pregledajte i igrajte izazove koje su vam poslali vaši prijatelji.

<a href="https://imgur.com/eACOWkR"><img src="https://i.imgur.com/eACOWkR.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/CgkNENX"><img src="https://i.imgur.com/CgkNENX.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/S11UfBA"><img src="https://i.imgur.com/S11UfBA.jpg" title="source: imgur.com" width="150" /></a>

### Moj profil
- Prilagodite svoj avatar srednjim gumbom ispod avatara i pregledajte osobne informacije na kraju profila.
- Pregledajte tjedni grafikon s bodovima za praćenje vašeg napretka.
- Klikom na lijevi gumb ispod avatara, vratite se na predmetne kvizove, a klikom na desni gumb ispod avatara provjerite svoju listu prijatelja.

<a href="https://imgur.com/rP1vBia"><img src="https://i.imgur.com/rP1vBia.jpg" title="source: imgur.com" width="150" /></a> <a href="https://imgur.com/5NMMGHx"><img src="https://i.imgur.com/5NMMGHx.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/RvUKdNH"><img src="https://i.imgur.com/RvUKdNH.jpg" title="source: imgur.com"  width="150"/></a>

### Hamburger meni
- **Avatar  i osobni podaci:** Ovdje možete vidjeti Vaš avatar i razred.
- **Postavke:** Omogućite prilagođavanje za posebne potrebe, odaberite jezik, omogućite zvukove ili pročitajte pojedinosti o korisniku i provjeru postavki privatnosti. Klikom na "Pojedinosti o korisniku" možete vidjeti sve svoje podatke koje dijelite s nama, a klikom na "Provjeru postavki privatnosti" provjerite svoja prava i privatnost. U ovim postavkama klik na widget o pravima i zaštiti djece odvest će Vas na UNICEF-ovu stranicu gdje se možete pobliže upoznati sa svojim pravima i sigurnošću.
- **Izazovi:** Pregledajte i igrajte izazove koje su Vam poslali vaši prijatelji.
- **Zahtjevi za prijateljstvo:** Pregledajte zahtjteve za prijateljstvo koje su Vam poslali vaši prijatelji.
- **Odjava:** Odjavite se sa svog korisničkog računa.
- **Tema:** Birajte tamni ili svijetli način rada.

<a href="https://imgur.com/mn3Fk4B"><img src="https://i.imgur.com/mn3Fk4B.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/Mc0lNmB"><img src="https://i.imgur.com/Mc0lNmB.jpg" title="source: imgur.com" width="150" /></a> <a href="https://imgur.com/3VDlzMx"><img src="https://i.imgur.com/3VDlzMx.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/kZdT2xq"><img src="https://i.imgur.com/kZdT2xq.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/qYwCShJ"><img src="https://i.imgur.com/qYwCShJ.jpg" title="source: imgur.com"  width="150"/></a> <a href="https://imgur.com/y65nSFi"><img src="https://i.imgur.com/y65nSFi.jpg" title="source: imgur.com" width="150" /></a>

## Support

Ako imate bilo kakvih pitanja ili trebate pomoć, slobodno se obratite na bilo koju od sljedećih adresa e-pošte. Naš tim će Vam rado pomoći.

- Opća podrška: trozman@tvz.hr
- Tehnička pomoć: kcoha@tvz.hr
- Pitanja o suradnji: bmaracic@tvz.hr

Molimo Vas da prilikom slanja e-pošte navedete što detaljniji opis Vašeg upita kako bismo Vam mogli što bolje pomoći.


## Roadmap

### Kratkoročni ciljevi (1-6 mjeseci)
1. **Poboljšanje i nadogradnja AI funkcionalnosti**
   - Razviti naprednije AI algoritme za personalizirano učenje.
   - Testirati i implementirati nove AI značajke koje pomažu u povećanju produktivnosti učenja.
   
2. **Istraživanje i ankete za povratne informacije**
   - Provoditi redovite ankete među korisnicima kako bi se dobile povratne informacije za poboljšanje aplikacije.
   - Analizirati podatke za bolje razumijevanje potreba i želja korisnika.

3. **Prilagodbe za djecu s posebnim potrebama**
   - Razviti značajke prilagođene za slijepe i gluhe korisnike te ostale posebne potrebe.
   - Suradnja s stručnjacima za osiguranje adekvatne podrške i inkluzivnosti.

### Srednjoročni ciljevi (6-12 mjeseci)
4. **Početak ekspanzije publike na srednjoškolce**
   - Razvijati sadržaj i funkcionalnosti koje su prilagođene potrebama srednjoškolaca.
   - Provesti pilot-projekt u nekoliko srednjih škola kako bi se testirala prihvatljivost aplikacije.

5. **Proširenje tima**
   - Proširenje s dodatnim članovima tima.
   - Organiziranje treninga za nove članove tima kako bi se osigurala kvaliteta i dosljednost rada.

### Dugoročni ciljevi (1-5 godina)
6. **Ekspanzija na međunarodno tržište**
   - Lokalizacija aplikacije za različite jezike i kulture.
   - Istraživanje specifičnih tržišta i prilagodba sadržaja prema lokalnim obrazovnim standardima.

7. **Targetiranje studenata fakulteta**
   - Razvoj modula i kurseva koji su usmjereni na akademske potrebe studenata.
   - Partnerstva s fakultetima i univerzitetima za integraciju aplikacije u obrazovni proces.

### Neprekidna evaluacija i prilagodba
- Stalna optimizacija i unapređenje.
- Kontinuirano provjeravanje s korisnicima putem istraživanja i anketa.
- Brzo reagiranje na povratne informacije i implementacija neophodnih izmjena.


## Contributing

Zahvaljujemo na interesu za naš projekt! Mi smo grupa studentica koja radi na ovom projektu s puno entuzijazma. Iako trenutno radimo kao zatvoreni tim, uvijek smo otvoreni za nove ideje i suradnike koji bi mogli doprinijeti našem zabavno-edukativnom sustavu i pomaganju djeci.

### How to join us?
Ako se vidite kao dio našeg tima i želite se pridružiti, ovdje je kako to možete učiniti:

1. **Pošaljite nam e-mail**: Pišite nam na bmaracic@tvz.hr s Vašim idejama ili prijedlozima, kratkim opisom Vaših vještina ili iskustava koja smatrate korisnima. Uključite što Vas motivira da radite na ovom projektu.
2. **Upoznajmo se**: Ako se čini da postoji dobar fit, organizirat ćemo kratki online sastanak. To nam daje priliku da razgovaramo više o projektu, vašim idejama i kako bismo mogli surađivati.
3. **Zajednički rad**: Ako se složimo da postoji zajednički interes, možemo početi raditi zajedno na projektu. Cijenimo svaki doprinos i vjerujemo da timski rad može donijeti najbolje rezultate.

Svi u timu imaju važnu ulogu u stvaranju nečeg korisnog i zabavnog, stoga tražimo osobe koje su strastvene prema stvaranju edukativnih rješenja i koje žele napraviti pozitivnu promjenu u svijetu obrazovanja.

Zajedno možemo ostvariti veliki utjecaj na edukaciju i unaprijediti živote mnoge djece!


## Authors and Acknowledgment

### Authors
Ovaj projekt je rezultat napornog rada i predanosti sljedećih autora:
- **Karla Coha** - [LinkedIn profil](https://www.linkedin.com/in/karla-coha-b2248b299?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app)
- **Barbara Maračić** - [LinkedIn profil](https://www.linkedin.com/in/barbara-mara%C4%8Di%C4%87-3414a1264?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app)
- **Tamara Rožman** - [LinkedIn profil](https://hr.linkedin.com/in/tamara-ro%C5%BEman-912051258?trk=public_profile_browsemap-profile)

Svaki od autora pridonio je jedinstvenim vještinama i perspektivama, što je omogućilo razvoj ovog inovativnog i edukativnog sustava.

### Acknowledgments
Posebnu zahvalu želimo uputiti našoj mentorskoj firmi, **Pontisu**, čija su podrška i vodstvo bili vrlo bitni u realizaciji ovog projekta. Njihovo stručno znanje i iskustvo pomogli su nam da prevladamo brojne izazove i uspješno razvijemo našu aplikaciju. Također, zahvaljujemo i samoj organizaciji na konceptu mc2 natjecanja koje nam je omogućilo napredovanje ovog projekta i potaklo nas da naučimo nove stvari i steknemo bitna poznanstva.

Također, zahvaljujemo se svima koji su direktno ili indirektno doprinijeli našem projektu, inspirirajući nas i pružajući podršku kroz cijeli proces razvoja i, naravno, našim osnovnoškolcima na feedbacku i interesu za korištenjem Studyja!


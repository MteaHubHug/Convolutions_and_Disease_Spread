# Convolutions_and_Disease_Spread
UVOD:
Teme ovog seminarskog rada su konvolucije i širenje zaraze. Kakvu direktnu vezu možemo uspotaviti između ta dva pojma? 

Za početak moramo znati što je uopće konvolucija u matematici i računarstvu te za što ju koristimo.
Matematičku definiciju operatora konvolucije ćemo ostaviti po strani te ćemo se baviti intuitivnim shvaćanjem. Ono za što će u ovoj temi konvolucije biti korisne je obrada slika.
Recimo da imamo sliku te ju želimo obraditi kako bismo dobili filtriranu verziju te slike koja će nam biti pogodnija za analizu. Konvoluciju možemo gledati
kao funkciju pomoću koje filtriramo. 

Kada govorimo o širenju zaraze, ima smisla zapitati se o kojoj zarazi je riječ. Kako je 2021. godina, aktualna tema je virus COVID-19. 
Iz tog razloga će biti promatrani i analizirani podaci o širenju zaraze tzv. "Corona virusom". Dakle, podaci će biti obrađeni, vizualizirani 
te će biti provedene simulacije zaraze i oporavka. Širenje zaraze se može vrlo naivno predočiti stablastima grafovima i funkcijama koje opisuju zarazu.
Naravno, za simulacije i oporavak je potreban neki bolji, stohastički model. Takav model će biti promatran u mikro i makro verziji te
u diskretnom i u kontinuiranom vremenu.

MOTIVACIJA : 

Ostaje otvoreno pitanje : "Koja je poveznica između konvolucija i COVID-a 19 ???".
Moj odgovor je da to mogu biti i dva potpuno disjunktna pojma, ali možemo govoriti o iskorištavanju konvolucija za obradu rengenskih snimaka pluća.
Zamislimo da liječnici žele izoštriti, posvijetliti ili potamniti sliku kako bi ju mogli bolje analizirati.
Još bolje iskorištavanje je ako hranimo konvolucijsku neuronsku mrežu snimcima pluća zaraženih, oporavljenih i onih koji nikad nisu bili u kontaktu s virusom.
Tada bismo mogli istrenirati model na slikama i dobiti model koji kada mu damo novi rengenski snimak, zna je li vlasnik plućnog krila sa slike bio u kontaktu s virusom. 
Dakle, konvolucije se zaista primjenjuju u dijagnostici u vidu klasifikacije.

Navedena motivacija je ipak više područje umjetne inteligencije, a ono na čemu je naglasak,
ali vrlo implicitno u ovom seminaru jest - upoznavanje s jezikom Julia za potrebe numeričke linearne algebre u okruženju Pluto reaktivnih bilježnica.

SAŽETAK:
U jeziku Julia i okruženju kao što su Pluto bilježnice zaista se mogu primijenjivati konvolucije na razne načine u korisne svrhe. 
Pokazano je kako funkcionira kernel i kako se dolazi do filtriranih slika te značajnost konvolucija za optimiziranje i ubrzanje računanja.
Julia je također moćan jezik za obradu i vizualizaciju podataka. Paketi za Juliju omogućavaju prikaz okvira podataka, 
ekplorativnu analizu i crtanje grafova. Iz grafova se dalo zaključiti da se zaraza koju smo pratili širila ekponencijalno,
ali smo prikazali i kako izgleda širenje zaraze pomoću stablastog modela. To sve daje uvid u situaciju i zgodno je za dobivanje rezultata koji 
se mogu analizirati i na temelju kojih donosimo zaključke, ali prava korisnost je u vidu simulacija kojima možemo predvidjeti što će se dogoditi 
te na temelju tih simulacija donositi odluke i pomoći sprječavanju zaraze. 
U ovom seminarskom radu je obrađen stohastički model oporavka te je iz njega lako zaključiti koliki je vremenski period potreban da se određen broj ljudi oporavi. 

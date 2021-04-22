### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 9a0cec14-08db-11eb-3cfa-4d1c327c63f1
begin
	using Plots
	using PlutoUI
	using Statistics
end

# ╔═╡ a3b2accc-0845-11eb-229a-e97bc3943016
md"""
## Od mikro do makro & od diskretnog do kontinuiranog
"""

# ╔═╡ ff32d32a-dbda-4990-a316-e76a1ff8f04f
md"Proučavat ćemo kako se iz mikroskopsih stohastičkih modela (mala zajednica, mjesto) razvijaju makroskopski "

# ╔═╡ 123d447c-43f4-4c3b-b4b0-09a57ef22b77
md"U teoriji vjerojatnosti i srodnim poljima, stohastički ili slučajni proces je matematički objekt koji se obično definira kao obitelj slučajnih varijabli"

# ╔═╡ ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
md"""
Mikroskopski stohastički modeli, intuitivni su i korisni za uključivanje različitih učinaka. No, često nas zapravo zanima globalna (makro) slika o tome kako se epidemija razvija s vremenom: koliko je ukupno zaraznih jedinki u određenom trenutku, na primjer.

U ovoj ćemo bilježnici vidjeti da je često moguće sažeti **mikroskopsku dinamiku** **stohastičkog modela** koristeći **determinističke** jednadžbe za **makroskopski** opis.

Te makroskopske jednadžbe mogu biti u diskretnom vremenu (**odnosi ponavljanja** ili **diferencijalne jednadžbe**), ili možemo uzeti **kontinuiranu granicu** i pretvoriti ih u **obične diferencijalne jednadžbe**.

Cilj nam je zaplet poput sljedećeg:

"""

# ╔═╡ 69790bfa-b302-4b47-86c9-a997fee4e45e
md"Kako dolazimo do ovog - uradimo stohastičke simulacije pa uzmemo prosjeke.
Dakle, MEAN ili srednja vrijednost mnogo različitih simulacija nam daju ovakve krivulje : "

# ╔═╡ f9a75ac4-08d9-11eb-3167-011eb698a32c
md"""
Vratimo se modelu oporavka od zaraze, s dopuštenim prijelazima $I \to R$:

> imamo $N$ zaraženih ljudi u trenutku $0$. Ako svaki ima vjerojatnost $p$ da se oporavi svaki dan, koliko ih je još zaraženih na dan broj $t$?

Upotrijebimo pristup računalnog razmišljanja (computational thinking): krenimo kodiranjem simulacije i crtanjem rezultata:
"""

# ╔═╡ ba7ffe78-0845-11eb-2847-851a407dd2ec
bernoulli(p) = rand() < p 

# ╔═╡ d088ed2e-0845-11eb-0697-310f374effbc
N = 200

# ╔═╡ e2d764d0-0845-11eb-0031-e74d2f5acaf9
function step!(infectious, p)
	for i in 1:length(infectious)
		
		if infectious[i] && bernoulli(p)
			infectious[i] = false
		end
	end
	
	return infectious
end

# ╔═╡ 9282eca0-08db-11eb-2e36-d761594b427c
T = 100

# ╔═╡ 58d8542c-08db-11eb-193a-398ce01b8635
begin
	infected = trues(N)
		
	results = [copy(step!(infected, 0.05)) for i in 1:T]
	pushfirst!(results, trues(N))
end

# ╔═╡ 8d6c0c06-08db-11eb-3790-c98fdc545352
@bind i Slider(1:T, show_value=true) # vrijeme

# ╔═╡ 7e1b61ac-08db-11eb-209e-1d6c328f5113
begin
	scatter(results[i], 
		alpha=0.5, size=(300, 200), leg=false, c=Int.(results[i]))
	
	annotate!(N, 0.9, text("$(count(results[i]))", 10))
	annotate!(N, 0.1, text("$(N - count(results[i]))", 10))
	
	ylims!(-0.1, 1.1)
	
	xlabel!("i")
	ylabel!("X_i(t)")

end

# ╔═╡ b390c7c5-d9e2-4c1e-8040-e14be9abc32d

md"
~~~~~
x- os predstavlja osobe - i je indeks osobe

y- os je X_i(t) - dakle, slučajna varijabla koja je jednaka =1 ako je osoba zaražena, a poprima vrijednost 0 ako se osoba oporavi tijekom vremena 
~~~~~
"

# ╔═╡ 33f9fc36-0846-11eb-18c2-77f92fca3176
function simulate_recovery(p, T)
	infectious = trues(N)
	num_infectious = [N] # niz ima samo jedan element na početku -> el. N
	
	for t in 1:T
		step!(infectious, p)
		push!(num_infectious, count(infectious))# push! dodaje elemente na kraj niza
	end                 # brojimo zaražene pomoću count()
	
	return num_infectious
end

# ╔═╡ 39a69c2a-0846-11eb-35c1-53c68a9f71e5
p = 0.1

# ╔═╡ 4fedb9ea-8c1f-444e-889f-0e042708dd64
md"Na ovom grafu ispod su prikazane dvije simulacije - vidimo da su krivulje slične :"

# ╔═╡ cb278624-08dd-11eb-3375-276bfe8d7b3a
begin
	pp = 0.05
	
	plot(simulate_recovery(pp, T), label="run 1", alpha=0.5, lw=2, m=:o)
	plot!(simulate_recovery(pp, T), label="run 2", alpha=0.5, lw=2, m=:o)
	
	xlabel!("vrijeme t")
	ylabel!("broj infekcija")
end

# ╔═╡ f3c85814-0846-11eb-1266-63f31f351a51
all_data = [simulate_recovery(pp, T) for i in 1:30];

# ╔═╡ 2c4e8064-4b26-4378-ba2f-1068d2a90dc3
md"Puno simulacija - stohastički model izgleda kao dolje na grafu...
Imamo puno 'runova' - tj. simulacija i svaka nam daje krivulju zaraženih ljudi po vremenu"

# ╔═╡ 01dbe272-0847-11eb-1331-4360a575ff14
begin
	plot(all_data, alpha=0.1, leg=false, m=:o, ms=1,
		size=(500, 400), label="")
	xlabel!("vrijeme t")
	ylabel!("broj infekcija")
end

# ╔═╡ 9f44e1fa-d867-4071-ae32-f9b3e0c10f53
md"Uzimamo mean svih krivulja - to je crvena krivulja. 
Mi trebamo pogoditi iz grafa o kojoj se funkciji radi. Rekli bismo da je eksponencijalna, ali moramo provjeriti!"

# ╔═╡ be8e4ac2-08dd-11eb-2f72-a9da5a750d32
plot!(mean(all_data), leg=true, label="mean",
		lw=3, c=:red, m=:o, alpha=0.5, 
		size=(500, 400))

# ╔═╡ 3d29e405-d177-4265-ac40-bf112398875f
md"Provjeru je li funkcija eksponencijalna provodimo tako što nacrtamo y os na logaritamskoj skali. Vidimo da jeste i da pada s određenom stopom.

To što znamo da je funkcija eksponencijalna, znači da bismo ju mogli derivirati!"

# ╔═╡ 8bc52d58-0848-11eb-3487-ef0d06061042
begin
	plot(replace.(all_data, 0.0 => NaN), 
		yscale=:log10, alpha=0.3, leg=false, m=:o, ms=1,
		size=(500, 400))
	
	plot!(mean(all_data), yscale=:log10, lw=3, c=:red, m=:o, label="mean", alpha=0.5)
	
	xlabel!("vrijeme t")
	ylabel!("broj infekcija")
end



# ╔═╡ caa3faa2-08e5-11eb-33fe-cbbc00cfd459
md"""
## Deterministička dinamika za srednju vrijednost (mean): Intuitivno deriviranje
"""

# ╔═╡ 2174aeba-08e6-11eb-09a9-2d6a882a2604
md"""
Čini se da se srednja vrijednost (mean) s vremenom ponašala na prilično predvidljiv način. Možemo li to derivirati?

Neka $I_t$ bude broj zaraženih ljudi u vrijeme $t$. To se smanjuje jer se neki ljudi oporavljaju. Budući da se ljudi oporavljaju s vjerojatnosti $p$, broj ljudi koji se oporave u trenutku $t$ je u prosjeku $p I_t$. [Imajte na umu da jedna vremenska jedinica odgovara jednom *zamahu* (sweep) simulacije.]

Imamo:

$$I_{t+1} = I_t - p \, I_t$$

ili

$$I_{t+1} = I_t (1 - p).$$

"""

# ╔═╡ 7e89f992-0847-11eb-3155-c5313575f767
md"""
U vrijeme $t$ postoje $I_t$ zarazne bolesti.
Koliko prestaje (bivaju preboljene)? Svaka prestaje (preboljena je) s vjerojatnosti $p$, tako da se u prosjeku $p I_t$ oporavi, pa se ukloni iz broja zaraznih, dajući promjenu
$$\Delta I_t = I_{t+1} - I_t = -p \, I_t$$
"""

# ╔═╡ f5756dd6-0847-11eb-0870-fd06ad10b6c7
md"""
Možemo preurediti i riješiti relaciju :

$$I_{t+1} = (1 - p) I_t. $$

pa

$$I_{t+1} = (1 - p) (1 - p) I_{t-1} = (1 - p)^2 I_{t-1}$$


i time riješiti relaciju: (ovo dobivamo indukcijom)

$$I_t = (1-p)^t \, I_0.$$

~~~~
Dakle, (1-p) je vjerojatnost da se zaražena osoba neće oporaviti. 
Tu vjerojatnost potenciramo s 't' (trenutak koji promatramo)
i množimo s I_0 da bismo dobili broj zaraženih u trenutku 't'. 
~~~~

"""

# ╔═╡ 113c31b2-08ed-11eb-35ef-6b4726128eff
md"""
Usporedimo egzaktne i numeričke rezultate:
"""

# ╔═╡ c65d3d6a-3d1f-4328-bc3e-1d05a0e36d81
md"Egzaktna rješenja će trebati za analitički mean, a numerička rješenja (točke) već imamo iz grafova svih simulacija (all_data)"

# ╔═╡ 6a545268-0846-11eb-3861-c3d5f52c061b
exact = [N * (1-pp)^t for t in 0:T]  

# ╔═╡ 4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
begin
	plot(mean(all_data), m=:o, label="numerički mean",
		size=(500, 400))
	plot!(exact, lw=3, label="analitički mean")
end
	

# ╔═╡ 3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
md"""
Dobro se slažu, kako bi i trebali. Očekuje se da će slaganje biti bolje (tj. fluktuacije manje) za veću populaciju.


Fluktacije - nepravilan porast i pad broja ili iznosa; varijacija
"""

# ╔═╡ 57665108-08e7-11eb-2d45-311e07217c4e
md"""
## Deriviranje korištenjem srednje vrijednosti (mean-a) stohastičkih procesa



Umjesto da se u izvodu apeliramo na svoju intuiciju, možemo formulirati točan opis stohastičkog procesa u smislu slučajnih varijabli: $X_t^i$ uzima vrijednost 1 ako je $i$-ta osoba zaražena u trenutku $t$, i $0$ ako su se oporavili, kao u gornjem grafu (plotu).

Svakim okretanjem novčića dobiva se nezavisna Bernoullijeva slučajna varijabla $B_t^i$, koja ima vrijednost 1 (true) s vjerojatnošću $p$, i 0 (false) s vjerojatnosti $1-p$.

Vrijednost u sljedećem vremenskom koraku, $X_{t+1}^i$, dana je s


$$X_{t+1}^i = \begin{cases} 0 &\text{ako } X_t^i = 0 \text{ ili } B_t^i = 1 \\
1 &\text{inače}
\end{cases}$$

~~~~~~~
(lijeva strana) i-ta osoba u sljedećem vremenskom trenutku :
(desna strana)  I) =0, ako se osoba u prethodnom trenutku već oporavila
                    ili ako je Bernoullijeva slučajna varijabla=1 tj. 
                    "bacali smo novčić i palo je pismo - osoba se 100% oporavlja"
                II) =1 , ako se nije dogodilo navedeno pod I), 
                        situacija se ne mijenja za i-tu osobu, ona ostaje =1
                        tj. zaražena (kad smo bacali novčić, pala je glava,
                                 a ni prethodno se nije bila oporavila i-ta osoba)
~~~~~~~

Možemo to zapisati kao : 

$$X_{t+1}^i = X_t^i \, (1 - B_t^i).$$

~~~~~~
Dakle, kada je B_t=0, onda je X_(t+1)=X_t (osoba ostaje zaražena).
Kada je B_t=1 (oporavak garantiran), onda je X_(t+1)=0, zaraza je gotova.
Tako modeliramo i prikazujemo dinamiku zaraze i oporavka pomoću slučajnih varijabli.
~~~~~~
(ekvivalentno prethodnom opisu!)

"""

# ╔═╡ 04d1ce96-0986-11eb-0c35-c73eb60d0994
md"""

$$\newcommand{mean}[1]{\left \langle #1 \right \rangle}$$

Označimo mean slučajne varijable $X$, označeno sa $\langle X \rangle$. U teoriji vjerojatnosti to se često naziva **očekivanje** (ili "očekivana vrijednost") i piše $\mathbb{E}[X]$.

~~~~
Ono što očekujemo treba biti jednako nekoj srednjoj vrijednosti (mean) 
svih simulacija. 
Ili, teoretski, imamo rezultate za neku populaciju pa uzimamo mean toga
te očekujemo tu vrijednost. 
~~~~
Uzimajući očekivanja obje strane gornje jednadžbe i koristeći da je očekivanje umnoška neovisnih slučajnih varijabli umnožak njihovih očekivanja, dobivamo

$$\mean{X_{t+1}^i} = \mean{X_t^i}\, \left(1 - \mean{B_t^i} \right).$$

Srednja vrijednost (MEAN) svake neovisne {bacanje novčića je neovisno}, ali identično distribuirane Bernoullijeve varijable $B_t^i$ je $p$.

Da bismo pronašli srednji ukupan broj zaraženih pojedinaca, samo zbrajamo logičke (boolean) varijable $X_t^i$:


$$I_t = \mean{\sum_{i=1}^N X_t^i}.$$

~~~~
Zbrajamo slučajne varijable koje su ili 1 ili 0 te je I_t njihova ukupna suma.
I onda od te sume uzimamo MEAN da bismo dobili broj zaraženih ljudi.
~~~~
"""

# ╔═╡ 3c377507-ffc2-44fd-a88b-3a79f3481cff


# ╔═╡ 9d688084-0986-11eb-240f-23d85d9a3554
md"""
Sastavljanje svega ovoga vraća nam naš prethodni rezultat,

$$I_{t+1} = (1 - p) \, I_t .$$

~~~~~
Tako smo dobili makroskopski opis u diskretnom vremenu. Dakle, uzimali smo, recimo vremenski korak od jedan dan. 
Ali, možda želimo biti precizniji i gledati št se događa na razini sati ili minuta.
To onda moramo promatrati u neprekidnom vremenu.
~~~~~

"""

# ╔═╡ 2f980870-0848-11eb-3edb-0d4cd1ed5b3d
md"""
## Neprekidno vrijeme


Ako grafikon srednje vrijednosti (MEAN-a) promatramo u ovisnosti o vremenu, čini se da slijedi glatku krivulju. Zapravo ima smisla pitati ne samo koliko je ljudi ozdravilo svaki *dan*, već težiti finijoj granulaciji.
~~~~~
Digresija za bolje razumijevanje, laički rečeno:
"Neprekidno" odmah asocira na neprekidnu funkciju. Dakle, derivabilnu funkciju.
Ako se prisjetimo definicije derivacije, znamo da se u izrazu pojavljuju delte. 
Te delte označavaju promijenu neke varijable (vrijednosti). 
Vrijednost koja se kod nas mijenja i koju gledamo na x-osi na grafu je vrijeme.
Ima smisla prvo tražiti promijenu vremena i ovisno o njoj dalje formirati izraz.
Sada nam 't' više nije indeks jer ne promatramo vrijeme kao korak (npr. dan) već 
promatramo što se događa u, npr. minutama. Stoga, nam je sada I funkcija
ovisna o vremenu, a ne varijabla s indeksom koji označava vremenski korak.
~~~~~
Pretpostavimo da povećavamo vrijeme u koracima od $\delta t$; gornja analiza bila je za $\delta t = 1$.

Tada ćemo morati prilagoditi vjerojatnost oporavka u svakom vremenskom koraku.
Ispada da, da bismo imali smisla gledati u granici $\delta t \to 0$ (naravno, želimo što preciznije rezultate i zbog tog gledamo da nam je vremenska promijena što manja tj. da teži u 0) , moramo odabrati vjerojatnost $p(\delta t)$ da se oporavi u vremenu $t$ koja će biti proporcionalna $\delta t$:


$$p(\delta t) \simeq \lambda \, \delta t,$$

gdje je $\lambda$ stopa oporavka. Imajmo na umu da je stopa vjerojatnost *po jedinici vremena*.
{bilješka : a to da je stopa vjerojatnost znači da je iz intervala [0,1]}

Dobivamo : 
"""

# ╔═╡ 6af30142-08b4-11eb-3759-4d2505faf5a0
md"""
$$I(t + \delta t) - I(t) \simeq -\lambda \,\delta t \, I(t)$$
"""

# ╔═╡ c6f9feb6-08f3-11eb-0930-83385ca5f032
md"""
Dijeljenjem  s $\delta t$ dobivamo : 

$$\frac{I(t + \delta t) - I(t)}{\delta t} \simeq -\lambda \, I(t)$$

Lijevu stranu prepoznajemo kao definiciju **derivacije** kada je $\delta t\to 0$. Uzimanje te granice konačno daje
"""

# ╔═╡ d8d8e7d8-08b4-11eb-086e-6fdb88511c6a
md"""
$$\frac{dI(t)}{dt} = -\lambda \, I(t)$$

Odnosno, dobivamo **običnu diferencijalnu jednadžbu** (ODJ) koja rješenje daje implicitno. Rješavanje ove jednadžbe s početnim uvjetom $I(0) = I_0$ daje

"""

# ╔═╡ 780c483a-08f4-11eb-1205-0b8aaa4b1c2d
md"""
$$I(t) = I_0 \exp(-\lambda \, t).$$
"""

# ╔═╡ a13dd444-08f4-11eb-08f5-df9dd99c8ab5
md"""

Alternativno, to možemo izvesti prepoznavanjem eksponencijala u granici $\delta t \to 0$ sljedećeg izraza, koji je u osnovi izraz za složenu kamatu:
"""

# ╔═╡ cb99fe22-0848-11eb-1f61-5953be879f92
md"""
$$I_{t} = (1 - \lambda \, \delta t)^{(t / \delta t)} I_0$$
"""

# ╔═╡ d74bace6-08f4-11eb-2a6b-891e52952f57
md"""
## SIR model
"""

# ╔═╡ dbdf2812-08f4-11eb-25e7-811522b24627
md"""

Sada proširimo postupak na puni SIR model, $S \to I \to R$. Budući da već znamo kako se nositi s oporavkom, uzmite u obzir samo SI model, gdje su osjetljivi agenti zaraženi kontaktom, s vjerojatnošću
"""

# ╔═╡ 238f0716-0903-11eb-1595-df71600f5de7
md"""
Označimo sa $S_t$ i nek je $I_t$ broj osjetljivih (S) i zaraznih (I) ljudi u vrijeme $t$, odnosno za $N$ ukupan broj ljudi.

U prosjeku, u svakom premetanju (sweep) svaki zarazni pojedinac ima priliku stupiti u interakciju s jednom drugom osobom. Ta je jedinka slučajno izabrana uniformno iz ukupne populacije veličine $N$. Ali nova infekcija događa se samo ako je odabrani pojedinac osjetljiv (S), što se događa s vjerojatnošću $S_t /N$, a zatim ako je zaraza uspješna, s vjerojatnošću $b$, recimo.

Stoga je promjena u broju zaraznih ljudi nakon tog koraka.


Smanjenje u $S_t$ je također dano s $\Delta I_t$.
"""

# ╔═╡ 8e771c8a-0903-11eb-1e34-39de4f45412b
md"""
$$\Delta I_t = I_{t+1} - I_t = b \, I_t \, \left(\frac{S_t}{N} \right)$$
"""

# ╔═╡ e83fc5b8-0904-11eb-096b-8da3a1acba12
md"""
Korisno je normalizirati s $N$, stoga definiramo:

$$s_t := \frac{S_t}{N}; \quad i_t := \frac{I_t}{N}; \quad r_t := \frac{R_t}{N}$$
"""

# ╔═╡ d1fbea7a-0904-11eb-377d-690d7a16aa7b
md"""
Uključujući oporavak s vjerojatnosti $c$, dobivamo **SIR model s diskretnim vremenom**:
"""

# ╔═╡ dba896a4-0904-11eb-3c47-cbbf6c01e830
md"""
$$\begin{align}
s_{t+1} &= s_t - b \, s_t \, i_t \\
i_{t+1} &= i_t + b \, s_t \, i_t - c \, i_t\\
r_{t+1} &= r_t + c \, i_t
\end{align}$$
"""

# ╔═╡ 7485dfdf-667e-4cb5-92d5-2afabdc0fc5d

md"Moja interpretacija : 
~~~~~
i) BROJ OSJETLJIVIH U SLJEDEĆEM TRENUTKU = BROJ OSJETLJIVIH U OVOM TRENUTKU
- (ZARAZNIH U OVOM TRENUTKU) {KOJI ĆE ZARAZITI }
* (OSJETLJIVE U OVOM TRENUTKU)
* (S VJEROJATNOŠĆU USPJEŠNE ZARAZE)

ii) BROJ ZARAZNIH U SLJEDEĆEM TRENUTKU = (BROJ ZARAZNIH TRENUTNO)
+ (BROJ ZARAZNIH TRENUTNO KOJI ZARAZE OSJETLJIVE S VJEROJATNOŠĆU USPJEŠNE ZARAZE)
- (BROJ ZARAŽENIH TRENUTNO KOJI SU SE OPORAVILI S VJEROJATNOŠĆU ´c´ )

iii) BROJ OPORALJENIH U SLJEDEĆEM TRENUTKU = (BROJ OPORAVLJENIH TRENUTNO)
+ (BROJ ZARAŽENIH TRENUTNO KOJI SU SE OPORAVILI S VJEROJATNOŠĆU ´c´  )  
~~~~~
"

# ╔═╡ 267cd19e-090d-11eb-0676-0f88b57da937
md"""
To opet možemo dobiti iz stohastičkog procesa uzimajući očekivanja . [Zanemarimo oporavak za početak i uzmite varijable $Y_t^i $ koje su $0$ ako je osoba osjetljiva i 1 ako je zaražena.]
"""

# ╔═╡ 4e3c7e62-090d-11eb-3d16-e921405a6b16
md"""
I opet možemo dopustiti da se procesi odvijaju u koracima duljine $\delta t$ i uzeti granicu $\delta t \to 0 $. Uz stope $\beta$ i $\gamma$ dobivamo standardni (kontinuirani) **SIR model**:
"""

# ╔═╡ 72061c66-090d-11eb-14c0-df619958e2b6
md"""
$$\begin{align}
\textstyle \frac{ds(t)}{dt} &= -\beta \, s(t) \, i(t) \\
\textstyle \frac{di(t)}{dt} &= +\beta \, s(t) \, i(t) &- \gamma \, i(t)\\
\textstyle \frac{dr(t)}{dt} &= &+ \gamma \, i(t)
\end{align}$$
"""

# ╔═╡ 2d4cc451-fd19-4fda-b3d6-687cb7b5cc57
md"Moja interpretacija
~~~~~~~~
Ovdje derivaciju promatramo kao fizičari, promijena u vremenu.
Dakle, od broja osjetljivih u sljedećem 
trenutku oduzimamo broj osjetljivih u ovom trenutku 
i tako dobivamo lijevu stranu. 
Na desnoj nam ostaje ono što je gore napisano, 
ali u notaciji gdje imamo varijable ovisne o vremenu
i konstatne stope kojima ih množimo.
~~~~~~~~
" 


# ╔═╡ c07367be-0987-11eb-0680-0bebd894e1be
md"""
To možemo smatrati modelom kemijske reakcije s vrstama S, I i R. Pojam $s(t) i (t)$ poznat je kao [**masovno djelovanje**] (https://en .wikipedia.org/wiki/Law_of_mass_action) oblik interakcije.

Imajmo na umu da niti jedno analitičko rješenje ovih (jednostavnih) nelinearnih ODJ-a nije poznato kao funkcija vremena! (Međutim, [parametarska rješenja su poznata] (https://arxiv.org/abs/1403.2160).)
"""

# ╔═╡ f8a28ba0-0915-11eb-12d1-336f291e1d84
md"""
Ispod je simulacija modela diskretnog vremena. Imajmo na umu da se najjednostavnija numerička metoda za rješavanje (približno) sustava ODJ-ova, **Eulerova metoda**, u osnovi svodi na rješavanje modela s diskretnim vremenom! Čitav paket naprednijih ODJ solvera nalazi se u [ekosistemu Julia `DiffEq`] (https://diffeq.sciml.ai/dev/).
"""

# ╔═╡ d994e972-090d-11eb-1b77-6d5ddb5daeab
begin
	NN = 100
	
	SS = NN - 1
	II = 1
	RR = 0
end

# ╔═╡ 050bffbc-0915-11eb-2925-ad11b3f67030
ss, ii, rr = SS/NN, II/NN, RR/NN

# ╔═╡ 1d0baf98-0915-11eb-2f1e-8176d14c06ad
p_infection, p_recovery = 0.1, 0.01

# ╔═╡ 28e1ec24-0915-11eb-228c-4daf9abe189b
TT = 1000

# ╔═╡ 349eb1b6-0915-11eb-36e3-1b9459c38a95
function discrete_SIR(s0, i0, r0, T=1000)

	s, i, r = s0, i0, r0
	
	results = [(s=s, i=i, r=r)]
	
	for t in 1:T

		Δi = p_infection * s * i
		Δr = p_recovery * i
		
		s_new = s - Δi
		i_new = i + Δi - Δr
		r_new = r      + Δr

		push!(results, (s=s_new, i=i_new, r=r_new))

		s, i, r = s_new, i_new, r_new
	end
	
	return results
end

# ╔═╡ 39c24ef0-0915-11eb-1a0e-c56f7dd01235
SIR = discrete_SIR(ss, ii, rr)

# ╔═╡ 442035a6-0915-11eb-21de-e11cf950f230
begin
	ts = 1:length(SIR)
	discrete_time_SIR_plot = plot(ts, [x.s for x in SIR], 
		m=:o, label="S", alpha=0.2, linecolor=:blue, leg=:right, size=(400, 300))
	plot!(ts, [x.i for x in SIR], m=:o, label="I", alpha=0.2)
	plot!(ts, [x.r for x in SIR], m=:o, label="R", alpha=0.2)
	
	xlims!(0, 500)
end

# ╔═╡ 5f4516fe-098c-11eb-3abe-418aac994cc3
discrete_time_SIR_plot

# ╔═╡ Cell order:
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╟─a3b2accc-0845-11eb-229a-e97bc3943016
# ╟─ff32d32a-dbda-4990-a316-e76a1ff8f04f
# ╟─123d447c-43f4-4c3b-b4b0-09a57ef22b77
# ╟─ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
# ╟─69790bfa-b302-4b47-86c9-a997fee4e45e
# ╠═5f4516fe-098c-11eb-3abe-418aac994cc3
# ╟─f9a75ac4-08d9-11eb-3167-011eb698a32c
# ╠═ba7ffe78-0845-11eb-2847-851a407dd2ec
# ╠═d088ed2e-0845-11eb-0697-310f374effbc
# ╠═e2d764d0-0845-11eb-0031-e74d2f5acaf9
# ╠═9282eca0-08db-11eb-2e36-d761594b427c
# ╠═58d8542c-08db-11eb-193a-398ce01b8635
# ╠═8d6c0c06-08db-11eb-3790-c98fdc545352
# ╠═7e1b61ac-08db-11eb-209e-1d6c328f5113
# ╟─b390c7c5-d9e2-4c1e-8040-e14be9abc32d
# ╠═33f9fc36-0846-11eb-18c2-77f92fca3176
# ╠═39a69c2a-0846-11eb-35c1-53c68a9f71e5
# ╟─4fedb9ea-8c1f-444e-889f-0e042708dd64
# ╠═cb278624-08dd-11eb-3375-276bfe8d7b3a
# ╠═f3c85814-0846-11eb-1266-63f31f351a51
# ╟─2c4e8064-4b26-4378-ba2f-1068d2a90dc3
# ╠═01dbe272-0847-11eb-1331-4360a575ff14
# ╟─9f44e1fa-d867-4071-ae32-f9b3e0c10f53
# ╠═be8e4ac2-08dd-11eb-2f72-a9da5a750d32
# ╟─3d29e405-d177-4265-ac40-bf112398875f
# ╠═8bc52d58-0848-11eb-3487-ef0d06061042
# ╟─caa3faa2-08e5-11eb-33fe-cbbc00cfd459
# ╟─2174aeba-08e6-11eb-09a9-2d6a882a2604
# ╟─7e89f992-0847-11eb-3155-c5313575f767
# ╟─f5756dd6-0847-11eb-0870-fd06ad10b6c7
# ╟─113c31b2-08ed-11eb-35ef-6b4726128eff
# ╟─c65d3d6a-3d1f-4328-bc3e-1d05a0e36d81
# ╠═6a545268-0846-11eb-3861-c3d5f52c061b
# ╠═4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
# ╟─3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
# ╟─57665108-08e7-11eb-2d45-311e07217c4e
# ╟─04d1ce96-0986-11eb-0c35-c73eb60d0994
# ╠═3c377507-ffc2-44fd-a88b-3a79f3481cff
# ╟─9d688084-0986-11eb-240f-23d85d9a3554
# ╟─2f980870-0848-11eb-3edb-0d4cd1ed5b3d
# ╟─6af30142-08b4-11eb-3759-4d2505faf5a0
# ╟─c6f9feb6-08f3-11eb-0930-83385ca5f032
# ╟─d8d8e7d8-08b4-11eb-086e-6fdb88511c6a
# ╟─780c483a-08f4-11eb-1205-0b8aaa4b1c2d
# ╟─a13dd444-08f4-11eb-08f5-df9dd99c8ab5
# ╟─cb99fe22-0848-11eb-1f61-5953be879f92
# ╟─d74bace6-08f4-11eb-2a6b-891e52952f57
# ╟─dbdf2812-08f4-11eb-25e7-811522b24627
# ╟─238f0716-0903-11eb-1595-df71600f5de7
# ╟─8e771c8a-0903-11eb-1e34-39de4f45412b
# ╟─e83fc5b8-0904-11eb-096b-8da3a1acba12
# ╟─d1fbea7a-0904-11eb-377d-690d7a16aa7b
# ╟─dba896a4-0904-11eb-3c47-cbbf6c01e830
# ╟─7485dfdf-667e-4cb5-92d5-2afabdc0fc5d
# ╟─267cd19e-090d-11eb-0676-0f88b57da937
# ╟─4e3c7e62-090d-11eb-3d16-e921405a6b16
# ╟─72061c66-090d-11eb-14c0-df619958e2b6
# ╟─2d4cc451-fd19-4fda-b3d6-687cb7b5cc57
# ╟─c07367be-0987-11eb-0680-0bebd894e1be
# ╟─f8a28ba0-0915-11eb-12d1-336f291e1d84
# ╠═442035a6-0915-11eb-21de-e11cf950f230
# ╠═d994e972-090d-11eb-1b77-6d5ddb5daeab
# ╠═050bffbc-0915-11eb-2925-ad11b3f67030
# ╠═1d0baf98-0915-11eb-2f1e-8176d14c06ad
# ╠═28e1ec24-0915-11eb-228c-4daf9abe189b
# ╠═349eb1b6-0915-11eb-36e3-1b9459c38a95
# ╠═39c24ef0-0915-11eb-1a0e-c56f7dd01235

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

# ╔═╡ c8bcb50a-684c-429d-a3d2-df9d1fae4b9b
begin
    import Pkg
    Pkg.activate(mktempdir())
end

# ╔═╡ a3f3844d-15b3-49c6-81b4-02afcc2d30a9
begin
    Pkg.activate("FFTW")
	Pkg.activate("Plots")
	Pkg.activate("DSP")
	Pkg.activate("ImageFiltering")
	Pkg.activate("PlutoUI")
	Pkg.activate("LinearAlgebra")
	Pkg.activate("MArkdown")
end

# ╔═╡ 78af7785-d41e-4c5b-a3d5-a4a0298e4835
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
    using Images
end

# ╔═╡ 474fabaf-ca46-48e6-9089-f6e9f1245a37
begin
	Pkg.add("PlutoUI")
	#using PlutoUI
end

# ╔═╡ e0479ef2-a377-4316-8de1-ebb70aa72352
begin
	using Statistics
	using FFTW
	using Plots
	using DSP
	using ImageFiltering
	using PlutoUI
	using LinearAlgebra
	using Markdown
end

# ╔═╡ 357d08ed-3fdb-4ef5-bbcb-3a9ab91270e3
begin
	using Flux, Flux.Data.MNIST
	using Flux: onehotbatch, argmax, crossentropy, throttle
	using Base.Iterators: repeated
	
end

# ╔═╡ b10818c7-c907-4be5-ada9-34bf47ba26a6
# specify the path to your local image file
img_path = "C:/Users/Matea/Desktop/mica2.jpg"


# ╔═╡ 3285739e-53d9-4ce3-8334-378ec964596b
img = load(img_path)


# ╔═╡ 1ae576e8-bf8f-4b7f-9c44-7b8275a76129
url = "https://www.diamondpet.com/wp-content/uploads/2019/10/394-1951-Black-Cat-Bad-Rap-1200x630-1024x538.jpg"

# ╔═╡ 9688d18a-2011-41fd-85bd-38118158e485
download(url, "crnamaca.jpg") 

# ╔═╡ f2a58e59-ceca-4ea4-bd20-442662274255
begin
  maca=load("crnamaca.jpg")
end

# ╔═╡ e6fb0dba-1970-4f64-80df-a19fa910fa04
maca

# ╔═╡ 6ce9808d-951a-4f82-8bcf-5981c74d3c58
typeof(maca)

# ╔═╡ 87ad4c11-af79-4211-aab4-3505e717e6b1
RGBX(0.4, 0.2, 0.5)

# ╔═╡ ba6867bb-d84f-4e70-9957-19a8644538fb
size(maca) # visina, sirina

# ╔═╡ dbbe4689-577e-4d6f-8165-83c3d31c2070
maca[100,400] # dobijem neki pixel mace

# ╔═╡ 45d88515-d5a5-4bb8-bbde-b86e8de6f21b
typeof(maca[100,400]) # tip tog je RGB (red,green,blue) 

# ╔═╡ 17fb8e6a-431e-44d0-b6b0-83e4b40ef0c1
 maca[1:500,1:500]  # slika je dvodimenzionalno polje- mozemo dakle birati dio polja                          ## na ovaj nacin 

# ╔═╡ 8e54af5f-41a9-4ae5-b265-e7774718d6eb
begin 
	(h,w) = size(maca) 
	head=maca[(h ÷ 2):h, (w ÷ 5):(9w ÷ 10)]
end

# ╔═╡ 6857ecf6-0a5b-432f-a81b-a047f92b1df9
size(head)

# ╔═╡ 990d9fb6-ab1c-4c3b-baf1-bf747af58d69
size(maca)

# ╔═╡ ddc41e30-ccf8-41b5-b194-6fa270be2a60
nos =[head,head]

# ╔═╡ 624a356c-aa5c-41e9-ae96-a18eb649877a

 typeof(nos)

# ╔═╡ 5eb53f8e-d71b-4b07-ab17-156f8489ed0f
sizeof(nos)

# ╔═╡ f8d1acf3-f457-4cc5-85fa-00775cc77f05
[
maca  reverse(maca,dims=2)
reverse(maca,dims=1) reverse(reverse(maca,dims=1),dims=2)

]   # konkatenacija nizova 

# ╔═╡ 73f2b83c-94fd-4ab1-862b-196b413d6d11
nova_maca=copy(maca)

# ╔═╡ 7cf8548f-6d4c-4cc0-b901-09f4fb774ac8
red=RGB(1,0,0)

# ╔═╡ 79942c77-7e8a-47b2-9e58-2164dcf427f9
for i in 1:100
	for j in 1:300
		 nova_maca[i,j]=red
	end
end
# demonstracija tj. vizualizacija koristenja petlji za manipulaciju nizovima

# ╔═╡ 43afe259-fb77-4a02-9068-427784420ae7
nova_maca

# ╔═╡ 6876ba0a-6573-4e09-b55f-93420632e426
begin 
	nova_maca2=copy(maca)
	nova_maca2[100:200,1:100] .= RGB(0,0,1) # .= recimo, objektna paradigma, ali radi                          # istu stvar kao i petlje;svaki piksel gleda kao objekt i                                        #  djeluje na njega
	nova_maca2
end

# ╔═╡ ade3b6c9-65da-47c1-98ae-3fa4b6b179c1
function redify(color)
	return RGB(color.r,0,0)
end

# ╔═╡ 68a248f6-c2a5-4010-93d0-29651905cb0d
begin 
	color=RGB(0.8,0.5,0.2)
	[color,redify(color)]
end       # imamo boju koju smo definirali i pored nje istu tu boju, ali samo crvene                ## nijanse, ostale smo joj oduzeli funkcijom redify 

# ╔═╡ 196752a8-e567-4312-90a8-817e0917c200
redify.(nova_maca2)

# ╔═╡ bbd8e4dd-7e03-46d0-a7b8-110170fd8d76
@bind repeat_count Slider(1:10, show_value=true)

# ╔═╡ b8353ee5-ecc5-436d-95c3-5a6dd3cc89c6
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ 8d5deaa2-5790-48ee-b058-929586925d5b
begin 
	poor_maca=decimate(nova_maca,2)
	size(poor_maca)
	poor_maca
end

# ╔═╡ 63142182-8ec6-4245-881f-576c7a39d2f1
repeat(poor_maca, repeat_count, repeat_count)

# ╔═╡ d04156f0-e13f-4d9f-b759-b3b589e20552
expand(image, ratio=5) = kron(image, ones(ratio, ratio))

# ╔═╡ 108b74fe-1336-4e27-8e33-62d699f364e3
extract_red(c) = c.r

# ╔═╡ 7208a690-eeb5-41f5-adb0-7075960f46b2
md"# KONVOLUCIJA "

# ╔═╡ 27495130-9846-49e3-ba5c-276ca28f06eb
md"### Ovdje su definirane funkcije koje ću trebati :  "

# ╔═╡ e2a29c46-ce74-4465-a2b9-8ee8b969d2f6
function show_colored_kernel(kernel)
	to_rgb(x) = RGB(max(-x, 0), max(x, 0), 0)
	to_rgb.(kernel) / maximum(abs.(kernel))
end

# ╔═╡ 77fcbdb8-b080-49b1-8c31-63f5daf96f59
md"##### - pokazuje obojanu jezgru "

# ╔═╡ 1b4a854d-a1f2-4081-a9a7-14724f97fc80
function shrink_image(image, ratio=5)
	(height, width) = size(image)
	new_height = height ÷ ratio - 1
	new_width = width ÷ ratio - 1
	list = [
		mean(image[
			ratio * i:ratio * (i + 1),
			ratio * j:ratio * (j + 1),
		])
		for j in 1:new_width
		for i in 1:new_height
	]
	reshape(list, new_height, new_width)
end

# ╔═╡ 37e09e3f-8331-48b0-8306-d7422dcc4478
md"##### - za smanjivanje slike "

# ╔═╡ 8c17190a-c15a-431e-a2ed-1b85504e5f8e
function rgb_to_float(color)
    return mean([color.r, color.g, color.b])
end

# ╔═╡ 945c74da-870e-4a93-bb3c-980acb876206
md"##### - pretvaranje rgb vrijednosti u float tip "

# ╔═╡ 75df1bd9-d57d-40b4-a994-8952a79decab
function fourier_spectrum_magnitudes(img)
    grey_values = rgb_to_float.(img)
    spectrum = fftshift(fft(grey_values))
	return abs.(spectrum)
end

# ╔═╡ 64c68f8b-0869-45fb-9fa8-bf83f81f0749
md"##### - magnitude Fourierovog spektra"

# ╔═╡ 1fe21bac-8ba1-484d-8889-28f7cbfded48
function plot_1d_fourier_spectrum(img, dims=1)
	spectrum = fourier_spectrum_magnitudes(img)
	plot(centered(mean(spectrum, dims=1)[1:end]))
end

# ╔═╡ dceea879-1e70-4d73-a23f-edf6567cb233
md"##### - jednodimenzionalni graf Fourierovog spektra "

# ╔═╡ 0f04d0cb-66ee-48a9-978b-7205ce645af7
function heatmap_2d_fourier_spectrum(img)
	heatmap(log.(fourier_spectrum_magnitudes(img)))
end

# ╔═╡ 950a0989-8cad-4483-87be-165c5f826b05
md"##### - dvodimenzionalna toplinska mapa Fourierovog spektra "

# ╔═╡ fb36e5e9-c7e2-4389-9398-64601a589f42
function clamp_at_boundary(M, i, j)
	return M[
		clamp(i, 1, size(M, 1)),
		clamp(j, 1, size(M, 2)),	
	]
end

# ╔═╡ c2e499c0-61ac-496d-b75c-9f958f863a24
md"##### - za stezanje na granicama "

# ╔═╡ 4f9dd3bd-c78a-4e2a-ac1b-084ecfacf84d
function rolloff_boundary(M, i, j)
	if (1 ≤ i ≤ size(M, 1)) && (1 ≤ j ≤ size(M, 2))
		return M[i, j]
	else
		return 0 * M[1, 1]
	end
end

# ╔═╡ f1e3cc29-ea48-4f39-8021-dc178ba371db
function convolve(M, kernel, M_index_func=clamp_at_boundary)
    height = size(kernel, 1)
    width = size(kernel, 2)
    
    half_height = height ÷ 2
    half_width = width ÷ 2
    
    new_image = similar(M)
	
    # (i, j) loop over the original image
    @inbounds for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            # (k, l) loop over the neighbouring pixels
			new_image[i, j] = sum([
				kernel[k, l] * M_index_func(M, i - k, j - l)
				for k in -half_height:-half_height + height - 1
				for l in -half_width:-half_width + width - 1
			])
        end
    end
    
    return new_image
end

# ╔═╡ e86a35ba-9f4c-4c5f-9b5e-be76d34ebe02
md"##### - *** funkcija konvolucije **** "

# ╔═╡ e3ee8e47-69f5-42b9-8539-81e597c8bda5
box_blur(n) = centered(ones(n, n) ./ (n^2))

# ╔═╡ e6cf62b5-a6db-47a9-8d7f-9ce8acbf8c9e
md"##### - za zamućivanje po kvadratima - jednake težine kvadratića "

# ╔═╡ 3219bb7e-1f6a-40e7-b22c-0f8d79c46052
function gauss_blur(n, sigma=0.25)
	kern = gaussian((n, n), sigma)
	return kern / sum(kern)
end

# ╔═╡ b5e11985-6d44-4079-9ff9-70fb3fa9422e
md"##### - za zamućivanje tako da težine kvadratića odgovaraju Gaussovoj krivulji"

# ╔═╡ 2f64c67e-7df4-4f1d-a77f-2136dc9bf8df
size(maca)

# ╔═╡ c23e0e42-fe3f-4bec-9db9-1181e5258f77
Kernel

# ╔═╡ 41117395-5473-46e8-a80f-1e00747c9ee0
md"Kernel je modul koji implementira filtrirajuće (korelacijske) jezgre pune dimenzionalnosti. Podržane su sljedeća jezgre::

sobel

prewitt

ando3, ando4, and ando5

scharr

bickley

gaussian

DoG (Difference-of-Gaussian)

LoG (Laplacian-of-Gaussian)

Laplacian

gabor

moffat"

# ╔═╡ e145af71-9406-4b45-8486-405ea404818e
kernel = Kernel.gaussian((10,10))

# ╔═╡ e5b9187b-63b2-4ce0-b0a5-b09f8d11c159
kernel[0,0] # središnja vrijednost !  # ANIMACIJA SA SUPER MARIOM !!!!

# ╔═╡ ea4406bc-083d-406f-8f99-c8636fff79ed
kernel[-2,-2] # ovo je prva vrijednost, dakle negativni indeksi ! ! 

# ╔═╡ 365ff0dd-3752-4f01-b9c8-424abec26739
show_colored_kernel(kernel)

# ╔═╡ 1c8ffb5c-3b97-4ca9-b6ef-d538571456e8
convolve(maca,kernel)

# ╔═╡ 4e292454-dddd-4fab-bc79-255b74b70ff2
prod(size(maca)) * prod(size(kernel)) # velik broj mnozenja koji ce se dogoditi da se ova slika zamuti -- funkciju konvolucije je bitno što bolje isprogramirati da bude brza! 

# ╔═╡ d8916734-a1f9-42ab-910c-a7d23d7cbd6d
# idemo napraviti kernel tj. jezgru kojom ćemo izoštriti sliku
kernel2 = centered([
		-0.5 -1.0 -0.5
		-1.0 7.0  -1.0
		-0.5 -1.0 -0.5
		])

# ╔═╡ 5501a7f0-5975-4214-b4d5-127f75730a53
show_colored_kernel(kernel2)

# ╔═╡ e211f133-83e6-46da-8cc9-1df84e78a7cb
cat=load("mala_mica.jpg")

# ╔═╡ 1c2c3f0a-6aaf-450a-a9d4-9722b2f2b088
sum(kernel2) # ovako provjeravamo ponašanje jezgre 
# dakle, suma svih vrijednosti ćelija je 1 -->
# dobiti ćemo slične boje ako su jednake vrijednosti 
# a ako je središnja ćelija veće težine nego okolne i recimo, okolne su tamnije,
# a srednja je svjetlija - onda će nam rezultat biti svjetlije boje

# ╔═╡ d7f6fed7-0c7c-42b0-97c9-fe7265cb340f
kernel3 = Kernel.sobel()[2] # vraća više jezgara pa, ajmo uzet onu na indeksu 2...

# ╔═╡ 8f83f9ad-15e5-4b83-8898-045eb9b969b4
kernel4=Kernel.sobel()[1] #horizontalno poslagane boje

# ╔═╡ d48a013a-b652-419b-9645-953f9957011d
show_colored_kernel(kernel3) # asimetrični filteri 

# ╔═╡ e317af69-7b7c-44bc-8909-871c6ab2b140
show_colored_kernel(kernel4)

# ╔═╡ 6909924f-ca41-4805-87e4-650df3fc64f7
convolve2(img, k) = imfilter(img, reflect(k)) # uses ImageFiltering.jl package
# behaves the same way as the `convolve` function used in Lecture 2
# You were asked to implement this in homework 1.

# ╔═╡ c1bc1a3f-96b8-4c67-a6d3-dbc6c3c0ef8a
convolve2(cat,kernel2) 

# ╔═╡ bfe05095-6a55-47b0-ab5b-118d97d5eeba


# ╔═╡ f2e9ad94-b906-4deb-be91-e3829acc7e3d
sum(kernel3)
# suma je 0 ? 


# ╔═╡ 9a5331fb-5c64-4fce-a3e8-39302e063439
convolve2(cat,kernel3)

# ╔═╡ a912b0ec-d852-43df-a20f-3f6fdcf1727c
5 * Gray.(abs.(convolve2(cat,kernel3)))

# ╔═╡ 802eceb7-84a3-410b-8cf1-3cf6df48a0e9
5 * Gray.(abs.(convolve2(cat,kernel4)))

# ╔═╡ 29d0453d-0061-480b-8ad8-03e49c125a68
cat

# ╔═╡ 86876b8e-5fa4-45d2-8c7c-ab758eec7f08
plot_1d_fourier_spectrum(cat) # ovo nam nije bas zanimljivo, uzet cemo neku zanimljiviju sliku ipak

# ╔═╡ 35636edc-b9b7-42d9-b4e5-4b1c5bcef94c
zebre=load("zebre.jpg")

# ╔═╡ cc78f869-b102-4a5f-9379-fccffce48da6
krnl = Kernel.gaussian((2,2))

# ╔═╡ 730858bc-767c-4842-ba86-99c6fa466f51
plot_1d_fourier_spectrum(zebre) 

# ╔═╡ f0322413-96d2-4f16-94dc-04693efc72d3
md"Imamo puno traka kako se mičemo slijeva nadesno. Ako pogledamo graf Fourierovog spektra vezanog za sliku zebri, možemo vidjeti da kako se odmičemo od 0, frekvencija traka raste. Pogledajmo što se dešava kada uzmemo konvoluciju te slike  "

# ╔═╡ 09298e1e-ed1c-45cc-adeb-095cae3ac558
conv_zeb=convolve2(zebre,krnl)

# ╔═╡ 0e140809-3879-4e8f-8c1d-e26768587964
plot_1d_fourier_spectrum(conv_zeb) 

# ╔═╡ b20c20dc-8516-4083-ad38-ab443fb7681e
md"Kada pogledamo graf zamagljene slike koja je rezultat konvolucije, vidimo da dobijemo sličan oblik kao i originalne slike, ali su krajevi pogurani prema dolje i manje oštri. To je zato što slika ima manje detalja i ovaj graf je sličan zapravo grafu slike na kojoj je mačka. Ovdje se događa nešto specifično, a to je da je Fourierova transformacija Gaussove krivulje je opet Gaussova krivulja. Ako imamo usku krivulju, možemo je raširiti na ovaj način i obratno. Ako pogledamo Fourierove informacije tj. frekvenciju i pomnožimo ih sa zvonolikom krivuljom, kao rezultat dobijemo jedan ovako blaži graf sa spuštenim krajevima i to nam daje iste Fourierove informacije, ali u drugim intervalima. Kada promatramo to s računarske strane  (prisjetimo se da smo imali jako velik broj množenja, veliku jezgru...), možemo smanjiti kompleksnost na način da prevedemo stvari u termine frekvencije slike gdje je kovolucija poput množenja (množimo dvije funkcije piksel po piksel) pa onda vratimo sve nazad u termine slike. Dakle, na taj način ovaj proces obavljamo brže !"

# ╔═╡ 334512f5-044a-4d03-9613-85cf85de8a23
heatmap_2d_fourier_spectrum(zebre)

# ╔═╡ 9edc306d-80ac-493a-98f5-1b378968d123
heatmap_2d_fourier_spectrum(conv_zeb) # zamucena slika zebri

# ╔═╡ bebac92e-c2fa-4498-bf49-9030afbe3921
md"Pogledajmo dvodimenzionalni analogni grafički prikaz Fourierovog spektra u obliku toplinske karte. Dobivamo informacije  koje govore koja je razina detaljanosti u vodoravnom i okomitom smjeru. Vidimo da su detalji konvoluntirane slike (zamućene slike zebri) koncentrirani u sredini.  "

# ╔═╡ 6cb22d10-baba-402b-aa63-2d13a7ec95b7
heatmap_2d_fourier_spectrum(cat)

# ╔═╡ 02b0ef45-26ab-4bb5-802d-f029f038e59c
md" Vidimo da je toplinska mapa slike mačke  sama od sebe manje raspršene tj. detaljna. Ona je nešto između vrlo detaljne originalne slike zebri i zamućene slike zebre. Dakle, tako izgleda neka običnija slika i kada ju pomnožimo s Gaussovom krivuljom u ovom Fourierovom prostoru, imamo manje detaljan spektar pa samim time i operacija konvolucije ide puno brže. U bibliotekama u koje je integrirana operacija konvolucije ili model konvolucijskih neuronskih mreža nemamo najobičnije jezgre koje se nalaze na početku ove bilježnice nego se koriste ove sofisticiranije."

# ╔═╡ cab019db-bcbc-4309-bae1-dfcf5d1aebc4
md"# ZADACI "

# ╔═╡ c17701e1-cd4b-4000-9c28-1094270a8448
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)
	const span = (this?.currentScript ?? currentScript).parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 9b259462-8954-4a53-9971-5f7fd125d1a0

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ Cell order:
# ╠═c8bcb50a-684c-429d-a3d2-df9d1fae4b9b
# ╠═78af7785-d41e-4c5b-a3d5-a4a0298e4835
# ╠═a3f3844d-15b3-49c6-81b4-02afcc2d30a9
# ╠═e0479ef2-a377-4316-8de1-ebb70aa72352
# ╠═b10818c7-c907-4be5-ada9-34bf47ba26a6
# ╠═3285739e-53d9-4ce3-8334-378ec964596b
# ╠═1ae576e8-bf8f-4b7f-9c44-7b8275a76129
# ╠═9688d18a-2011-41fd-85bd-38118158e485
# ╠═f2a58e59-ceca-4ea4-bd20-442662274255
# ╠═e6fb0dba-1970-4f64-80df-a19fa910fa04
# ╠═6ce9808d-951a-4f82-8bcf-5981c74d3c58
# ╠═87ad4c11-af79-4211-aab4-3505e717e6b1
# ╠═ba6867bb-d84f-4e70-9957-19a8644538fb
# ╠═dbbe4689-577e-4d6f-8165-83c3d31c2070
# ╠═45d88515-d5a5-4bb8-bbde-b86e8de6f21b
# ╠═17fb8e6a-431e-44d0-b6b0-83e4b40ef0c1
# ╠═8e54af5f-41a9-4ae5-b265-e7774718d6eb
# ╠═6857ecf6-0a5b-432f-a81b-a047f92b1df9
# ╠═990d9fb6-ab1c-4c3b-baf1-bf747af58d69
# ╠═ddc41e30-ccf8-41b5-b194-6fa270be2a60
# ╠═624a356c-aa5c-41e9-ae96-a18eb649877a
# ╠═5eb53f8e-d71b-4b07-ab17-156f8489ed0f
# ╠═f8d1acf3-f457-4cc5-85fa-00775cc77f05
# ╠═73f2b83c-94fd-4ab1-862b-196b413d6d11
# ╠═7cf8548f-6d4c-4cc0-b901-09f4fb774ac8
# ╠═79942c77-7e8a-47b2-9e58-2164dcf427f9
# ╠═43afe259-fb77-4a02-9068-427784420ae7
# ╠═6876ba0a-6573-4e09-b55f-93420632e426
# ╠═ade3b6c9-65da-47c1-98ae-3fa4b6b179c1
# ╠═68a248f6-c2a5-4010-93d0-29651905cb0d
# ╠═196752a8-e567-4312-90a8-817e0917c200
# ╠═357d08ed-3fdb-4ef5-bbcb-3a9ab91270e3
# ╠═8d5deaa2-5790-48ee-b058-929586925d5b
# ╠═474fabaf-ca46-48e6-9089-f6e9f1245a37
# ╠═bbd8e4dd-7e03-46d0-a7b8-110170fd8d76
# ╠═63142182-8ec6-4245-881f-576c7a39d2f1
# ╠═b8353ee5-ecc5-436d-95c3-5a6dd3cc89c6
# ╠═d04156f0-e13f-4d9f-b759-b3b589e20552
# ╠═108b74fe-1336-4e27-8e33-62d699f364e3
# ╟─7208a690-eeb5-41f5-adb0-7075960f46b2
# ╟─27495130-9846-49e3-ba5c-276ca28f06eb
# ╠═e2a29c46-ce74-4465-a2b9-8ee8b969d2f6
# ╟─77fcbdb8-b080-49b1-8c31-63f5daf96f59
# ╠═1b4a854d-a1f2-4081-a9a7-14724f97fc80
# ╟─37e09e3f-8331-48b0-8306-d7422dcc4478
# ╠═8c17190a-c15a-431e-a2ed-1b85504e5f8e
# ╟─945c74da-870e-4a93-bb3c-980acb876206
# ╠═75df1bd9-d57d-40b4-a994-8952a79decab
# ╟─64c68f8b-0869-45fb-9fa8-bf83f81f0749
# ╠═1fe21bac-8ba1-484d-8889-28f7cbfded48
# ╟─dceea879-1e70-4d73-a23f-edf6567cb233
# ╠═0f04d0cb-66ee-48a9-978b-7205ce645af7
# ╟─950a0989-8cad-4483-87be-165c5f826b05
# ╠═fb36e5e9-c7e2-4389-9398-64601a589f42
# ╟─c2e499c0-61ac-496d-b75c-9f958f863a24
# ╟─4f9dd3bd-c78a-4e2a-ac1b-084ecfacf84d
# ╠═f1e3cc29-ea48-4f39-8021-dc178ba371db
# ╟─e86a35ba-9f4c-4c5f-9b5e-be76d34ebe02
# ╠═e3ee8e47-69f5-42b9-8539-81e597c8bda5
# ╟─e6cf62b5-a6db-47a9-8d7f-9ce8acbf8c9e
# ╠═3219bb7e-1f6a-40e7-b22c-0f8d79c46052
# ╟─b5e11985-6d44-4079-9ff9-70fb3fa9422e
# ╠═2f64c67e-7df4-4f1d-a77f-2136dc9bf8df
# ╠═c23e0e42-fe3f-4bec-9db9-1181e5258f77
# ╟─41117395-5473-46e8-a80f-1e00747c9ee0
# ╠═e145af71-9406-4b45-8486-405ea404818e
# ╠═e5b9187b-63b2-4ce0-b0a5-b09f8d11c159
# ╠═ea4406bc-083d-406f-8f99-c8636fff79ed
# ╠═365ff0dd-3752-4f01-b9c8-424abec26739
# ╠═1c8ffb5c-3b97-4ca9-b6ef-d538571456e8
# ╠═4e292454-dddd-4fab-bc79-255b74b70ff2
# ╠═d8916734-a1f9-42ab-910c-a7d23d7cbd6d
# ╠═5501a7f0-5975-4214-b4d5-127f75730a53
# ╠═e211f133-83e6-46da-8cc9-1df84e78a7cb
# ╠═1c2c3f0a-6aaf-450a-a9d4-9722b2f2b088
# ╠═d7f6fed7-0c7c-42b0-97c9-fe7265cb340f
# ╠═8f83f9ad-15e5-4b83-8898-045eb9b969b4
# ╠═d48a013a-b652-419b-9645-953f9957011d
# ╠═e317af69-7b7c-44bc-8909-871c6ab2b140
# ╠═6909924f-ca41-4805-87e4-650df3fc64f7
# ╠═c1bc1a3f-96b8-4c67-a6d3-dbc6c3c0ef8a
# ╠═bfe05095-6a55-47b0-ab5b-118d97d5eeba
# ╠═f2e9ad94-b906-4deb-be91-e3829acc7e3d
# ╠═9a5331fb-5c64-4fce-a3e8-39302e063439
# ╠═a912b0ec-d852-43df-a20f-3f6fdcf1727c
# ╠═802eceb7-84a3-410b-8cf1-3cf6df48a0e9
# ╠═29d0453d-0061-480b-8ad8-03e49c125a68
# ╠═86876b8e-5fa4-45d2-8c7c-ab758eec7f08
# ╠═35636edc-b9b7-42d9-b4e5-4b1c5bcef94c
# ╠═cc78f869-b102-4a5f-9379-fccffce48da6
# ╠═730858bc-767c-4842-ba86-99c6fa466f51
# ╟─f0322413-96d2-4f16-94dc-04693efc72d3
# ╠═09298e1e-ed1c-45cc-adeb-095cae3ac558
# ╠═0e140809-3879-4e8f-8c1d-e26768587964
# ╟─b20c20dc-8516-4083-ad38-ab443fb7681e
# ╠═334512f5-044a-4d03-9613-85cf85de8a23
# ╠═9edc306d-80ac-493a-98f5-1b378968d123
# ╟─bebac92e-c2fa-4498-bf49-9030afbe3921
# ╠═6cb22d10-baba-402b-aa63-2d13a7ec95b7
# ╟─02b0ef45-26ab-4bb5-802d-f029f038e59c
# ╟─cab019db-bcbc-4309-bae1-dfcf5d1aebc4
# ╟─c17701e1-cd4b-4000-9c28-1094270a8448
# ╟─9b259462-8954-4a53-9971-5f7fd125d1a0

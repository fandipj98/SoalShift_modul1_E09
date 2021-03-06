# Laporan Resmi Sistem Operasi Modul1 E09

## Nomor 1
### Soal:

1. Anda diminta tolong oleh teman anda untuk mengembalikan filenya yang telah dienkripsi oleh seseorang menggunakan bash script, file yang dimaksud adalah nature.zip. Karena terlalu mudah kalian memberikan syarat akan membuka seluruh file tersebut jika pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari jumat pada bulan Februari.

### Jawaban:
```
	#!/bin/bash

	unzip /home/fandipj/nature.zip -d /home/fandipj

	a=0

	for x in /home/fandipj/nature/*.jpg
	do
		`base64 -d $x > /home/fandipj/nature/$a.jpg`
		`xxd -r /home/fandipj/nature/$a.jpg > /home/fandipj/nature/hasil$a.jpg`
		`rm /home/fandipj/nature/$a.jpg $x`
		a=$(($a+1))
	done
```    
Pertama – tama file nature.zip di unzip ke folder tujuan /home/fandipj dengan menggunakan syntax:

```
	unzip /home/fandipj/nature.zip -d /home/fandipj
```
Setelah file nature.zip diextract, akan muncul banyak file .jpg yang terenkripsi. Kemudian untuk mendekripsifile tersebut maka kita menggunakan syntax:
```
	`base64 -d $x > /home/fandipj/nature/$a.jpg`
```
Setelah didekripsi ternyata bilangan hexa dari file tersebut masih belum berbentuk file ekstensi .jpg. Oleh karena itu, file hasil dekripsi tersebut perlu untuk di reverse dengan menggunakan syntax:
```
	`xxd -r /home/fandipj/nature/$a.jpg > /home/fandipj/nature/hasil$a.jpg`
```
Karena jumlah file dalam folder nature lebih dari 1, maka perlu dilakukan looping untuk mendekripsi semua filenya.

Agar perintah – perintah syntax diatas dapat dieksekusi pada pukul 14:14 pada tanggal 14 Februari atau pada setiap hari jumat pada bulan Februari, maka digunakan syntax pada crontab seperti berikut:
```
	14 14 14 2 * /bin/bash /home/fandipj/Modul1/soal1.sh >> /home/fandipj/Modul1/err.log 2>&1
	0,5,10,15,20,25,30,35,40,45,50,55 * * 2 5 /bin/bash /home/fandipj/Modul1/soal1.sh >> /home/fandipj/Modul1/err.log 2>&1
```
### Screenshot:

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss1.png)

## Nomor 2
### Soal:

2. Anda merupakan pegawai magang pada sebuah perusahaan retail, dan anda diminta untuk memberikan laporan berdasarkan file WA_Sales_Products_2012-14.csv. Laporan yang diminta berupa:
<br/>a. Tentukan negara dengan penjualan(quantity) terbanyak pada tahun 2012.
<br/>b. Tentukan tiga product line yang memberikan penjualan(quantity) terbanyak pada soal poin a.
<br/>c. Tentukan tiga product yang memberikan penjualan(quantity) terbanyak berdasarkan tiga product line yang didapatkan pada soal poin b.

### Jawaban:
```
	#!/bin/bash

	a=`awk -F, '{if($7=="2012") arr[$1]=arr[$1]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, 'NR==1 {print $1}'`
	echo "Negara dengan penjualan terbanyak:"
	echo $a
	echo " "

	declare -A b

	for x in 1 2 3
	do
		b[$x]=`awk -F, -v a="$a" '{if($1==a && $7=="2012") arr[$4]=arr[$4]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
	done
	echo "3 Product Line dengan penjualan terbanyak:"
	echo ${b[@]}
	echo " "

	declare -A c

	for x in 1 2 3
	do
		c[$x]=`awk -F, -v a="$a" -v b1="${b[1]}" -v b2="${b[2]}" -v b3="${b[3]}" '{if(($4==b1 || $4==b2 || $4==b3) && $1==a && $7=="2012") arr[$6]=arr[$6]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t"," -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
	done
	echo "3 Product dengan penjualan terbanyak:"
	echo ${c[@]}
```
a.	Untuk menentukan negara dengan penjualan terbanyak pada tahun 2012, maka digunakan shell script dan syntax awk seperti berikut ini:
```
	a=`awk -F, '{if($7=="2012") arr[$1]=arr[$1]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, 'NR==1 {print $1}'`
	echo "Negara dengan penjualan terbanyak:"
	echo $a
	echo " "
```
Pertama – tama kolom 10 pada file WA_Sales_Products_2012-14.csv digrouping sesuai dengan setiap elemen pada kolom 1 (negara) dengan syarat tahun 2012. Kemudian hasilnya di sorting berdasarkan total penjualan, kemudian diambil kolom pertama dari record paling teratas yaitu negara dengan penjualan terbanyak pada tahun 2012.

b.	Untuk menentukan 3 product line yang memberikan penjualan terbanyak pada negara United States, maka digunakan shell script dan syntax awk seperti berikut:
```
	declare -A b

	for x in 1 2 3
	do
		b[$x]=`awk -F, -v a="$a" '{if($1==a && $7=="2012") arr[$4]=arr[$4]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t',' -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
	done
	echo "3 Product Line dengan penjualan terbanyak:"
	echo ${b[@]}
	echo " "

```
Pertama – tama perlu diambil nilai dari variable a pada nomor 2a (United States). Kemudian kolom 10 pada file WA_Sales_Products_2012-14.csv digrouping sesuai dengan setiap elemen pada kolom 4 (product line) dengan syarat negaranya adalah United States dan tahunnya adalah 2012. Kemudian hasilnya di sorting berdasarkan total penjualan, kemudian diambil kolom pertama dari 3 record teratas.

c.	Untuk 3 product yang memberikan penjualan terbanyak sesuai dengan syarat negara adalah United States, product line adalah Personal Accessories, Camping Equipment, Mountaineering Equipment, maka digunakan shell script dan syntax awk seperti berikut:

```
	declare -A c

	for x in 1 2 3
	do
		c[$x]=`awk -F, -v a="$a" -v b1="${b[1]}" -v b2="${b[2]}" -v b3="${b[3]}" '{if(($4==b1 || $4==b2 || $4==b3) && $1==a && $7=="2012") arr[$6]=arr[$6]+$10}END{for(i in arr) print i "," arr[i]}' WA_Sales_Products_2012-14.csv | sort -t"," -nk2 -r | awk -F, -v x="$x" 'NR==x{print $1}'`
	done
	echo "3 Product dengan penjualan terbanyak:"
	echo ${c[@]}
```
Pertama – tama perlu diambil nilai dari variable a dan b pada nomor 2a dan 2b. Kemudian kolom 10 pada file WA_Sales_Products_2012-14.csv digrouping sesuai dengan setiap elemen pada kolom 6 (product) dengan syarat negaranya adalah United States dan product linenya adalah Personal Accessories, atau Camping Equipment, atau Mountaineering Equipment serta tahunnya adalah 2012. Kemudian hasilnya di sorting berdasarkan total penjualan, kemudian diambil kolom pertama dari 3 record teratas.
### Screenshot:

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss2.png)

## Nomor 3
### Soal:

3. Buatlah sebuah script bash yang dapat menghasilkan password secara acak sebanyak 12 karakter yang terdapat huruf besar, huruf kecil, dan angka. Password acak tersebut disimpan pada file berekstensi .txt dengan ketentuan pemberian nama sebagai berikut:
<br/>a. Jika tidak ditemukan file password1.txt maka password acak tersebut disimpan pada file bernama password1.txt
<br/>b. Jika file password1.txt sudah ada maka password acak baru akan disimpan pada file bernama password2.txt dan begitu seterusnya.
<br/>c. Urutan nama file tidak boleh ada yang terlewatkan meski filenya dihapus.
<br/>d. Password yang dihasilkan tidak boleh sama.

### Jawaban:
```
	#!/bin/bash

	a=1
	while true
	do
		if [ -f password$a.txt ]
		then
			a=$((a+1))
		else
			len=${#a}
			len1=$(((12-len)/2))
			len2=$((12-len-len1))
			ran1=$a
			ran2=$(cat /dev/urandom | tr -dc A-Z | head -c "$len1")
			ran3=$(cat /dev/urandom | tr -dc a-z | head -c "$len2")
			echo $ran1$ran2$ran3 > password$a.txt
			break
		fi
	done
```
Pertama – tama kita perlu mengecek dalam folder tertentu apakah ada file dengan nama password1.txt, jika terdapat file dengan nama password1.txt, maka dalam folder tersebut perlu kita cek apakah file password$a.txt ke a (1,2,3,…..)  sudah ada atau tidak. Kemudian create file password$a.txt yang belum ada secara berurutan dengan file – file yang sudah ada sebelumnya. 

Jika tidak ada, maka dibuat file password1.txt yang berisikan password unique secara acak sebanyak 12 karakter yang terdiri dari huruf besar, huruf kecil, dan angka. Agar password yang dibuat tidak ada yang sama dengan password lain yang sebelumnya, maka untuk beberapa karakter bagian depannya dibuat sebagai angka yang mewakili nama file tersebut. Jadi misalnya password4.txt isi passwordnya akan diawali dengan angka 4, password7.txt isi passwordnya akan diawali dengan angka 7, begitu pula untuk file password lainnya sehingga akan menghasilkan password yang pasti unique.
### Screenshot:

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss3.png)

## Nomor 4
### Soal:

4. Lakukan backup file syslog setiap jam dengan format nama file “jam:menit tanggal- bulan-tahun”. Isi dari file backup terenkripsi dengan konversi huruf (string manipulation) yang disesuaikan dengan jam dilakukannya backup misalkan sebagai berikut:
<br/>a. Huruf b adalah alfabet kedua, sedangkan saat ini waktu menunjukkan pukul 12, sehingga huruf b diganti dengan huruf alfabet yang memiliki urutan ke 12+2 = 14.
<br/>b. Hasilnya huruf b menjadi huruf n karena huruf n adalah huruf ke empat belas, dan seterusnya.
<br/>c. setelah huruf z akan kembali ke huruf a
<br/>d. Backup file syslog setiap jam.
<br/>e. dan buatkan juga bash script untuk dekripsinya.

### Jawaban:
```
	#!/bin/bash

	sh=`date +"%H"`
	source1=( {a..z} )
	trans1=()
	trans1+=( ${source1[@]:(-(26-$sh))} )
	trans1+=( ${source1[@]:0:$(($sh))} )
	source2=( {A..Z} )
	trans2=()
	trans2+=( ${source2[@]:(-(26-$sh))} )
	trans2+=( ${source2[@]:0:$(($sh))} )
	source1+=( ${source2[@]} )
	trans1+=( ${trans2[@]} )
	NOW=$(date +"%H:%M %d-%m-%Y")
	< /var/log/syslog > "$NOW" tr "${source1[*]}" "${trans1[*]}"
```
Pertama – tama kita perlu mengextract jam sekarang. Kemudian kita membuat enkripsi untuk file syslog yang nanti akan disave dengan format nama file “jam:menit tanggal-bulan-tahun”. Caranya adalah dengan mengenkripsi huruf besar dan huruf kecil menjadi huruf besar + jam sekarang dan huruf kecil + jam sekarang. Kemudian menggunakan command `tr` untuk mentranslate isi file syslog sesuai dengan konfigurasi dari `"${source1[*]}" "${trans1[*]}"`.

Perintah shell script ini dijalankan setiap jam dengan menggunakan crontab seperti berikut ini:
```
	@hourly /bin/bash /home/fandipj/Modul1/soal4.sh >> /home/fandipj/Modul1/err.log 2>&1
```
Kemudian untuk mendekripsi file yang sudah terenkripsi tersebut, pertama -tama dilakukan dengan mengextract jam dari nama file yang diinputkan user, kemudian mentranslate file menggunakan command `tr` dengan konfigurasi inverse dari konfigurasi pada saat enkripsinya sehingga akan menghasilkan file backup syslog yang benar. Perintah shell scriptnya seperti syntax berikut:
```
	#!/bin/bash

	read NOW
	sh=${NOW:0:2}
	source1=( {a..z} )
	trans1=()
	trans1+=( ${source1[@]:(-(26-$sh))} )
	trans1+=( ${source1[@]:0:$(($sh))} )
	source2=( {A..Z} )
	trans2=()
	trans2+=( ${source2[@]:(-(26-$sh))} )
	trans2+=( ${source2[@]:0:$(($sh))} )
	source1+=( ${source2[@]} )
	trans1+=( ${trans2[@]} )
	< "$NOW" > "$NOW Decrypt" tr "${trans1[*]}" "${source1[*]}"	
```
### Screenshot:

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss4.png)

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss4decrypt.png)

## Nomor 5
### Soal:

5. Buatlah sebuah script bash untuk menyimpan record dalam syslog yang memenuhi kriteria berikut:
<br/>a. Tidak mengandung string “sudo”, tetapi mengandung string “cron”, serta buatlah pencarian stringnya tidak bersifat case sensitive, sehingga huruf kapital atau tidak, tidak menjadi masalah.
<br/>b. Jumlah field (number of field) pada baris tersebut berjumlah kurang dari 13.
<br/>c. Masukkan record tadi ke dalam file logs yang berada pada direktori /home/[user]/modul1.
<br/>d. Jalankan script tadi setiap 6 menit dari menit ke 2 hingga 30, contoh 13:02, 13:08, 13:14, dst.

### Jawaban:
```
	#!/bin/bash

	`awk '(!(/[sS][uU][dD][oO]/)&&(/[cC][rR][oO][nN]/)&&(NF<13))' /var/log/syslog >> /home/fandipj/modul1`
```
Pertama – tama, kita mengambil isi dari file syslog yang tidak mengandung string “sudo”, tetapi mengandung string “cron”, tidak case sensitive dan jumlah field (kolom) pada syslog harus berjumlah kurang dari 13 dengan menggunakan syntax `awk '(!(/[sS][uU][dD][oO]/)&&(/[cC][rR][oO][nN]/)&&(NF<13))' /var/log/syslog`. Kemudian kita memasukkan record yang telah terpilih kedalam file yang disimpan di direktori /home/[user]/modul1. Perintah shell script ini dijalankan setiap 6 menit dari menit ke 2 sampai menit ke 30 dengan menggunakan crontab seperti berikut ini:
```
	2,8,14,20,26 * * * * /bin/bash /home/fandipj/Modul1/soal5.sh >> /home/fandipj/Modul1/err.log 2>&1
```
### Screenshot:

![alt text](https://github.com/fandipj98/SoalShift_modul1_E09/blob/master/Screenshot/ss5.png)

# Cute Notes — Agent Çalışma Kuralları

Bu dosya projede çalışan geliştirme agentı için bağlayıcı çalışma sözleşmesidir. Kullanıcının güncel açık talimatı kapsamı belirler. Depoda bulunan diğer talimatları da oku; bu belgeyi gerekçe göstermeden silme veya kuralları uygulamayı kolaylaştırmak için gevşetme.

## 1. Başlangıçta okunacaklar

Her yeni görevde, görevle ilgili güncel sürümleri oku:

1. Kök `AGENTS.md` ve çalışılacak dizinin geçerli agent talimatları.
2. Bu `agent.md` dosyası.
3. `yol_haritasi.md`: ürün kapsamı, fazlar ve kabul ölçütleri.
4. `mimari.md`: veri, çizim, PDF, güvenlik ve senkronizasyon sözleşmeleri.
5. `project_structure.md`: mevcut yapı açıklaması; gerçek kodla doğrulanır.
6. `pubspec.yaml`, kilit dosyası, ilgili kaynak dosyaları, migration ve testler.

Bu belge seti yalnız yapı açıklamasından hazırlanmıştır; kaynak kodun denetlendiğini varsayma. Dosya varlığını özellik tamamlanmışlığıyla karıştırma. Gerçek kod belgeyle uyuşmuyorsa farkı kaydet, çalışan davranışı koru ve belgeleri somut bulguya göre düzelt. İlk uygulama görevi F0'dır.

## 2. Ürün kapsamı

- Flutter not uygulamasının mevcut görsel kimliğini, tema sistemini ve çalışan özelliklerini koru.
- Ana sayfa, defterler ve ayarlar yanına Belgeler ve Çizim hedefi ekle.
- Bu ekranda önce PDF/belge satırları alt alta, altında bağımsız Çizim Defterleri bölümü göster. Sağ üst `+` menüsünden PDF, görsel veya yeni çizim eklenebilsin.
- Samsung Notes etkileşim referansıdır; mevcut Cute Notes tasarımını gerekçesiz değiştirme.
- Defter içine girme, not yönetimi ve kapak/ikon/renk/kağıt kişiselleştirmesini tamamla.
- Telefon/tablet, offline çalışma, güvenli hesap erişimi, şifreleme ve geri yükleme bu planın parçasıdır.
- İlk PDF düzenleme kapsamı mevcut PDF üzerine kalem, işaretleme ve metin kutusu eklemektir. Mevcut PDF metnini doğrudan değiştirme ayrı ileri özelliktir.
- OCR, AI, ortak düzenleme, abonelik ve başka büyük özellikleri kendiliğinden ekleme.

## 3. Çalışma yöntemi

1. Görevin mevcut fazını ve kabul ölçütlerini belirle; hangi dosyaları değiştireceğini kısa açıkla.
2. İlgili kodu, veri akışını ve mevcut testleri incele; önceki kullanıcının değişikliklerini koru.
3. En küçük çalışan değişikliği yap; bu özellik için gerekli katmanı ekle.
4. Etkilenen davranışı ve kritik hata yolunu uygun test/cihaz kontrolüyle doğrula.
5. İlgili belgeleri ve faz durumunu gerçek sonuca göre güncelle.
6. Ne değişti, ne doğrulandı, hangi sınırlama kaldı ve sıradaki somut iş nedir diye raporla.

Kapsam içindeki geri alınabilir uygulama ayrıntılarında karar verip ilerle; her küçük adım için onay isteme. Gerekli bilgi eksikse bağımsız işi tamamla ve yalnız sonucu değiştiren soruyu sor. Yeni ücretli bağımlılık, kapsam değişikliği veya gerçek kullanıcı verisini geri döndürülemez silme etkisini somut şekilde açıklamadan yapma.

Kullanıcı yalnız plan/belge istediğinde uygulama kodu yazılmış, migration yapılmış veya özellik tamamlanmış gibi davranma. Depoya erişim yoksa gerçek uygulama incelemesi ve testleri tamamlandı olarak işaretleme.

## 4. Kod ve mimari kuralları

- Mevcut kodu sebepsiz yeniden yazma; tüm dizinleri bir kerede taşımak bu planın işi değildir.
- UI yalnız controller/repository sözleşmelerine dayanır. Yeni widget içine Firebase, dosya IO, crypto veya sync algoritması koyma.
- Mevcut state yönetimi yeterliyse onu kullan. Aynı sorumluluk için ikinci state yönetimi ya da ikinci yerel veritabanı kurma.
- Aynı PDF/çizim işi için birden fazla kopya altyapı üretme; ortak stroke/geometri/araç formatı kullan.
- PDF motorunu adapter arkasında tut. Paket sınıflarını bütün ekranlara ve modellere yayma.
- Tema, boşluklar, kağıt şablonları, araç renk/kalınlığı, autosave ve limitler merkezi tanımlardan gelsin.
- Uygulamanın mevcut not içerik formatını kayıpsız geçiş kanıtı olmadan değiştirme.
- Nullability, hata türleri ve kaynak kapatmayı açık yönet. Stream/controller/PDF handle/listener temizliğini unutma.
- UI iş parçacığında büyük PDF çözme, yoğun serialize veya toplu crypto ile donma oluşturma.
- Gerekçesiz global mutable state, dev ekran dosyaları veya kullanılmayan soyut katmanlar ekleme.
- Projenin Dart biçim/lint kurallarına uy; kullanıcı metinlerini yerelleştirme yaklaşımına bağla.

## 5. Veri kaybını önleme

- Kararlı ID'leri koru. Başlık/dosya adı değişince nesne kimliği değişmesin.
- Değişikliği önce atomik yerel kayıt + kalıcı outbox olarak yaz, sonra buluta gönder.
- Yerel kayıt tamamlanmadan `kaydedildi`, remote commit tamamlanmadan `senkronize edildi` gösterme.
- İnternet, upload veya Auth hatası yerel notun silinme sebebi değildir.
- Sekme, yön veya hesap değişiminde taslağı sessiz kaybetme; bekleyen yerel kayıtları flush et.
- Çıkışta gönderilmemiş içerikleri otomatik silme. Hesaba bağlı alanları ayır; A hesabının verisini B ekranına taşıma.
- İçeriği defterler/belgeler ekranları arasında kopyalayarak ilişkilendirme; aynı nesneyi kararlı ID ile referansla.
- Defter silme varsayılanında içeriği koru; birlikte silme açık seçime ve çöp kutusuna dayansın.
- Soft delete/tombstone kullan; eski offline cihazın silinmiş içeriği yeniden üretmesine izin verme.
- Eski veri için migration + korumalı yedek + geri yükleme doğrulaması hazırla. Hata halinde DB'yi silerek sorunu gizleme.
- Şifre çözülemeyen, formatı tanınmayan veya bozuk veriyi boş içerikle üzerine yazma; orijinali kurtarma için koru.
- Senkronizasyonu yedek olarak tanıtma; yedeğin gerçekten restore edildiğini test et.

## 6. PDF ve çizim kuralları

- İlk sürümde PDF, PNG, JPG/JPEG kapsamını doğru göster. DOCX/EPUB/XPS/SDOCX desteklenmeden destek varmış gibi menü sunma.
- Dosya seçicinin verdiği dış yola kalıcı güvenme; seçilen içeriği uygulamanın özel alanına al.
- Dosya seçimi iptalini hata/çökme olarak değerlendirme. Bozuk, kilitli ve büyük dosyayı kontrollü ele al.
- Orijinal PDF'yi koru; işaretlemeyi ayrı vektör katmanında sakla; export yeni dosya olsun.
- Kullanıcının çizimini yalnız screenshot/bitmap olarak kaydetme. Yeniden açılınca stroke olarak düzenlenebilsin.
- Stroke'u belge/sayfa koordinatlarıyla sakla. Zoom, rotation, CropBox ve ekran genişliği konumu değiştirmesin.
- PDF overlay ile bağımsız çizimler aynı araç/komut formatına dayansın.
- İlk silgi tüm stroke'u kaldırabilir; piksel silgisi gibi davranıyormuş gibi gösterme.
- Kalem/fosforlu kalem/metin kutusu, renk/kalınlık, undo/redo ve kayıt durumu kullanıcıya anlaşılır olsun.
- PDF'yi açabilmek export'u yapabildiğini kanıtlamaz. Motoru seçmeden işaretlemeli çıktı başka görüntüleyicide doğrulanır.
- Raster export gerekirse kalite ve metin seçme/arama kaybını açıkça belirt; sınırlamayı belgede kaydet.
- PDF'de değişiklik eklemenin gerçek hassas veri sansürleme/redaction olduğunu iddia etme.
- Stylus basıncı ve palm rejection için gerçek cihaz testi yap; yalnız simülatörle donanım desteği tamamlandı deme.
- Parola korumalı PDF desteğini gerçek paket sürümünde sınamadan vaat etme; PDF parolasını loglama/saklama.

## 7. Telefon ve tablet kuralları

- Kullanılabilir alanı `LayoutBuilder`/uygun Flutter araçlarıyla ölç; model adına veya sabit fiziksel çözünürlüğe bağlama.
- Mevcut telefon temasını koru; geniş alanda rail ve uygun iki panel kullan.
- PDF listesi tablet genişledi diye zorunlu ızgaraya dönüşmesin; belge listesi/çizim bölümü ürün sözleşmesi korunur.
- Dikey, yatay, bölünmüş ekran ve klavye durumunu destekle; draft/selection state'ini koru.
- 320/390/600/840/1024 dp ve büyük metinle taşma kontrolü yap.
- Dokunma hedefleri, kontrast, Semantics ve Türkçe etiketler yeterli olsun.
- Parmakla çizim ve kalemle çizim modlarını ayrıştır; pan/zoom hareketleri yanlış stroke oluşturmasın.
- Android/iOS/tablet desteği için gerçek derleme ve ilgili cihaz kanıtını raporla; yalnız ekran boyutunu büyütmek tablet testi değildir.

## 8. Güvenlik kuralları

- SHA'nın tek başına içerik şifrelemesi olmadığını esas al. AES-256-GCM gibi standart authenticated encryption'ı güvenilir kütüphane üzerinden uygula; kendi algoritmanı yazma.
- Firebase giriş parolalarını kendi DB/Firestore alanlarında düz metin veya SHA hash olarak tutma; Auth SDK kullan.
- Hesap parolası, kasa parolası, PIN ve biyometri farklı sorumluluklardır; birbirlerinin yerine geçtiğini varsayma.
- Anahtar/parola/recovery kodu/token/içerik/PDF parolası/özel dosya yolu log veya hata raporuna konmaz.
- Hassas başlık, gövde, çizim, PDF, kapak, thumbnail ve backup içeriğini şifrele. Teknik metadata kapsamını minimum tut ve belgede belirt.
- Veri anahtarını kaynak kod, SharedPreferences, DB veya cloud'a açık yazma. Secure storage ve sarılmış anahtar envelope'u kullan.
- Aynı GCM anahtarıyla nonce tekrar kullanma; AAD kayıt/hesap bağını doğru uygula; bozuk tag'i reddet.
- Kasa parolası KDF ile türetilir; SHA(parola), kısa PIN veya sabit salt çözümü üretme.
- Yeni cihaz, kasa parolası değişimi, recovery ve Auth reset farkı test edilmeden E2EE tamamlandı deme.
- Mevcut anahtar açılamayınca otomatik yeni anahtar üretip eski ciphertext'i ezme. Hesap kasa kurulumu yarışlarını güvenli çöz.
- Çıkış/hesap değişiminde kasa ve cache erişimini eski scope'ta kapat; önceki hesabın çözülmüş içeriği ekranda/bellek cache'inde yeniden kullanılmasın.
- Geçici çözülmüş dosyalar, export'lar, arama indeksleri ve thumbnail'lar da güvenlik kapsamındadır.
- Firestore ve Storage kuralları ayrı doğrulanır; yalnız Auth kontrolü bütün hesapları erişilebilir yapmamalıdır.
- Test modu/açık okuma-yazma kurallarını üretime taşıma; sorun çözmek için erişim kurallarını gevşetme.
- Public download URL'sini hassas içerik paylaşımına dönüştürme; yetkili erişim kullan.
- App Check, biyometrik UI kilidi veya SHA checksum'u içerik şifrelemesinin yerine geçmez.
- Mutlak `kaybolmaz/çalınamaz` veya doğrulanmamış E2EE iddiası yazma; kurtarma sınırını açık anlat.

## 9. Senkronizasyon kuralları

- Yerel outbox kalıcı olsun; offline işleyişi online transaction'a bağlama.
- Revizyon ve `operationId` ile idempotency uygula. Cihaz saatini tek çatışma ölçütü yapma.
- Firestore transaction yalnız online çalışır; callback tekrar çalışabileceği için upload/crypto/UI yan etkisini içine koyma.
- Storage upload ve Firestore manifest commit'inin tek atomik işlem olduğunu varsayma.
- Aynı not/çizim iki cihazda değişince sessiz last-write-wins ile kullanıcı verisini ezme; iki sürümü koru.
- Remote pull, yerel dirty kaydı ezmesin. Hesap değişiminde eski worker/listener sonucu yeni hesaba sızmasın.
- Yetim dosya temizliği referans/sürüm/retry durumunu doğrulasın; yeni upload'ı veya gerekli eski sürümü yanlış silmesin.
- Guest-to-account taşıma tekrar çalıştırılabilir olsun; anahtar ve AAD geçişini doğru yap, kaynak veriyi doğrulama öncesi silme.

## 10. Paket ve araç seçimi

- Önce kurulu paketin yeteneğini incele; aynı iş için gereksiz yeni paket ekleme.
- Yeni paket için güncel birincil belgelerden Flutter/Dart/platform uyumu, bakım, lisans, güvenlik ve native derleme koşullarını kontrol et.
- PDF paketindeki `editing` ifadesini tüm PDF düzenleme/export özellikleri anlamında kullanma; tam API ve deneme sonucu gerekir.
- Ücretli SDK veya maliyet doğuran yeni servis önerisini somut ihtiyaç, seçenekler ve maliyet etkisiyle sun.
- Test edilen sürümü kilitle; uygulamaya uyması için tüm paketleri kontrolsüz yükseltme.
- Agentın erişemediği cihaz/servis için sonuç uydurma; sınırı raporla.

## 11. Doğrulama ve tamamlanma

Değişikliğe göre proje format kontrolü, `flutter analyze`, ilgili unit/widget/integration testleri, Firebase Rules testleri ve platform build'i çalıştır. Mevcut CI akışını esas al. Ufak görsel değişikliklerde yapay test yığını üretme; kritik veri, crypto, geometry, migration ve sync değişikliklerinde anlamlı hata/negatif senaryoları doğrula.

Bir iş ancak şu koşullarla tamamlanmıştır:

- Yol haritasındaki ilgili kabul ölçütleri sağlanmıştır.
- Loading/error/empty/iptal ve offline durumları gerekli kapsamda uygulanmıştır.
- Mevcut not/defter/tema/çöp kutusu davranışları korunmuştur.
- Çalıştırılan kontrollerin sonuçları kayıtlıdır; çalıştırılmayanlar açıkça yazılmıştır.
- Migration ve güvenlik etkisi değerlendirilmiştir.
- Geçici mock/hardcoded kullanıcı verisi üretim akışında kalmamıştır.
- `yol_haritasi.md`, `mimari.md` ve gerekirse `project_structure.md` gerçek sonucu yansıtır.

Tek başına derleme başarısını özellik testi sayma. UI'da çizim görünmesini kaydedildi/export edildi sayma. Dosya veya scaffold eklemeyi çalışan ekran sayma. Kısmen tamamlanan işi tüm faz tamamlandı olarak işaretleme.

## 12. Görev sonu raporu

Kısa Türkçe rapor ver:

- **Değişiklik:** kullanıcı için hangi davranış eklendi/düzeldi?
- **Doğrulama:** hangi komutlar, testler ve cihazlar denendi, sonuçları ne?
- **Sınır/engel:** ne tamamlanmadı veya çalıştırılamadı?
- **Sonraki iş:** yol haritasındaki sıradaki somut adım ne?

Güvenlik veya veri kaybı riski kaldıysa sonuçta görünür belirt. Kullanıcı istemedikçe gereksiz bütün projeyi refactor etme, önceki görevlerin tamamlanmış işini tekrar yapma ve talimatları sessizce değiştirme.

## 13. Dosyaların projeye yerleştirilmesi

`agent.md`, `mimari.md` ve `yol_haritasi.md` dosyalarını proje köküne koy. `AGENTS.md` bu kuralları otomatik arayan araçlar için kök girişidir. Araç yalnız kendi özel talimat dosyasını okuyorsa bu belge setini o dosyadan referansla veya görevin başında açıkça okut.

Depoda zaten `AGENTS.md` varsa onu körlemesine değiştirme: mevcut kuralları koruyup bu belge setine okuma yönlendirmesini ekle. Her agentın `agent.md` adını kendiliğinden okuyacağını varsayma.

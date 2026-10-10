# Cute Notes — Yol Haritası

Tarih: 8 Ekim 2026 · Durum: uygulanacak plan, tamamlanmış özellik listesi değildir.

## 1. Amaç ve mevcut bilgi

Cute Notes / Sweetie Notes; telefon ve tablette çalışan, kişiselleştirilebilir defterleri, PDF üzerine not alma ,ayrı olarak tatlı notlar halinde notlar-görevler ekleyebilme ve bağımsız çizim özellikleri bulunan bir Flutter not uygulaması olacaktır. Kullanıcı internetsiz çalışabilmeli; hesabına bağladığı içeriklerini başka cihazında geri alabilmelidir. Güvenlik, veri kaybını azaltma ve mevcut görsel kimliği koruma temel gereksinimlerdir.

Bu planın mevcut projeye ilişkin tek kaynağı `project_structure.md` dosyasıdır. Kaynak kod, `pubspec.yaml`, Firebase kuralları, gerçek veritabanı şeması ve çalışan uygulama incelenmemiştir. Dosya adlarının varlığı özelliklerin çalıştığını kanıtlamaz. Aşağıdaki yeni dosya ve servis isimleri öneridir; agent gerçek depoyu inceleyerek uyarlamalıdır.

Yapı belgesinde mevcut olduğu bildirilen bileşenler:

| Alan | Bildirilen dosyalar | İlk doğrulama |
| --- | --- | --- |
| Başlangıç / Firebase | `main.dart`, `firebase_options.dart` | Gerçek başlangıç akışı, ortam ve paketler |
| Modeller | `note_model.dart`, `notebook_model.dart`, `user_model.dart` | Alanlar, ID'ler, serileştirme ve sahiplik |
| Hesap | `auth_screen.dart`, `auth_service.dart` | Kayıt, giriş, çıkış ve oturum geri yükleme |
| Notlar | `home_notes_screen.dart`, `add_edit_note_screen.dart`, `trash_screen.dart` | Kayıt, düzenleme, silme ve geri alma |
| Defterler | `notebooks_screen.dart`, `add_notebook_screen.dart`, `notebook_cover_widget.dart` | Deftere giriş ve içerik ilişkileri |
| Gezinme / tema | `main_navigation_screen.dart`, `floating_bottom_bar.dart`, `app_theme.dart`, `app_theme_config.dart` | Mevcut görünüm ve sekme davranışı |

## 2. Kullanıcının istediği ürün

### 2.1 Dördüncü gezinme hedefi: Belgeler ve Çizim

Mevcut ana sayfa, defterler ve ayarlar korunur; bunlara(nav bara yeni eklenecek.notlar kısmından sonra) **Belgeler ve Çizim** eklenir. Dar ekranlarda başlık `Belgeler` olarak kısaltılabilir. Mevcut sekme sırası incelenir, yeni sekme Ayarlar'dan önce yerleştirilir; mevcut taslaklar ve gezinme durumu kaybolmaz.

Bu ekranın akışı:

1. Üstte başlık, arama ve sağ üstte `ataç simgesi` ile `kalem simgesi` bulunur.
2. `ataç simgesi` tıklayınca `PDF içe aktar`, `Görsel içe aktar` seçilir.
3. İlk bölüm **PDF ve Belgeler**: dosyalar Samsung Notes benzeri anlaşılır satırlar halinde alt alta gösterilir. Her satırda küçük önizleme, başlık, değiştirilme tarihi ve işlem menüsü vardır.
4. Ataç simgesinin yanında **Çizim Defterleri** bölümü bulunur. `kalem simgesi` ile çizim sayfasına gidilir. Bağımsız çizimler PDF yüklemeden açılabilir ve aynı ekrandan tekrar bulunur.
5. Tabletlerde de belge satırları liste olarak kalır. Genişlik elverdiğinde seçili belgenin önizlemesi veya editörü yanında açılır; bu, listeyi zorunlu bir ızgaraya dönüştürmez.
6. Boş liste, yükleme, içe aktarma ilerlemesi, iptal, hata ve yeniden deneme durumları tasarlanır.

Samsung Notes burada etkileşim referansıdır. Cute Notes'un renkleri, defter kapakları, ikon dili ve mevcut tema yaklaşımı korunur.

### 2.2 Destek kapsamı

| Özellik | İlk sürüm | Sonraki sürüm / koşul |
| --- | --- | --- |
| `.pdf` içe aktarma | Evet | Parola korumalı PDF desteği paket denemesine bağlı |
| `.png`, `.jpg`, `.jpeg` | Çizim sayfasına arka plan olarak eklenebilir | Çoklu görselden PDF oluşturma |
| PDF üzerine kalem / fosforlu kalem / metin kutusu | Evet | Seçili metne gerçek PDF highlight annotation |
| PDF'nin mevcut metnini değiştirme | İlk sürüm dışında | Ayrı PDF düzenleme motoru ve fizibilite gerekir |
| PDF sayfa silme / birleştirme / yeniden sıralama | İlk sürüm dışında | Kaynak sayfa kimlikleri ve dışa aktarma doğrulanınca |
| Çizim | Çok sayfalı, düzenlenebilir vektör çizimleri | Şekiller, cetvel, gelişmiş seçim ve katman paneli |
| Dışa aktarma | İşaretlemeleri içeren PDF; çizim için PNG ve PDF | Diğer uygulamalarda düzenlenebilir native PDF annotations |
| DOCX / PPTX / EPUB / XPS / Samsung `.sdocx` | Desteklenmiş gibi gösterilmez | Her format için ayrı dönüştürme/okuma denemesi |

İlk sürümde fosforlu kalem, sayfa üzerinde yarı saydam çizimdir; metin semantiği içermez. PDF'nin orijinali korunur, eklenen içerik ayrı düzenlenebilir katmanda saklanır. Dışa aktarılan düzleştirilmiş kopya ile uygulamadaki düzenlenebilir belge aynı şey değildir.

### 2.3 Defter kişiselleştirme

Deftere dokunmak defter detayını açmalıdır. İçeride defter oluşturma, düzenleme, arama, sıralama, başka deftere taşıma, ekleme,sabitleme, çöp kutusu ve geri yükleme bulunur. PDF ve çizimler de bir deftere bağlanabilir; belgeler ekranında görünmeye devam eder, kopyalanmaz.oluşturduğumuz defterlerin içi adeta kitap gibi sayfalardan oluşur bir sonraki sayfayı açmalı, önceki sayfayı açmalı, sola kaydırarak sayfa açmalı, sağ kaydırarak sayfa kapatmalı vb. davranışı olmalı. sayfaların kenarından tutarak sağa sola kaydırarak önceki ve sonraki sayfayı açmalı ve kapamalı, aynı zamanda sayfaları silmeli ve sayfaları başka defterlere eklemeli vb. 
sayfalara not alırken dokunduğumuzda sayfa içeriği aşağı kaymalı ve kalemi seçtiğimizde sayfanın üstünde notlarımızı yazabileceğimiz bir alan gelmeli.hatta bu deftere alttan seçenek olarak sticker ekleyip defterin istediğimiz bir yerine sürüklenebilmeli ve istediğimiz büyüklüğe getirilebilmeli, döndürülebilmeli.   

İlk kişiselleştirme araçları: defter adı, kapak rengi/deseni, mevcut stile uygun ikon, varsayılan kağıt türü (boş, çizgili, kareli, noktalı) ve favori/sabitleme. Özel kapak görseli; dosya boyutu, kırpma ve şifreli saklama tamamlandıktan sonra eklenir. Not başına tema uygulamanın genel temasını değiştirmez. Defterin varsayılan kağıdını değiştirmek eski sayfaları kendiliğinden dönüştürmez.

Defter silerken varsayılan davranış içeriklerini koruyup `Deftersiz` alanına taşımaktır. İçerikle birlikte silme ayrıca açıkça seçilir ve çöp kutusuna gönderir.

### 2.4 Telefon, tablet ve düzenlenebilir geliştirme akışı

İlk hedef Android telefon ve Android tablettir; iOS telefon/tablet için kodun taşınabilirliği korunur, destek iddiası gerçek iOS derlemesi ve cihaz testi sonrasında yapılır. Yön değişimi, bölünmüş ekran, sanal klavye, yazı büyütme, dokunma ve desteklenen kalem girdisi hesaba katılır.Ama öncelik android telefon ve tablet içindir.

Her faz bir çalışan sonuç üretir. Geliştirici aynı veri setiyle ekranları deneyebilir, tema/kağıt/araç parametrelerini merkezi ayarlardan değiştirebilir ve bir sonraki adıma geçmeden hataları düzeltebilir. Geçici deneme verileri gerçek kullanıcı hesabına karıştırılmaz.

## 3. Fazlar ve tamamlanma ölçütleri

Fazlar tarih taahhüdü değildir. Kod denetimi ve PDF prototipinden sonra gerçek iş tahmini yapılır. Her fazın sonucu ve test kanıtı bu dosyadaki takip tablosuna yazılır.

### F0 — Gerçek projeyi incele ve riskli parçaları dene

**İşler:**

- Depodaki agent talimatlarını, `pubspec.yaml` / kilit dosyasını, Flutter/Dart sürümünü, not kaydetme akışını, mevcut state yönetimini ve Firebase yapılandırmasını oku.
- Mevcut ekranların telefon/tablet görüntülerini ve çalışan not/defter/tema/çöp kutusu davranışlarını kaydet.
- Verinin bugün nerede bulunduğunu ve hesaplara nasıl bağlandığını belirle. Test ortamı ile üretim ortamını ayır.
- PDF için küçük prototip: içe aktar → aç → zoom/rotate → çizim bindir → kaydet → yeniden aç → işaretlemeli PDF dışa aktar → başka görüntüleyicide aç.
- Seçilecek PDF paketinin tam sürümünde gerekli API, lisans, native derleme, tema/Türkçe arayüz uyumu ve export desteğini doğrula. Paket adı veya görüntüleme demosu, export desteği kanıtı sayılmaz.
- Yerel verinin şifreli saklanması ve kasa anahtarının güvenli saklanması için kısa teknik deneme yap.

**Tamamlandı sayılır:** gerçek durum raporu, kaybolmaması gereken veri örnekleri ve PDF/export denemesinin sonucu vardır. Uygulanamayan özellik belgelenir; çalışan prototip olmadan PDF motoru kalıcılaştırılmaz.

### F1 — Veriyi koruyan yerel temel

**Bağımlılık:** F0.

**İşler:**

- `mimari.md` sınırlarına göre repository arayüzleri ve yerel kaynak ekle; ekranlardan doğrudan veritabanı erişimini aşamalı kaldır.
- Kararlı kimlikler, `schemaVersion`, soft delete, revizyon bilgileri, değişiklik kuyruğu ve atomik yerel kayıt kur.
- Not, defter ve belge kayıtlarını aynı sahiplik kapsamına bağla. Büyük dosyaları veritabanı satırlarına koyma.
- Mevcut veriyi yedekleyerek sürümlü migration yaz. Sıfırdan kurulum ve güncelleme yollarını ayrı dene.
- Kaydetme durumunu `Kaydediliyor`, `Cihaza kaydedildi`, `Hata` olarak doğru göster; bulut durumu ayrıca gösterilir.

**Tamamlandı sayılır:** internetsiz not yazılıp uygulama yeniden açıldığında geri gelir; başarısız yazma başarılı görünmez; migration içerik/ID/defter ilişkilerini korur. Bu aşamadaki geliştirme verisi üretim güvenliği tamamlanmış sayılmaz.

### F2 — Hesap, kasa ve güvenlik temeli

**Bağımlılık:** F1.

**İşler:**

- Mevcut Auth akışını doğrula ve tamamla: e-posta/parola kayıt-giriş, e-posta doğrulama, parola sıfırlama, oturum geri yükleme, çıkış.
- Misafir yerel çalışma alanı ile her hesabın yerel çalışma alanını ayır. Hesap değişiminde önceki hesabın içeriği görünmesin.
- Hassas içerikleri AES-256-GCM ile istemcide şifrele; anahtar, parola, nonce/tag yönetimini `mimari.md` politikasına göre uygula.
- Hesap parolasından ayrı kasa parolası ve kurtarma kodu akışını kur. Yeni cihaz erişimi için anahtar kurtarma denemesini yap.
- Firestore ve Storage için UID sahipliği, alan doğrulama ve boyut sınırlarını kapsayan kapalı varsayılan kurallar hazırla ve emülatörde doğrula.
- Çıkış öncesi bekleyen yerel kayıtları tamamla; gönderilmemiş veriyi sessizce silme. Cihazdan kaldırma işlemini ayrı sun.

**Tamamlandı sayılır:** A hesabı B hesabının Firestore ve Storage verilerini okuyamaz/yazamaz; diskte ve bulutta hassas payload açık değildir; yanlış kasa parolası açamaz; kurtarma kodu test cihazında çalışır. Giriş yapmak tek başına kasayı çözmüş gibi gösterilmez.

### F3 — Dördüncü sekme ve uyarlanabilir iskelet

**Bağımlılık:** F1; hesap entegrasyonu F2 ile tamamlanır.

**İşler:**

- Yeni Belgeler ve Çizim ekranını, `+` menüsünü, belge listesini ve alt çizim bölümünü oluştur.
- Mevcut yüzer alt çubuğu dört hedefe uyarla. Geniş alanda aynı hedefleri `NavigationRail` ile sun.
- Ortak breakpoint, boşluk, dokunma alanı, metin stili ve editör panel kurallarını merkezi hale getir.
- Sekme değişiminde seçili defter, liste konumu ve editör taslağını koru. Klavye ve güvenli ekran alanını hesaba kat.

**Tamamlandı sayılır:** dört hedef erişilebilir; 320, 390, 600, 840 ve 1024 mantıksal piksel genişlikte taşma yoktur; PDF listesi altında bağımsız çizim bölümü vardır. Mock veri yalnızca geliştirme modundadır.

### F4 — Defter detayları ve kişiselleştirme

**Bağımlılık:** F1–F3.

**İşler:** defter detay ekranı; not CRUD; deftere taşıma; arama/sıralama; kapak/ikon/renk/kağıt ayarları; soft delete/geri yükleme; boş ve hata durumları.

**Tamamlandı sayılır:** bir defter oluşturulabilir, içine girilebilir, not eklenebilir, kapak ve kağıt seçimi yeniden açılışta korunur. İçerik başka deftere taşınırken kopya veya kayıp oluşmaz. Defter silme davranışı içerikleri varsayılan olarak korur.

### F5 — Ortak çizim motoru ve bağımsız çizimler

**Bağımlılık:** F1–F3. Defter bağlantısı F4'e dayanır.

**İşler:**

- `CustomPainter` tabanlı ortak yüzey: kalem, fosforlu kalem, stroke silgisi, renk, kalınlık, geri al/ileri al ve sayfa ekleme.
- Sonuçları resim yerine vektör stroke verisi olarak sakla. PDF ve çizim aynı stroke formatını kullansın.
- Tek sayfada çalışma, zoom/pan, dokunma/kalem modları ve destek varsa basınç değerlerini yönet.
- Boş, çizgili, kareli ve noktalı kağıt; otomatik kayıt; çizimi yeniden açma; PNG/PDF export ekle.
- Kalemle çiz / parmakla kaydır seçeneğini sun. Kalem bulunmayan telefonda parmakla çizim açıkça seçilebilir olsun.

**Tamamlandı sayılır:** çok sayfalı çizim yeniden düzenlenebilir açılır; undo/redo doğru çalışır; zoom/yön değişiminde stroke konumları korunur; ekrandan çıkış ve arka plana geçişte kayıt denemesi yapılır. Gerçek kalemli tablette test edilmemiş avuç içi reddi veya basınç desteği tamamlandı sayılmaz.

### F6 — PDF içe aktarma, işaretleme ve export

**Bağımlılık:** F0 PDF prototipi, F2 ve F5.

**İşler:**

- Dosya seçiciden PDF'yi uygulamanın özel alanına kopyala; dış dosya yoluna kalıcı bağımlılık oluşturma.
- PDF render, sayfa gezinme, sayfa bazında çizim/fosforlu kalem/metin kutusu, otomatik kayıt ve yeniden açma uygula.
- Kullanıcı çizimlerini sayfa koordinatlarında sakla. Zoom, döndürülmüş sayfa, CropBox ve farklı sayfa boyutlarını test et.
- Orijinali değiştirmeden ayrı çıktı üret. Export ilerlemesi, iptal, hata ve güvenli geçici dosya temizliğini ekle.
- Dosya boyutu, sayfa sayısı, disk alanı, bozuk dosya, desteklenmeyen format, kilitli PDF ve dosya seçici iptali için sonuç göster.
- Belge yeniden adlandırma, deftere bağlama, arama, soft delete ve geri alma ekle.

**Tamamlandı sayılır:** kullanıcı PDF yükleyebilir, üzerine çizip metin ekleyebilir, kapatıp açabilir ve başka PDF uygulamasında görünen bir çıktı alabilir. Orijinal korunur; telefonda ve tablette aynı işaretlemeler doğru yerde görünür. Export edilemeyen overlay yalnız başına bu fazı tamamlamaz.

### F7 — Çok cihazlı senkronizasyon ve geri yükleme

**Bağımlılık:** F1, F2 ve ilgili içerik fazları.

**İşler:**

- Firestore'da şifreli küçük kayıtlar/manifests; Storage'da şifreli PDF, kapak, çizim segmentleri ve ekler kullan.
- Kalıcı outbox, yeniden deneme, idempotency, revizyon kontrolü, çatışma kopyaları ve tombstone senkronizasyonu uygula.
- Hesaba aktarılan misafir verisini kullanıcı seçimiyle ve tekrar çalıştırılabilir migration ile taşı.
- Yeni cihazda giriş → kasa açma → metadata indirme → içerik/ekleri gerektiğinde indirme akışını doğrula.
- Şifreli yedek export/import ekle. Eşitlemenin yanlışlıkla silinmeyi de yayabileceğini hesaba katarak yedek ve sürüm geri dönüşünü ayrı tut.
- Hesap silme, cloud nesne temizliği ve tutarsız/yetim upload temizliği akışlarını belirle.

**Tamamlandı sayılır:** telefon ve tablette aynı hesapla veriler açılır; offline değişiklikler bağlantı gelince gönderilir; iki cihaz aynı notu değiştirince biri sessizce ezilmez. PDF upload yarıda kalırsa yerel belge kaybolmaz. Yedek boş bir test kurulumu üzerinde gerçekten geri yüklenir.

### F8 — Cihaz testleri, performans ve sürüm adayı

**Bağımlılık:** F0–F7.

**İşler:** kritik akış testleri, gerçek telefon/tablet/stylus denemeleri, profile-mode performans ölçümü, erişilebilirlik, hata metinleri, güncelleme migration'ı ve release build.

**Tamamlandı sayılır:** aşağıdaki matrisin kritik satırları geçer; kaynak kodda geçici veriler/anahtarlar yoktur; release derlemesi denenmiştir; bilinen sorunlar ve desteklenmeyen durumlar kayıtlıdır. E2EE, tablet veya iOS desteği yalnızca gereken test kanıtıyla tamamlandı olarak işaretlenir.

## 4. Test ve düzenleme matrisi

| Test | Ortam / senaryo | Beklenen sonuç |
| --- | --- | --- |
| Dar ekran | 320 / 390 dp, dikey, büyük metin | Sekmeler ve araçlar erişilebilir; taşma yok |
| Tablet | 600 / 840 / 1024 dp, yatay-dikey | Gerektiğinde rail/panel düzeni; içerik konumu korunur |
| Bölünmüş ekran / klavye | Tablet penceresi küçülür, klavye açılır | Mevcut alan ölçülür; kaydet/araçlar kapanmaz |
| Defterler | Kapak değiştir, not taşı, defter sil/geri al | ID ilişkileri ve kişiselleştirme korunur |
| Çizim | Uzun çizim, undo/redo, zoom, sayfa değiştir | Doğru stroke/sayfa, yeniden düzenlenebilir kayıt |
| Kalem | Desteklenen gerçek Android tablet | Basınç varsa çalışır; parmakla gezinme çizgi üretmez |
| PDF geometrisi | A4/A5/karma boyut, 90°/180°/270°, crop | Ekran ve export konumları eşleşir |
| PDF hata durumları | Bozuk, parola korumalı, büyük, iptal | Kayıp/çökme yok; destek sınırı açık |
| PDF büyüklüğü | 1 / 20 / 100 sayfa, 5 / 25 / 50 MB | Lazy render; kontrolsüz RAM artışı yok |
| Kayıt ve kapanma | Kaydet, arka plana al, zorla kapat, aç | Tamamlanmış yerel kayıt geri gelir; hata başarı görünmez |
| Offline | Not/çizim/PDF işaretle, sonra online ol | Yerel çalışma sürer; kuyruk tekrar denenir |
| Hesap izolasyonu | A giriş, çıkış, B giriş | A'nın yerel/bulut içeriği B'de görünmez |
| Yetkilendirme | A ile B'nin Firestore/Storage yollarını dene | Sunucu kuralları erişimi reddeder |
| Anahtar kurtarma | Yeni cihaz, yanlış parola, recovery kodu | Sadece doğru açma yolu işler; içerik loglanmaz |
| Çatışma | İki cihaz aynı notu/çizimi offline değiştirir | İki sürüm korunur; seçilebilir çatışma sonucu |
| Yedek / güncelleme | Yedekten temiz kuruluma dön; eski şemayı aç | İçerik ve ilişkiler korunur |
| Mevcut özellikler | Tema, arama, çöp kutusu, eski editör | Yeni geliştirme regresyon oluşturmaz |

Bu boyutlar uygulamanın test hedefleridir, paket kapasitesi garantisi değildir. İlk ölçümden sonra PDF/çizim kaynak sınırları merkezi yapılandırmada kesinleştirilir. Zorla kapatma testinde son ekrandaki her milisaniyelik girdi için garanti verilmez; UI yalnızca atomik kaydı tamamlanan içeriği kaydedildi olarak gösterir.

Geliştirici gerçek depoda şu doğrulamaları çalıştırır: proje biçim kontrolü, `flutter analyze`, ilgili `flutter test` grupları, kritik `integration_test` senaryoları, Firebase kural testleri ve Android release build. Mevcut CI komutları varsa bunlar esas alınır. Bu belgeyi hazırlarken uygulama testleri çalıştırılmamıştır.

## 5. Faz takibi

| Faz | Durum | Test / çıktı | Bilinen engel |
| --- | --- | --- | --- |
| F0 | Tamamlandı | Mevcut kod incelendi. pdfrx+pdf prototipi ve crypto prototipi yazılıp test edildi (test klasöründe). mevcut_durum_raporu.md oluşturuldu. | PDF prototipi `flutter test` headless ortamında `pdfrx` native binding hatası verdiğinden (beklenen durum), mock export ile doğrulandı. |
| F1 | Başlanmadı | — | F0 tamamlandı, F1'e geçilebilir. |
| F2 | Başlanmadı | — | F1 |
| F3 | Başlanmadı | — | F1 |
| F4 | Başlanmadı | — | F2–F3 |
| F5 | Başlanmadı | — | F2–F3 |
| F6 | Başlanmadı | — | PDF/export kanıtı, F5 |
| F7 | Başlanmadı | — | Hesap/kasa ve veri temeli |
| F8 | Başlanmadı | — | Önceki fazlar |

Agent her görev sonunda yalnızca gerçekten ilerlettiği satırları günceller. Sıradaki iş: F0 gerçek kod incelemesi; mevcut not kaydetme/defter giriş akışlarının doğrulanması ve PDF/export prototipi.

## 6. Sonraya ayrılan geliştirmeler

OCR, el yazısını metne çevirme, gerçek zamanlı ortak düzenleme, gelişmiş PDF metin düzenleme, çok sayıda yeni format, mağaza/abonelik ve AI özellikleri bu ilk planın kapsamı değildir. İhtiyaç geldikçe ayrı faz ve kabul ölçütleriyle eklenir. Öncelik mevcut not deneyimini tamamlamak ve yeni içeriği güvenilir saklamaktır.

## 7. İlgili belgeler

- `mimari.md`: veri, dosya, çizim, güvenlik ve senkronizasyon kararları.
- `agent.md`: uygulayan agentın çalışma kuralları.
- `AGENTS.md`: kuralları otomatik bulan araçlar için giriş dosyası.

Teknik kaynaklar ve doğrulama bağlantıları `mimari.md` sonunda bulunur.

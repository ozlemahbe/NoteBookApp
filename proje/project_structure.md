# Cute Notes — Proje Yapısı ve Mevcut Durum Özeti

Bu belge uygulamanın gerçek kod yapısına göre güncellenmiştir.

## Dizin Yapısı

- **lib/**: Uygulama kodlarının bulunduğu ana dizin. Katmanlı mimari için `models`, `screens`, `services`, `theme`, `widgets` şeklinde ayrılmıştır. Ancak *Repository* ve *Controller* gibi katmanlar henüz klasör olarak oluşturulmamıştır.
- **test/**: Uygulamanın test kodları bulunur. İçerisinde UI testlerini barındıran `widget_test.dart` ile prototip testlerini barındıran `crypto_spike_test.dart` ve `pdf_spike_test.dart` mevcuttur.

## Katmanlar ve Bileşenler

### Modeller (`lib/models/`)
- `note_model.dart`: Not verilerini tutan veri sınıfı. İçinde `mockNotes` adında geçici bellek verileri var.
- `notebook_model.dart`: Defter verilerini tutan sınıf. Benzer şekilde `mockNotebooks` içeriyor.
- `user_model.dart`: Basit bir kullanıcı sınıfı.

### Ekranlar (`lib/screens/`)
- `main_navigation_screen.dart`: Uygulamanın iskeleti. State, `_notes` ve `_notebooks` listeleri halinde **sadece burada bellekte** tutulmaktadır. State Management paketi yoktur.
- `home_notes_screen.dart`: Notların GridView ile listelendiği ana sayfa. Tablet uyumluluğu eksik (sabit 2 kolonlu yapı var).
- `add_edit_note_screen.dart`: Not ekleme ve düzenleme ekranı. UI tamamlanmış ancak kayıt işlemi kalıcı değildir, önceki ekrana (in-memory listeye) iletilmektedir.
- `settings_screen.dart`: Ayarlar sayfası (Tema seçimi vs.).
- `trash_screen.dart`: Silinen notlar bellekte tutularak burada listelenir.
- `auth_screen.dart`: Giriş ve kayıt ekranı (Firebase Auth kullanır).
- Diğer klasörler (Defter yönetimi vb.) UI olarak mevcuttur ancak kalıcı veri yoktur.

### Servisler (`lib/services/`)
- `auth_service.dart`: Firebase Authentication ile kayıt ve giriş işlemlerini yapar. Başka hiçbir servis (`sync_service`, `storage_service` vb.) henüz yoktur.

### Widget'lar (`lib/widgets/`)
- `floating_bottom_bar.dart`: Özel navigasyon çubuğu.
- `note_card.dart`, `note_editor_toolbar.dart`, `search_bar_widget.dart` vb. paylaşılan bileşenler içerir.

## Mimari Uyuşmazlıklar (F0 itibarıyla düzeltilecekler)
1. **Veritabanı Yok:** Projede kalıcı depolama (Firestore veya SQLite) altyapısı bulunmamaktadır.
2. **State Management Yok:** Tüm veriler UI bileşenlerinde `setState` ile in-memory tutulmaktadır. Mimari belgeye göre Riverpod vb. ile Controller katmanı kurulması önerilir (veya yerel veritabanı kurulduğunda repository katmanı üzerinden beslenmelidir).
3. **Güvenlik ve Kriptografi:** Henüz E2EE implementasyonu mevcut değildir (prototipi yazılmıştır).
4. **PDF Motoru:** `pdfrx` ve `pdf` kullanılarak prototip yapılmış olup, entegrasyon için beklenmektedir.

#include <SPI.h>
#include <MFRC522.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <EEPROM.h>


//WiFiClient client;
long myChannelNumber = 2477219;
const char myWriteAPIKey[] = "0ZZRTRTYCO8WMX8L";



// #define BLYNK_TEMPLATE_ID "TMPL3mquuDDpR"
// #define BLYNK_TEMPLATE_NAME "test"
// #define BLYNK_AUTH_TOKEN "HMRvlca4Q8sw1Wr3JmVuBYQEspb_sZsm"
// #include <BlynkSimpleEsp8266.h>
// #define BLYNK_PRINT Serial
// BlynkTimer timer;



#define SCREEN_WIDTH 128  // OLED display width, in pixels
#define SCREEN_HEIGHT 64  // OLED display height, in pixels

// Declaration for SSD1306 display connected using I2C
#define OLED_RESET -1  // Reset pin
#define SCREEN_ADDRESS 0x3C
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

#define RST_PIN 0
#define SS_PIN 15

MFRC522 mfrc522(SS_PIN, RST_PIN);
MFRC522::MIFARE_Key key;


const char* ssid = "John Cena";
const char* password = "youcantseeme";

const char* host = "script.google.com";  //https://script.google.com/
const int httpsPort = 443;


WiFiClientSecure client;
String Gas_1 = "AKfycbzAzgNsvBUg511pSJBzh4Ebr63WLpLlLvr9qOZA8SXGcs9-OYckTZ_H8GZeBl2cXQ6xjw";
String Gas_2 = "AKfycbwbs6PrPZV_2dpI6gZ5zjqdOt_jQRLUqNHxEPdIf_NUsQmMXYX50Q9S7hpfc4p6rOB0";
String Gas_3 = "AKfycbyIkOMNmI6RTvsnqsHbrG0SBqwCSHluUU_kgg9UMp1T1FNn_tC-SATQOHSypNA987RY";

int lastBillIDAddress = 0;  // Address in EEPROM to store the last used bill ID
int currentBillID = 201;


const int n = 7;

struct Item {
  String name;
  int price;
  float brand_rec;
  int shelves;
  int level;
};
Item items[n];

int quantity[n] = { 0 };

int shelf[n];
int inv[n];

int getindex(String name) {
  for (int i = 0; i < n; i++) {
    if (items[i].name == name) {
      return i;  // Return price if item found
    }
  }
  return -1;  // Return -1 if item not found
}

void setup() {

  // Blynk.begin(BLYNK_AUTH_TOKEN, ssid, password);


  Serial.begin(115200);
  while (!Serial)
    ;
  SPI.begin();
  mfrc522.PCD_Init();
  WiFi.begin(ssid, password);

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(250);
  }

  Serial.println("");
  Serial.print("Successfully connected to : ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  client.setInsecure();

  EEPROM.get(lastBillIDAddress, currentBillID);

  for (byte i = 0; i < 6; i++) {
    key.keyByte[i] = 0xFF;
  }

  items[0].name = "bread";
  items[0].price = 23;
  items[0].brand_rec = 0.6;
  items[0].shelves = 2;
  items[0].level = 1;
  shelf[0] = 10;
  inv[0] = 100;
  items[1].name = "butter";
  items[1].price = 58;
  items[1].brand_rec = 0.8;
  items[1].shelves = 2;
  items[1].level = 3;
  shelf[1] = 10;
  inv[1] = 100;
  items[2].name = "flour";
  items[2].price = 49;
  items[2].brand_rec = 0.5;
  items[2].shelves = 3;
  items[2].level = 3;
  shelf[2] = 10;
  inv[2] = 100;
  items[3].name = "milk";
  items[3].price = 74;
  items[3].brand_rec = 0.85;
  items[3].shelves = 3;
  items[3].level = 2;
  shelf[3] = 10;
  inv[3] = 100;
  items[4].name = "tea";
  items[4].price = 300;
  items[4].brand_rec = 0.4;
  items[4].shelves = 2;
  items[4].level = 2;
  shelf[4] = 10;
  inv[4] = 100;
  items[5].name = "cheese";
  items[5].price = 100;
  items[5].brand_rec = 0.5;
  items[5].shelves = 1;
  items[5].level = 1;
  shelf[5] = 10;
  inv[5] = 100;
  items[6].name = "chocolate";
  items[6].price = 60;
  items[6].brand_rec = 0.95;
  items[6].shelves = 2;
  items[6].level = 1;
  shelf[6] = 10;
  inv[6] = 100;

  pinMode(D0, OUTPUT);


  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;  // Don't proceed, loop forever
  }
  // // Clear the buffer.
  display.clearDisplay();
  // // Display Text
  display.setTextSize(1);
  display.setTextColor(WHITE);

  display.setCursor(0, 1);
  display.setTextSize(2);
  display.println("Smart");
  display.println("Shopping");
  display.println("Cart.");
  display.display();
  display.startscrollright(0x00, 0x07);
  delay(1000);
  display.startscrollleft(0x00, 0x07);
  delay(1000);
}

void loop() {


  // Blynk.run();
  // timer.run();


  display.clearDisplay();
  display.setCursor(0, 1);
  if (!mfrc522.PICC_IsNewCardPresent())
    return;

  if (!mfrc522.PICC_ReadCardSerial())
    return;
  String tag = "";
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    tag += String(mfrc522.uid.uidByte[i], HEX);
  }
  if (tag == "f24dde54") {
    digitalWrite(D0, HIGH);
    delay(200);
    digitalWrite(D0, LOW);
    delay(200);
    digitalWrite(D0, HIGH);
    delay(200);
    digitalWrite(D0, LOW);
    display.setCursor(0, 1);
    Serial.println("Welcome Customer 1");
    display.println("Welcome");
    display.println("Customer 1");
    display.display();
    cart(tag);
  } else if (tag == "cdf57bc3") {
    digitalWrite(D0, HIGH);
    delay(200);
    digitalWrite(D0, LOW);
    delay(200);
    digitalWrite(D0, HIGH);
    delay(200);
    digitalWrite(D0, LOW);
    display.setCursor(0, 1);
    Serial.println("Welcome Customer 2");
    display.println("Welcome");
    display.println("Customer 2");
    display.display();
    cart(tag);

  }
}

void cart(String& s) {
  int cust = 0;
  if (s == "f24dde54") cust = 1;
  else cust = 2;
  int total = 0;
  delay(1000);
  String tagst = "";
  while (tagst != s) {
    display.clearDisplay();
    delay(500);
    tagst = "";
    if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
      for (byte i = 0; i < mfrc522.uid.size; i++) {
        tagst += String(mfrc522.uid.uidByte[i], HEX);
      }
      if (tagst == s) break;
      byte sector = 1;
      byte blockAddr = 4;
      byte dataBlock[25];  // Array to hold the data read from the card
      byte size = sizeof(dataBlock);
      byte status;

      status = mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_B, blockAddr, &key, &(mfrc522.uid));
      if (status != MFRC522::STATUS_OK) {
        Serial.print(F("PCD_Authenticate() failed: "));
        Serial.println(mfrc522.GetStatusCodeName((MFRC522::StatusCode)status));
        return;
      }

      String item = "";
      status = mfrc522.MIFARE_Read(blockAddr, dataBlock, &size);
      if (status != MFRC522::STATUS_OK) {
        Serial.print(F("MIFARE_Read() failed: "));
        Serial.println(mfrc522.GetStatusCodeName((MFRC522::StatusCode)status));
      } else {
        // Convert the data to a string
        item = "";
        for (int i = 0; i < size; i++) {
          if ((char)dataBlock[i] == 'H' || (char)dataBlock[i] == 'U' || (char)dataBlock[i] == 'x') continue;
          if ((char)dataBlock[i] == ' ') item += (char)dataBlock[i];
          else if ((char)dataBlock[i] <= 'z' && (char)dataBlock[i] >= 'a') item += (char)dataBlock[i];
          else if ((char)dataBlock[i] <= 'Z' && (char)dataBlock[i] >= 'A') item += (char)dataBlock[i];
        }
        if (item != "I") {
          int ind = getindex(item);
          // int rem = digitalRead(D0);
          // if(rem == 1)
          // {
          //   quantity[ind]--;
          //   total = total - items[ind].price;
          //   digitalWrite(D4, HIGH);
          //   display.clearDisplay();
          //   delay(500);
          //   display.setCursor(0, 1);
          //   display.println(item);
          //   display.println("removed");
          //   display.startscrollright(0x00, 0x07);
          //   display.display();
          //   Serial.println(item + " removed");
          //   delay(1000);
          //   display.clearDisplay();
          //   digitalWrite(D4, LOW);
          //   shelf[ind]++;
          // }
          // else
          // {
          digitalWrite(D0, HIGH);
          display.clearDisplay();
          delay(500);
          display.setCursor(0, 1);
          if(shelf[ind] == 0 && inv[ind] <= 10)
          {
            display.println(item);
            display.println("cannot be added");
            display.startscrollright(0x00, 0x07);
            display.display();
            Serial.println(item + " cannot be added");
          }
          else
          {
              display.println(item);
              display.println("added");
              display.startscrollright(0x00, 0x07);
              display.display();
              Serial.println(item + " added");
              quantity[ind]++;
              total = total + items[ind].price;
              if(shelf[ind] == 0) inv[ind]--;
              else shelf[ind]--;
              // Blynk.virtualWrite(V4, item);
              // Blynk.virtualWrite(V5, items[ind].price);
              // Blynk.virtualWrite(V6, currentBillID);
              // Blynk.virtualWrite(V7, quantity[ind]);
              // Blynk.virtualWrite(V8, total);
          }
          delay(1000);
          display.clearDisplay();
          digitalWrite(D0, LOW);
          }
        //}
      }
      mfrc522.PICC_HaltA();
      mfrc522.PCD_StopCrypto1();
    }
  }
  digitalWrite(D0, HIGH);
  delay(200);
  digitalWrite(D0, LOW);
  delay(200);
  digitalWrite(D0, HIGH);
  delay(200);
  digitalWrite(D0, LOW);
  Serial.print("Total = ");
  Serial.println(total);
  display.clearDisplay();
  display.setCursor(0, 1);
  display.println("Total = ");
  display.print(total);
  display.startscrollright(0x00, 0x07);
  display.display();
  delay(2000);
  display.clearDisplay();
  display.setCursor(0, 1);
  Serial.println("Goodbye");
  for (int i = 0; i < n; i++) {
    if (quantity[i] > 0) {
      if(shelf[i] == 0)
      {
        shelf[i] = min(10, inv[i]);
        inv[i] = inv[i] - min(10, inv[i]);
      }
      delay(2000);

      if (!client.connect(host, httpsPort)) {
        Serial.println("connection failed");
        return;
      }
      String url1 = "/macros/s/" + Gas_1 + "/exec?name=" + items[i].name + "&quantity=" + quantity[i] + "&price=" + items[i].price + "&shelves=" + items[i].shelves + "&level=" + items[i].level + "&brand_recognition=" + items[i].brand_rec + "&bill_id=" + currentBillID;
      client.print(String("GET ") + url1 + " HTTP/1.1\r\n" + "Host: " + host + "\r\n" + "User-Agent: BuildFailureDetectorESP8266\r\n" + "Connection: close\r\n\r\n");

      if (!client.connect(host, httpsPort)) {
        Serial.println("connection failed");
        return;
      }
      String url3 = "/macros/s/" + Gas_3 + "/exec?name=" + items[i].name + "&price=" + items[i].price + "&stock=" + inv[i] + "&shelf=" + shelf[i];
      client.print(String("GET ") + url3 + " HTTP/1.1\r\n" + "Host: " + host + "\r\n" + "User-Agent: BuildFailureDetectorESP8266\r\n" + "Connection: close\r\n\r\n");
    }
  }
  if (!client.connect(host, httpsPort)) {
    Serial.println("connection failed");
    return;
  }
  String url2 = "/macros/s/" + Gas_2 + "/exec?customer_id=" + cust + "&bill_id=" + currentBillID;
  client.print(String("GET ") + url2 + " HTTP/1.1\r\n" + "Host: " + host + "\r\n" + "User-Agent: BuildFailureDetectorESP8266\r\n" + "Connection: close\r\n\r\n");
  
  currentBillID++;
  EEPROM.put(lastBillIDAddress, currentBillID);
  EEPROM.commit();
  delay(1000);
  for (int i = 0; i < n; i++) {
    quantity[i] = 0;
  }
}

#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

#define RST_PIN     D3    // Reset pin for RC522
#define SS_PIN      D8    // SDA pin for RC522
#define SOIL_PIN    D0    // Analog pin for soil moisture sensor
#define BUZZER_PIN  D1    // Digital pin for buzzer

const char* ssid = "vivo 1802";
const char* password = "mahalakshmi";
const char* mqtt_server = "192.168.43.147"; // IP address of your MQTT broker

WiFiClient espClient;
PubSubClient client(espClient);

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance

MFRC522::MIFARE_Key key = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

bool waterDetected = false;

void setup() {
  Serial.begin(115200);
  delay(1000);

  WiFi.begin(ssid, password);

  Serial.print("Connecting to ");
  Serial.println(ssid);

  int retries = 0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
    retries++;
    if (retries > 10) {
      Serial.println("Connection failed. Check your credentials.");
      while (1) {
        delay(1000);
      }
    }
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  client.setServer(mqtt_server, 1883);

  SPI.begin();
  mfrc522.PCD_Init();

  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);

  Serial.println("RFID Ready!");
  Serial.println("Place your NFC card to read data...");
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
    byte block = 1;

    if (mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, block, &key, &(mfrc522.uid)) == MFRC522::STATUS_OK) {
      byte buffer[18];
      byte bufferSize = sizeof(buffer);

      MFRC522::StatusCode status = mfrc522.MIFARE_Read(block, buffer, &bufferSize);

      if (status == MFRC522::STATUS_OK) {
        Serial.println("Data read successfully:");
        Serial.write(buffer, bufferSize);
        client.publish("nfc_tag_data", buffer, bufferSize);
      } else {
        Serial.println("Error reading data from card");
      }

      mfrc522.PCD_StopCrypto1();
    } else {
      Serial.println("Authentication failed.");
    }

    mfrc522.PICC_HaltA();
    beep(BUZZER_PIN, 1000);
  }

  int moistureLevel = analogRead(SOIL_PIN);

  if (moistureLevel < 1000) {
    if (!waterDetected) {
      Serial.println("Urine detected!");
      client.publish("moisture_sensor_data", "Urine detected!");
      beep(BUZZER_PIN, 2000);
      waterDetected = true;
    }
  } else {
    waterDetected = false;
  }
}

void beep(int pin, int duration) {
  digitalWrite(pin, HIGH);
  delay(duration);
  digitalWrite(pin, LOW);
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP8266Client")) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

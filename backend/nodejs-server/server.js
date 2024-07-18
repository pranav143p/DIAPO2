const mqtt = require('mqtt');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./config/serviceAccountKey.json'); // Replace with the path to your serviceAccountKey.json file
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Replace with your MQTT broker information
const mqttServer = 'tcp://192.168.43.147'; // IP address or URL of the MQTT broker
const mqttPort = 1883; // MQTT port, default is 1883, change if necessary

// Define the topics you want to subscribe to (use the same topics as in ESP8266 code)
const nfcTagDataTopic = 'nfc_tag_data';
const moistureSensorDataTopic = 'moisture_sensor_data';
const client = mqtt.connect(mqttServer, {
    'clientId': 'VSCodeClient',
    port: mqttPort
});

// Firebase Firestore instance
const db = admin.firestore();

// Subscribe to the specified topics when connected
client.on('connect', () => {
    console.log('Connected to MQTT broker');
    // Subscribe to NFC tag data topic
    client.subscribe(nfcTagDataTopic, (err) => {
        if (err) {
            console.error('Failed to subscribe to NFC tag data topic:', err);
        } else {
            console.log('Subscribed to NFC tag data topic:', nfcTagDataTopic);
        }
    });

    // Subscribe to moisture sensor data topic
    client.subscribe(moistureSensorDataTopic, (err) => {
        if (err) {
            console.error('Failed to subscribe to moisture sensor data topic:', err);
        } else {
            console.log('Subscribed to moisture sensor data topic:', moistureSensorDataTopic);
        }
    });
});

// Handle incoming messages
client.on('message', async (topic, message) => {
    console.log('Received message on topic', topic, ':', message.toString());

    // Process the data based on the topic
    try {
        const data = message.toString();
        // Push the data to Firestore
        await db.collection(topic).add({ data });
        console.log('Data pushed to Firestore successfully.');
    } catch (error) {
        console.error('Error pushing data to Firestore:', error);
    }
});

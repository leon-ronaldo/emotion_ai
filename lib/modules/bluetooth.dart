// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smartwatch Data',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SmartwatchDataPage(),
//     );
//   }
// }

// class SmartwatchDataPage extends StatefulWidget {
//   @override
//   _SmartwatchDataPageState createState() => _SmartwatchDataPageState();
// }

// class _SmartwatchDataPageState extends State<SmartwatchDataPage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   late BluetoothDevice connectedDevice;
//   bool isScanning = false;
//   bool isConnected = false;
//   List<int> heartRateData = [];

//   @override
//   void initState() {
//     super.initState();
//     startScanning();
//   }

//   void startScanning() async {
//     setState(() {
//       isScanning = true;
//     });

//     flutterBlue.scanResults.listen((List<ScanResult> results) {
//       for (ScanResult result in results) {
//         if (result.device.name == 'YourSmartwatchName') {
//           connectToDevice(result.device);
//           break;
//         }
//       }
//     });

//     flutterBlue.startScan();
//   }

//   void connectToDevice(BluetoothDevice device) async {
//     setState(() {
//       connectedDevice = device;
//       isScanning = false;
//     });

//     await device.connect();
//     setState(() => isConnected = true);

//     discoverServices();
//   }

//   void discoverServices() async {
//     List<BluetoothService> services = await connectedDevice.discoverServices();
//     services.forEach((service) {
//       if (service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
//         service.characteristics.forEach((characteristic) {
//           if (characteristic.uuid.toString() ==
//               "00002a37-0000-1000-8000-00805f9b34fb") {
//             characteristic.setNotifyValue(true);
//             characteristic.value.listen((value) {
//               setState(() {
//                 heartRateData = value;
//               });
//             });
//           }
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smartwatch Data'),
//       ),
//       body: Center(
//         child: isConnected
//             ? Text(
//                 'Heart Rate: ${heartRateData.isEmpty ? "No data" : heartRateData[1]}')
//             : isScanning
//                 ? Text('Scanning for device...')
//                 : Text('Device not found'),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     flutterBlue.stopScan();
//     connectedDevice.disconnect();
//     }
// }

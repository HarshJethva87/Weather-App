import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/additional_info_item.dart';
import 'package:weather_app/widgets/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widgets/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
// For fatching Data to API
  Future<Map<String, dynamic>> getCurrentWeatherData() async {
    try {
      const cityName = "London";
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw 'An unexpected error found';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Weather App"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeatherData();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          //for facting data with loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final weatherData = data['list'][0];
          //Show current data
          final currentTemp = weatherData["main"]["temp"];
          //Show Sky data
          final currentSkyData = weatherData["weather"][0]["main"];
          //for show perssure
          final currentPressure = weatherData['main']['pressure'];
          //for show perssure
          final currentHumidity = weatherData['main']['humidity'];
          //for show perssure
          final currentWindSpeed = weatherData['wind']['speed'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 10.0,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Icon(
                                  currentSkyData == "Clouds" ||
                                          currentSkyData == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 75,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text("$currentSkyData",
                                    style: const TextStyle(fontSize: 22))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //For Space
                  const SizedBox(
                    height: 20.0,
                  ),
                  //Forecast Text
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),

                  //Fatch data in API using Listview.builder
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final hourlyForecastTime = data['list'][index + 1];
                        //convet to time
                        final time = DateTime.parse(
                          hourlyForecastTime['dt_txt'].toString(),
                        );
                        final hourlyForecastTemp =
                            data['list'][index + 1]['main']['temp'];
                        final hourlyForecastIcon =
                            data['list'][index + 1]['weather'][0]['main'];

                        return HourlyForeCastWidget(
                          time: DateFormat.jm().format(time),
                          temperature: hourlyForecastTemp.toString(),
                          icon: hourlyForecastIcon == "Clouds" ||
                                  hourlyForecastIcon == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  //For Space
                  const SizedBox(
                    height: 20.0,
                  ),
                  //Additional info text
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfoItem(
                        lableIcon: Icons.water_drop,
                        lableText: "Humidity",
                        lableValue: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                          lableIcon: Icons.air,
                          lableText: "Wind Speed",
                          lableValue: currentWindSpeed.toString()),
                      AdditionalInfoItem(
                          lableIcon: Icons.beach_access,
                          lableText: "pressure",
                          lableValue: currentPressure.toString())
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

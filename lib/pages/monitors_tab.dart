import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/themes.dart';

class MonitorsTab extends StatefulWidget {
  const MonitorsTab({super.key});

  @override
  State<MonitorsTab> createState() => _MonitorsTabState();
}

class _MonitorsTabState extends State<MonitorsTab> {
  final ApiClient apiClient = ApiClient();
  late List<Monitor> monitors;
  String errorMessage = '';
  late Future<Map<String, dynamic>> _response;

  @override
  void initState() {
    super.initState();
    _response = apiClient.getMonitors();
  }

  void parseResponse(Map<String, dynamic> result) {
    var monitorsObject = result["monitors"];
    monitors = [];
    for (var monitorObject in monitorsObject) {
      Monitor monitor = Monitor(
        id: monitorObject['id'],
        name: monitorObject['name'],
        description: monitorObject['description'],
        active: monitorObject['active'],
        maintenance: monitorObject['maintenance'],
      );
      monitors.add(monitor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            parseResponse(snapshot.data!);
            return ListView.builder(
                itemCount: monitors.length,
                itemBuilder: (context, index) {
                  return MonitorItem(monitor: monitors[index]);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MonitorItem extends StatelessWidget {
  const MonitorItem({
    super.key,
    required this.monitor,
  });

  final Monitor monitor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(18),
          color: themeColor.withAlpha(30),
        ),
        height: 100,
        child: ListTile(
          title: Text(
            monitor.name ?? '',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class Monitor {
  final int id;
  final bool active;
  final bool maintenance;
  String? name;
  String? description;
  String? type;
  String? url;
  String? hostname;
  List<Tag>? tags = [];

  Monitor({
    required this.id,
    required this.active,
    required this.maintenance,
    this.name,
    this.description,
    this.type,
    this.url,
    this.hostname,
    this.tags,
  });
}

class Tag {
  final int id;
  int? monitorId, tagId;
  final String name;
  String? value = '';
  final String color;

  Tag({
    required this.id,
    required this.name,
    required this.color,
    this.monitorId,
    this.tagId,
    this.value,
  });
}

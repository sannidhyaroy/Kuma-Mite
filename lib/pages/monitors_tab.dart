import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/enums.dart';
import 'package:kumamite/themes.dart';

class MonitorsTab extends StatefulWidget {
  const MonitorsTab({super.key});

  @override
  State<MonitorsTab> createState() => _MonitorsTabState();
}

class _MonitorsTabState extends State<MonitorsTab> {
  final ApiClient apiClient = ApiClient();
  late List<Monitor> monitors;
  late Future<Map<String, dynamic>> _response;

  @override
  void initState() {
    super.initState();
    _response = apiClient.getMonitors();
  }

  void _parseResponse(Map<String, dynamic> result) {
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
    monitors.sort(
      (a, b) => a.name.compareTo(b.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (snapshot.error is AccessTokenException) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _dialogBuilder(snapshot, context));
              return Center(
                child: Text('Nothing to see here...'),
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          } else if (snapshot.hasData) {
            _parseResponse(snapshot.data!);
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

  Future<void> _dialogBuilder(
      AsyncSnapshot<Map<String, dynamic>> snapshot, BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login to Uptime Kuma'),
          content: Text(snapshot.error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ignore'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}

class MonitorItem extends StatefulWidget {
  const MonitorItem({
    super.key,
    required this.monitor,
  });

  final Monitor monitor;

  @override
  State<MonitorItem> createState() => _MonitorItemState();
}

class _MonitorItemState extends State<MonitorItem> {
  final ApiClient apiClient = ApiClient();
  late Future<Map<String, dynamic>> _response;
  late List<Beats> beats = [];
  int heartBeatPopulation = 30;
  late MonitorStatus status;

  @override
  void initState() {
    super.initState();
    status = MonitorStatus.PENDING;
    _response = apiClient.getBeats(monitorId: widget.monitor.id);
  }

  void _parseBeats(Map<String, dynamic> result) {
    var beatsObject = result['monitor_beats'];
    beats = [];
    for (var beatObject in beatsObject) {
      Beats beats = Beats(
        id: beatObject['id'],
        important: beatObject['important'],
        monitorId: beatObject['monitor_id'],
        status: MonitorStatus.values
            .firstWhere((element) => element.value == beatObject['status']),
        msg: beatObject['msg'],
        time: beatObject['time'],
        ping: beatObject['ping'],
        duration: beatObject['duration'],
        downCount: beatObject['down_count'],
      );
      this.beats.add(beats);
    }
    _filterBeats();
    _setMonitorStatus();
  }

  void _filterBeats() {
    int diff = beats.length - heartBeatPopulation;
    if (diff > 0) {
      beats = beats.sublist(diff);
    } else if (diff < 0) {
      while (diff < 0) {
        beats.insert(
          0,
          Beats(
            id: null,
            important: null,
            monitorId: null,
            status: MonitorStatus.PENDING,
            msg: null,
            time: null,
            ping: null,
            duration: null,
            downCount: null,
          ),
        );
        diff++;
      }
    }
  }

  void _setMonitorStatus() {
    Beats recentBeat = beats.last;
    setState(() {
      status = recentBeat.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 90,
        child: ListTile(
          title: Text(
            widget.monitor.name,
            style: TextStyle(fontSize: 25),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: status != MonitorStatus.PENDING
                  ? (status == MonitorStatus.UP
                      ? Colors.tealAccent
                      : Colors.red)
                  : Colors.grey,
              border: Border.all(),
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              status != MonitorStatus.PENDING
                  ? (status == MonitorStatus.UP ? 'Up' : 'Down')
                  : 'Pending',
              style: TextStyle(fontSize: 20, fontVariations: fontBold),
            ),
          ),
          subtitle: FutureBuilder(
            future: _response,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text('Unable to load heartbeats');
                } else if (snapshot.hasData) {
                  print(snapshot.data!['monitor_beats']);
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _parseBeats(snapshot.data!));
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(heartBeatPopulation, (index) {
                      // TODO: Implement beats from fetched data
                      var beatStatus = beats[index].status;
                      return Container(
                        height: 25,
                        width: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: (beatStatus == MonitorStatus.UP)
                              ? Colors.green
                              : (beatStatus == MonitorStatus.DOWN
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                      );
                    }),
                  );
                } else {
                  return LinearProgressIndicator();
                }
              } else {
                return LinearProgressIndicator();
              }
            },
          ),
          enabled: widget.monitor.active,
          // trailing: Icon(Icons.navigate_next_outlined),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Theme.of(context).focusColor),
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
  final String name;
  String? description;
  String? type;
  String? url;
  String? hostname;
  int? status;
  List<Tag>? tags = [];
  List<Beats>? beats = [];

  Monitor({
    required this.id,
    required this.active,
    required this.maintenance,
    required this.name,
    this.description,
    this.type,
    this.url,
    this.hostname,
    this.status,
    this.tags,
    this.beats,
  });
}

class Beats {
  final int? id;
  final bool? important;
  final int? monitorId;
  final MonitorStatus status;
  final String? msg;
  final String? time;
  final int? ping;
  final int? duration;
  final int? downCount;

  Beats({
    required this.id,
    required this.important,
    required this.monitorId,
    required this.status,
    required this.msg,
    required this.time,
    required this.ping,
    required this.duration,
    required this.downCount,
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

import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab(
      {super.key, required this.errorMessage, required this.info});

  final String errorMessage;
  final dynamic info;

  @override
  Widget build(BuildContext context) {
    return errorMessage.isNotEmpty
        ? Center(child: Text('Error: $errorMessage'))
        : info != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Version: ${info['version']}'),
                    Text('Latest Version: ${info['latestVersion']}'),
                    Text('Is Container: ${info['isContainer']}'),
                    Text('Primary Base URL: ${info['primaryBaseURL']}'),
                    Text('Server Timezone: ${info['serverTimezone']}'),
                    Text(
                        'Server Timezone Offset: ${info['serverTimezoneOffset']}'),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator());
  }
}

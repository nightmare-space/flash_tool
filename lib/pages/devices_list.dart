import 'package:flash_tool/provider/devices_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeviceEntity {
  DeviceEntity(this.deviceID, this.deviceName);
  final String deviceID;
  final String deviceName;
}

class DevicesList extends StatefulWidget {
  @override
  _DevicesListState createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  @override
  void initState() {
    super.initState();
  }

  DevicesState devicesState;
  @override
  Widget build(BuildContext context) {
    devicesState = Provider.of(context, listen: true);
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 3 / 4,
          height: 48 * devicesState.devices.length.w.toDouble(),
          child: ListView.builder(
            padding: const EdgeInsets.all(0.0),
            itemCount: devicesState.devices.length,
            itemBuilder: (BuildContext c, int i) {
              // return Text('data');
              return SizedBox(
                child: Row(
                  children: <Widget>[
                    Radio<int>(
                      value: i,
                      groupValue: devicesState.deviceIndex,
                      onChanged: (int index) {
                        devicesState.deviceIndex = index;
                        devicesState
                            .setDevice(devicesState.devices[i].deviceID);
                        setState(() {});
                      },
                    ),
                    Text(
                      '${devicesState.devices[i].deviceID}  ${devicesState.devices[i].deviceName}',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

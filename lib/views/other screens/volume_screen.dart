import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:playtones/providers/volume_provider.dart';
import 'package:provider/provider.dart';

class VolumeScreen extends StatelessWidget {
  const VolumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final texttheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            iconSize: 40,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 22),
                child: Text(
                  'Volume',
                  style: TextStyle(
                    fontFamily: 'Font',
                    fontSize: texttheme.titleLarge!.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
              Consumer<VolumeProvider>(
                builder: (context, volumeProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.speaker_3,
                          color: Colors.grey,
                        ),
                        title: Text(
                          'Speaker',
                          style: TextStyle(
                            fontFamily: 'Font',
                            fontSize: texttheme.titleMedium!.fontSize,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Radio<bool>(
                          value: true,
                          groupValue: volumeProvider.isSpeaker,
                          onChanged: (value) {
                            Provider.of<VolumeProvider>(
                              context,
                              listen: false,
                            ).switchSpeakerOrHeadphone(value!, context);
                          },
                          activeColor: Color(0xFFFD0000),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(),
              Consumer<VolumeProvider>(
                builder: (context, volumeProvider, child) {
                  return volumeProvider.headsetState == HeadsetState.CONNECT
                      ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: const Icon(
                              CupertinoIcons.headphones,
                              color: Colors.grey,
                            ),
                            title: Text(
                              'Headphone',
                              style: TextStyle(
                                fontFamily: 'Font',
                                fontSize: texttheme.titleMedium!.fontSize,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Radio<bool>(
                              activeColor: Color(0xFFFD0000),
                              value: false,
                              groupValue: volumeProvider.isSpeaker,
                              onChanged: (value) {
                                Provider.of<VolumeProvider>(
                                  context,
                                  listen: false,
                                ).switchSpeakerOrHeadphone(value!, context);
                              },
                            ),
                          ),
                        ),
                      )
                      : Container();
                },
              ),
              SizedBox(height: size.height * 0.55),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Consumer<VolumeProvider>(
                  builder: (context, provider, _) {
                    return Slider(
                      inactiveColor: Colors.grey[900],
                      activeColor: Color(0xFFFD0000),
                      min: 0.0,
                      max: 1.0,
                      value: provider.currentVol ?? 0,
                      onChanged: (value) {
                        Provider.of<VolumeProvider>(
                          context,
                          listen: false,
                        ).changeVolume(value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

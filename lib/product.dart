import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';


List<CameraDescription> cameras;

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

/// This is the stateful widget that the main application instantiates.
class NewProduct extends StatefulWidget
{
  NewProduct({Key key}) : super(key: key);
  get _bakery => false;
  get _pastry => false;
  get _sell   => false;
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<NewProduct>
{
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady = false;
  bool showCamera = true;
  String imagePath;
  // Inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController abvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget imagePreviewWidget() {
    return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: imagePath == null
                ? null
                : SizedBox(
              child: Image.file(File(imagePath)),
              height: 290.0,
            ),
          ),
        ));
  }
  // ignore: non_constant_identifier_names
  String dropdownValue = 'Fournisseur1';
  bool _bakery  = false;
  bool _pastry  = false;
  bool _sell    = false;
  set setBakery(bool){
    _bakery = bool;
  }
  set setPastry(bool){
    _pastry = bool;
  }
  set setSell(bool){
    _sell = bool;
  }

  Widget editCaptureControlRowWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: () => setState(() {
            showCamera = true;
          }),
        ),
      ),
    );
  }

  void showInSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          showCamera = false;
          imagePath = filePath;
        });
      }
    });
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showInSnackBar('Camera error ${e}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget ProductForms()
  {
    return Column(
        children: [ SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[


        Container(
        width: 350,
        padding: EdgeInsets.all(10),
          child: Form(
            child: SingleChildScrollView(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.fastfood),
                    hintText: 'Nom ou Référence du produit',
                    labelText: "Nom"),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Entrez une valeur';
                    return null;
                  }
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Prix Unitaire",
                    labelText: "Prix",
                    icon: Icon(Icons.attach_money)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Entrez un prix';
                    return null;
                  }
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.functions),
                    hintText: "Unité de mesure",
                    labelText: "Unité"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Entrez une unite de mesure';
                    return null;
                  }
                ),

                new Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [

                    FilterChip(
                      selected: _bakery,
                      label: Text('Boulangerie'),
                      labelStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.teal,
                      selectedColor: Colors.tealAccent,
                      avatar: Text('B', style: TextStyle(color: Colors.white)),
                      onSelected: (bool selected) {
                        setState(() {
                          setBakery = !_bakery;
                        });
                      }
                    ),


                    FilterChip(
                      selected: _pastry,
                      label: Text('Pâtisserie'),
                      labelStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.green,
                      selectedColor: Colors.greenAccent,
                      avatar: Text('P', style: TextStyle(color: Colors.white)),
                      onSelected: (bool selected) {
                        setState(() {
                          setPastry = !_pastry;
                        });
                      }
                    ),

                    FilterChip(
                      selected: _sell,
                      label: Text('Vente'),
                      labelStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.pink,
                      selectedColor: Colors.pinkAccent,
                      avatar: Text('V', style: TextStyle(color: Colors.white)),
                      onSelected: (bool selected){
                        setState(() {
                          setSell = !_sell;
                        });
                      },
                  ),


                    new Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [

                        new DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.person),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepOrange),
                          underline: Container(
                            height: 2,
                            color: Colors.deepOrangeAccent),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['Fournisseur1',
                                            'Fournisseur2',
                                            'Fournisseur3',
                                            'Fournisseur4'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value));}).toList(),
                        )
                    ]
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Process data.
                        }
                      },
                      child: Text('Ajouter')))
                ],
              ),
            ],
          )
        )
      )
    ),
    ]
    )
      )]
  );
}

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: showCamera ? Container(
                  height: 290,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Center(child: cameraPreviewWidget()),
                  ) ,
                ) : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        imagePreviewWidget(),
                        editCaptureControlRowWidget(),
                      ]),
                  ),
                  showCamera ? captureControlRowWidget() : Container(),
                  ProductForms()
        ])
    )));
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_services.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  File? _passportImage;
  File? _governmentIdImage;
  File? _resumeFile;
  String? _addressLine1;
  String? _addressLine2;
  String? _phoneNumber;

  Future<void> _getImage(ImageSource source, Function(File?) setImage) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        setImage(File(pickedFile.path));
      }
    });
  }

  Future<void> _getResumeFile(Function(File?) setFile) async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        setFile(File(result.files.single.path!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [_buildImagePicker(
              labelText: 'Passport Picture',
              onChanged: (value) {},
              setImage: (file) {
                setState(() {
                  _passportImage = file;
                });
              },
              image: _passportImage,
            ),
              _buildImagePicker(
                labelText: 'Government ID',
                onChanged: (value) {},
                setImage: (file) {
                  setState(() {
                    _governmentIdImage = file;
                  });
                },
                image: _governmentIdImage,
              ),

              _buildFilePicker(
                labelText: 'Resume',
                onChanged: (value) {},
                setFile: (file) {
                  _resumeFile = file;
                },
              ),
              _buildTextFormField(
                labelText: 'Address Line 1',
                onChanged: (value) {
                  setState(() {
                    _addressLine1 = value;
                  });
                },
              ),
              _buildTextFormField(
                labelText: 'Address Line 2',
                onChanged: (value) {
                  setState(() {
                    _addressLine2 = value;
                  });
                },
              ),
              _buildTextFormField(
                labelText: 'Phone Number',
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    Map<String, dynamic> result = await ProfileServices.saveProfile(
                      passportImage: _passportImage,
                      governmentIdImage: _governmentIdImage,
                      resumeFile: _resumeFile,
                      addressLine1: _addressLine1,
                      addressLine2: _addressLine2,
                      phoneNumber: _phoneNumber,
                    );

                    if (result['success']) {
                      // Handle success
                      print('Profile saved successfully');
                    } else {
                      // Handle error
                      print('Failed to save profile: ${result['error']}');
                    }
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildImagePicker({
    required String labelText,
    required Function(String?) onChanged,
    required Function(File?) setImage,
    required File? image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _getImage(ImageSource.gallery, setImage);
          },
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: _buildImagePreview(image),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }


  Widget _buildFilePicker({
    required String labelText,
    required Function(String?) onChanged,
    required Function(File?) setFile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _getResumeFile(setFile);
          },
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: _resumeFile != null
                  ? Text('File selected: ${_resumeFile!.path}')
                  : Icon(Icons.upload_file, size: 40),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required Function(String?) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          onChanged: (value) => onChanged(value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePreview(File? image) {
    return image != null ? Image.file(image) : Icon(Icons.camera_alt, size: 40);
  }
}

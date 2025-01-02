import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../blocs/admin_product/admin_product_form_bloc.dart';

class AdminEditProduct extends StatefulWidget {
  const AdminEditProduct({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDesc,
  });
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productDesc;

  @override
  State<AdminEditProduct> createState() => _AdminEditProductState();
}

class _AdminEditProductState extends State<AdminEditProduct> {
  FilePickerResult? _filePickerResult;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController productNamecontroller;
  late TextEditingController pricecontroller;
  late TextEditingController quantitycontroller;
  late TextEditingController productDescriptioncontroller;

  @override
  void initState() {
    productNamecontroller = TextEditingController(text: widget.productName);
    pricecontroller =
        TextEditingController(text: (widget.productPrice).toString());
    quantitycontroller =
        TextEditingController(text: (widget.productQuantity).toString());
    productDescriptioncontroller =
        TextEditingController(text: widget.productDesc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AdminProductFormBloc>(context);

    return BlocConsumer<AdminProductFormBloc, AdminProductFormState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Product'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          controller: productNamecontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'product_name',
                          decoration: InputDecoration(
                              labelText: 'Product Name',
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red.shade900)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontSize: 15.0),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade900,
                                      width: 1.5))),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                            FormBuilderValidators.maxLength(15),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          controller: pricecontroller,
                          name: 'price',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              labelText: 'Price',
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red.shade900)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontSize: 15.0),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade900,
                                      width: 1.5))),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0.01),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          name: 'quantity',
                          controller: quantitycontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              labelText: 'Quantity',
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red.shade900)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontSize: 15.0),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade900,
                                      width: 1.5))),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(1),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          name: 'product_description',
                          controller: productDescriptioncontroller,
                          style: const TextStyle(
                            height: 5,
                          ),
                          cursorHeight: 30,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              labelText: 'Product Description',
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red.shade900)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontSize: 15.0),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade900,
                                      width: 1.5))),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(5)
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /// in formBuilderFilePicker many type of documents can be uploaded for different clicks.
                        /// in typeSelector - Many type of documents for different buttons can be uploaded
                        // EX: if user wants to upload image, pdf separately, it can be wrapped in one FormBuilderFilePicker
                        FormBuilderFilePicker(
                          name: 'image',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          typeSelectors: [
                            TypeSelector(
                                type: FileType.any,
                                selector: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown.shade400,
                                        foregroundColor: Colors.white),
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: true,
                                        type: FileType.image,
                                      );
                                      if (result != null) {
                                        if (result.files.length > 3) {
                                          result = FilePickerResult(
                                              result.files.sublist(0, 3));
                                        }
                                        setState(() {
                                          _filePickerResult = result;
                                        });
                                        print(
                                            'file picked: ${_filePickerResult!.files.length}');
                                      } else {
                                        print('no file selected');
                                      }
                                    },
                                    child: const Text('Upload image'))),
                          ],
                          validator: FormBuilderValidators.required(),
                        ),

                        _filePickerResult != null &&
                                _filePickerResult!.files.isNotEmpty
                            ? Row(
                                children: List.generate(
                                  _filePickerResult!.files.length,
                                  (index) {
                                    // Create a small container for each selected image
                                    File file = File(
                                        _filePickerResult!.files[index].path!);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        height: 50, // Set your desired height
                                        width: 50, // Set your desired width
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Update Product')),
                      ],
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}

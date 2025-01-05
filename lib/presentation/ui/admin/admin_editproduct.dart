import 'dart:io';

import 'package:e_commerce_application/data/models/admin_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../blocs/admin_product/admin_product_form_bloc.dart';

class AdminEditProduct extends StatefulWidget {
  const AdminEditProduct({
    super.key,
    required this.adminProdcutModel,
    required this.newProductImages,
  });

  final AdminProdcutModel adminProdcutModel;
  final List<dynamic> newProductImages;

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
    productNamecontroller =
        TextEditingController(text: widget.adminProdcutModel.productName);
    pricecontroller = TextEditingController(
        text: (widget.adminProdcutModel.productPrice).toString());
    quantitycontroller = TextEditingController(
        text: (widget.adminProdcutModel.productQuantity).toString());
    productDescriptioncontroller =
        TextEditingController(text: widget.adminProdcutModel.productDesc);
    super.initState();
  }

  _uploadNewProduct() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      if (result.files.length > 3) {
        result = FilePickerResult(result.files.sublist(0, 3));
      }
      setState(() {
        _filePickerResult = result;
      });
    } else {
      print('No files selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AdminProductFormBloc>(context);

    return BlocConsumer<AdminProductFormBloc, AdminProductFormState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is AdminProductEditSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Updated')));
        } else if (state is AdminProductEditErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
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
                                    onPressed: _uploadNewProduct,
                                    child: const Text('Upload image'))),
                          ],
                          validator: FormBuilderValidators.required(),
                        ),
                        if (_filePickerResult != null &&
                            _filePickerResult!.files.isNotEmpty)
                          Row(
                            children: List.generate(
                              _filePickerResult!.files.length,
                              (index) {
                                final file = _filePickerResult!.files[index];
                                final isLocalFile =
                                    file.path != null && file.path!.isNotEmpty;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: isLocalFile
                                            ? FileImage(File(file.path!))
                                            : NetworkImage(file.name)
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else if (widget
                            .adminProdcutModel.productUrls.isNotEmpty)
                          Row(
                            children: widget.adminProdcutModel.productUrls
                                .map((imageUrl) {
                              return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              bloc.add(AdminProductEditButtonClickEvent(
                                  adminProductModel: AdminProdcutModel(
                                      productDesc: productDescriptioncontroller.text.isNotEmpty
                                          ? productDescriptioncontroller.text
                                          : widget
                                              .adminProdcutModel.productDesc,
                                      productId:
                                          widget.adminProdcutModel.productId,
                                      productName: productNamecontroller.text.isNotEmpty
                                          ? productNamecontroller.text
                                          : widget
                                              .adminProdcutModel.productName,
                                      productPrice: double.tryParse(pricecontroller.text) ??
                                          widget.adminProdcutModel.productPrice,
                                      productQuantity:
                                          int.tryParse(quantitycontroller.text) ??
                                              widget.adminProdcutModel
                                                  .productQuantity,
                                      productUrls:
                                          widget.adminProdcutModel.productUrls),
                                  newProductImages: _filePickerResult != null
                                      ? _filePickerResult!.files
                                          .map((file) => File(file.path!))
                                          .toList()
                                      : []));
                            },
                            child: const Text('Update Product')),
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
